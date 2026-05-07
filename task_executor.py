"""
task_executor_windows.py — REST API task executor for the Windows AI Agent environment.
"""

import difflib
import logging
import os
import re
import shutil
import subprocess
import threading
import time
import uuid
from http import HTTPStatus

from flask import Flask, jsonify, request
from waitress import serve

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

TASK_BASE_DIR = os.environ.get("TASK_BASE_DIR", r"C:\Users\AgentUser\tasks")
API_PORT      = int(os.environ.get("API_PORT", "9090"))
API_TOKEN     = os.environ.get("API_TOKEN", "")

# ---------------------------------------------------------------------------
# Logging  →  C:\Users\AgentUser\tasks\task_executor.log
# ---------------------------------------------------------------------------
os.makedirs(TASK_BASE_DIR, exist_ok=True)
LOG_FILE = os.path.join(TASK_BASE_DIR, "task_executor.log")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE, encoding="utf-8"),
        logging.StreamHandler(),
    ],
)
log = logging.getLogger("task_executor")

# ---------------------------------------------------------------------------
# In-memory task store
# ---------------------------------------------------------------------------
_tasks: dict[str, dict] = {}
_tasks_lock = threading.Lock()
_TASK_MAX_AGE = int(os.environ.get("TASK_MAX_AGE", "3600"))  # 1 hour default


def _evict_old_tasks() -> None:
    """Drop completed/failed tasks older than TASK_MAX_AGE seconds."""
    cutoff = time.monotonic() - _TASK_MAX_AGE
    with _tasks_lock:
        stale = [
            tid for tid, t in _tasks.items()
            if t["status"] not in ("pending", "running")
            and t.get("_created", 0) < cutoff
        ]
        for tid in stale:
            _tasks.pop(tid)

app = Flask(__name__)

def _check_auth() -> bool:
    """Return True if the request is authorised (or auth is disabled)."""
    if not API_TOKEN:
        return True  # auth disabled if no token configured
    auth = request.headers.get("Authorization", "")
    return auth == f"Bearer {API_TOKEN}"

# ===========================================================================
# Custom exceptions
# ===========================================================================

class _TaskTimeoutError(RuntimeError):
    """Raised by _run() when a subprocess exceeds its allotted time."""


# ===========================================================================
# Subprocess helper
# ===========================================================================

def _run(
    command: list[str] | str,
    cwd: str | None = None,
    timeout: int = 120,
    shell: bool = False,
) -> tuple[int, str, str]:
    """
    Run a command on Windows with a new process group so the entire child
    tree can be killed on timeout via taskkill /F /T /PID.

    • list[str]  →  all internal commands (git clone/checkout/apply/diff).
                    argv passed directly; no shell, no injection.
    • shell=True →  user-supplied test_command and lint_command only.

    Windows-specific notes:
      • CREATE_NEW_PROCESS_GROUP isolates the child in its own process group.
        start_new_session and creationflags are mutually exclusive on Windows;
        we use creationflags exclusively here.
      • taskkill /F /T /PID forcefully terminates the process tree — the
        Windows equivalent of POSIX os.killpg(SIGKILL).

    Raises _TaskTimeoutError on timeout.
    Returns (exit_code, stdout, stderr).
    """
    proc = subprocess.Popen(
        command,
        cwd=cwd,
        shell=shell,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=os.environ.copy(),
        creationflags=subprocess.CREATE_NEW_PROCESS_GROUP,
    )
    try:
        out, err = proc.communicate(timeout=timeout)
        return proc.returncode, out, err
    except subprocess.TimeoutExpired:
        subprocess.run(
            ["taskkill", "/F", "/T", "/PID", str(proc.pid)],
            capture_output=True,
        )
        proc.wait()
        raise _TaskTimeoutError(f"Command timed out after {timeout}s")


# ===========================================================================
# Test result parsers
# ===========================================================================

def _parse_pytest(text: str) -> tuple[int, int]:
    passed, failed = 0, 0
    m = re.search(r"(\d+)\s+passed", text)
    if m:
        passed = int(m.group(1))
    m = re.search(r"(\d+)\s+failed", text)
    if m:
        failed = int(m.group(1))
    m = re.search(r"(\d+)\s+error", text)
    if m:
        failed += int(m.group(1))
    return passed, failed


def _parse_cargo(text: str) -> tuple[int, int]:
    passed, failed = 0, 0
    for m in re.finditer(r"test result:.*?(\d+)\s+passed;\s*(\d+)\s+failed", text):
        passed += int(m.group(1))
        failed += int(m.group(2))
    return passed, failed


def _parse_go(text: str) -> tuple[int, int]:
    passed = len(re.findall(r"^--- PASS:", text, re.MULTILINE))
    failed = len(re.findall(r"^--- FAIL:", text, re.MULTILINE))
    if passed == 0 and failed == 0:
        passed = len(re.findall(r"^ok\s+\S+",   text, re.MULTILINE))
        failed = len(re.findall(r"^FAIL\s+\S+", text, re.MULTILINE))
    return passed, failed


def _parse_jest(text: str) -> tuple[int, int]:
    passed, failed = 0, 0
    m = re.search(r"^Tests:\s+(.+)$", text, re.MULTILINE)
    if m:
        summary = m.group(1)
        p = re.search(r"(\d+)\s+passed", summary)
        f = re.search(r"(\d+)\s+failed", summary)
        if p:
            passed = int(p.group(1))
        if f:
            failed = int(f.group(1))
    return passed, failed


def _parse_dotnet(text: str) -> tuple[int, int]:
    passed, failed = 0, 0
    m = re.search(r"Failed:\s*(\d+),\s*Passed:\s*(\d+)", text)
    if m:
        failed = int(m.group(1))
        passed = int(m.group(2))
    return passed, failed


def _parse_junit(text: str) -> tuple[int, int]:
    passed_total = failed_total = 0
    for m in re.finditer(
        r"Tests run:\s*(\d+),\s*Failures:\s*(\d+),\s*Errors:\s*(\d+)", text
    ):
        run      = int(m.group(1))
        failures = int(m.group(2))
        errors   = int(m.group(3))
        failed_total += failures + errors
        passed_total += max(run - failures - errors, 0)
    return passed_total, failed_total


def _dispatch_test_parser(test_command: str, text: str) -> tuple[int, int]:
    cmd = test_command.lower()
    if "pytest" in cmd or "py.test" in cmd:
        return _parse_pytest(text)
    if "cargo" in cmd:
        return _parse_cargo(text)
    if "go test" in cmd:
        return _parse_go(text)
    if (
        "jest" in cmd
        or ("npm" in cmd and "test" in cmd)
        or ("yarn" in cmd and "test" in cmd)
        or ("pnpm" in cmd and "test" in cmd)
    ):
        return _parse_jest(text)
    if "dotnet" in cmd:
        return _parse_dotnet(text)
    if "mvn" in cmd or "gradle" in cmd or "sbt" in cmd or "junit" in cmd:
        return _parse_junit(text)
    for parser in (
        _parse_pytest, _parse_cargo, _parse_go,
        _parse_jest, _parse_dotnet, _parse_junit,
    ):
        p, f = parser(text)
        if p or f:
            return p, f
    return 0, 0


# ===========================================================================
# Lint error parser
# ===========================================================================

def _parse_lint_errors(lint_command: str, text: str, exit_code: int) -> int:
    """
    Extract an error count from linter output.
    Soft scoring only — never changes task status.
    """
    cmd = lint_command.lower()

    if "ruff" in cmd:
        m = re.search(r"Found\s+(\d+)\s+error", text)
        if m:
            return int(m.group(1))
        if "--output-format json" in cmd or "-o json" in cmd:
            try:
                import json
                return len(json.loads(text))
            except Exception:
                pass

    if "flake8" in cmd:
        return len([l for l in text.splitlines() if re.match(r".+:\d+:\d+:\s+[EWF]", l)])

    if "mypy" in cmd:
        m = re.search(r"Found\s+(\d+)\s+error", text)
        if m:
            return int(m.group(1))
        return text.count(": error:")

    if "pylint" in cmd:
        return len(re.findall(r"^\S+:\d+:\d+:\s+[EF]\d{4}:", text, re.MULTILINE))

    if "clippy" in cmd or ("cargo" in cmd and "check" in cmd):
        return len(re.findall(r"^error\[", text, re.MULTILINE))

    if "eslint" in cmd:
        if "--format json" in cmd or "-f json" in cmd:
            try:
                import json
                data = json.loads(text)
                return sum(
                    sum(1 for msg in f.get("messages", []) if msg.get("severity") == 2)
                    for f in data
                )
            except Exception:
                pass
        m = re.search(r"(\d+)\s+error", text)
        return int(m.group(1)) if m else 0

    if "go vet" in cmd or "staticcheck" in cmd:
        return len([l for l in text.splitlines() if l.strip()])

    if "clang-tidy" in cmd or "cppcheck" in cmd:
        return len(re.findall(r"\berror\b", text, re.IGNORECASE))

    if "dotnet" in cmd and "build" in cmd:
        m = re.search(r"(\d+)\s+Error\(s\)", text)
        return int(m.group(1)) if m else 0

    if exit_code != 0:
        return len(re.findall(r"\berror\b", text, re.IGNORECASE))
    return 0


# ===========================================================================
# Patch normaliser + similarity scorer
# ===========================================================================

def _normalise_patch(patch: str) -> list[str]:
    kept: list[str] = []
    for line in patch.splitlines():
        if (
            line.startswith("diff ")
            or line.startswith("index ")
            or line.startswith("--- ")
            or line.startswith("+++ ")
            or line.startswith("@@ ")
        ):
            continue
        kept.append(line)
    return kept


def _patch_similarity(agent_patch: str, reference_patch: str) -> float:
    a = _normalise_patch(agent_patch)
    b = _normalise_patch(reference_patch)
    if not a and not b:
        return 1.0
    if not a or not b:
        return 0.0
    return difflib.SequenceMatcher(None, a, b).ratio()


# ===========================================================================
# Core task executor
# ===========================================================================

def _execute(
    task_id:          str,
    repo_url:         str,
    base_commit:      str,
    patch:            str,
    test_command:     str,
    timeout:          int,
    lint_command:     str,
    capture_diff:     bool,
    reference_patch:  str,
) -> None:
    task_dir   = os.path.join(TASK_BASE_DIR, task_id)
    repo_dir   = os.path.join(task_dir, "repo")
    patch_file = os.path.join(task_dir, "task.patch")

    stdout_parts: list[str] = []
    stderr_parts: list[str] = []
    start = time.monotonic()

    final_update: dict = {
        "status":           "failed",
        "exit_code":        -1,
        "stdout":           "",
        "stderr":           "",
        "tests_passed":     0,
        "tests_failed":     0,
        "lint_errors":      None,
        "lint_output":      None,
        "patch_diff":       None,
        "patch_similarity": None,
        "execution_time":   0.0,
    }

    def _update(**kw: object) -> None:
        with _tasks_lock:
            _tasks[task_id].update(kw)

    _update(status="running")

    try:
        os.makedirs(task_dir, exist_ok=True)

        rc, out, err = _run(["git", "clone", repo_url, repo_dir], timeout=120)
        stdout_parts.append(out); stderr_parts.append(err)
        if rc != 0:
            raise RuntimeError(f"git clone failed (rc={rc}): {err.strip()}")

        rc, out, err = _run(["git", "checkout", base_commit], cwd=repo_dir, timeout=60)
        stdout_parts.append(out); stderr_parts.append(err)
        if rc != 0:
            raise RuntimeError(f"git checkout failed (rc={rc}): {err.strip()}")

        if patch and patch.strip():
            with open(patch_file, "w", encoding="utf-8") as fh:
                fh.write(patch)
            rc, out, err = _run(["git", "apply", patch_file], cwd=repo_dir, timeout=30)
            stdout_parts.append(out); stderr_parts.append(err)
            if rc != 0:
                raise RuntimeError(f"git apply failed (rc={rc}): {err.strip()}")

        rc, out, err = _run(test_command, cwd=repo_dir, timeout=timeout, shell=True)
        stdout_parts.append(out); stderr_parts.append(err)
        test_exit_code = rc

        combined_stdout = "\n".join(filter(None, stdout_parts))
        combined_stderr = "\n".join(filter(None, stderr_parts))
        passed, failed  = _dispatch_test_parser(
            test_command, combined_stdout + "\n" + combined_stderr
        )

        lint_errors_count: int | None = None
        lint_out:          str | None = None

        if lint_command and lint_command.strip():
            try:
                lint_rc, l_out, l_err = _run(
                    lint_command, cwd=repo_dir, timeout=120, shell=True
                )
                lint_out          = (l_out + "\n" + l_err).strip() or None
                lint_errors_count = _parse_lint_errors(
                    lint_command, lint_out or "", lint_rc
                )
                log.info("Task %s lint finished — rc=%d errors=%s",
                         task_id, lint_rc, lint_errors_count)
            except _TaskTimeoutError:
                lint_out          = "Lint timed out after 120s"
                lint_errors_count = None
                log.warning("Task %s lint timed out", task_id)
            except Exception as exc:
                lint_out          = f"Lint error: {exc}"
                lint_errors_count = None
                log.warning("Task %s lint exception: %s", task_id, exc)

        patch_diff_text: str | None = None

        if capture_diff or (reference_patch and reference_patch.strip()):
            try:
                _, diff_out, _ = _run(
                    ["git", "diff", base_commit], cwd=repo_dir, timeout=30
                )
                patch_diff_text = diff_out.strip() or None
            except Exception as exc:
                log.warning("Task %s git diff failed: %s", task_id, exc)

        similarity: float | None = None

        if reference_patch and reference_patch.strip():
            try:
                agent_diff = patch_diff_text or (patch if patch and patch.strip() else "")
                if agent_diff:
                    similarity = round(_patch_similarity(agent_diff, reference_patch), 4)
                    log.info("Task %s patch_similarity=%.4f", task_id, similarity)
            except Exception as exc:
                log.warning("Task %s similarity computation failed: %s", task_id, exc)

        final_update = {
            "status":           "completed",
            "exit_code":        test_exit_code,
            "stdout":           combined_stdout,
            "stderr":           combined_stderr,
            "tests_passed":     passed,
            "tests_failed":     failed,
            "lint_errors":      lint_errors_count,
            "lint_output":      lint_out,
            "patch_diff":       patch_diff_text,
            "patch_similarity": similarity,
            "execution_time":   round(time.monotonic() - start, 3),
        }

    except _TaskTimeoutError as exc:
        stderr_parts.append(str(exc))
        log.error("Task %s timed out after %ds", task_id, timeout)
        final_update.update({
            "stdout":         "\n".join(filter(None, stdout_parts)),
            "stderr":         "\n".join(filter(None, stderr_parts)),
            "execution_time": round(time.monotonic() - start, 3),
        })

    except Exception as exc:
        stderr_parts.append(str(exc))
        log.exception("Task %s failed: %s", task_id, exc)
        final_update.update({
            "stdout":         "\n".join(filter(None, stdout_parts)),
            "stderr":         "\n".join(filter(None, stderr_parts)),
            "execution_time": round(time.monotonic() - start, 3),
        })

    finally:
        _update(**final_update)
        try:
            shutil.rmtree(task_dir, ignore_errors=True)
        except Exception:
            pass


# ===========================================================================
# REST endpoints
# ===========================================================================

@app.route("/task/submit", methods=["POST"])
def submit():
    """
    POST /task/submit

    Body (JSON):
        repo_url          str   required
        base_commit       str   optional  (default: HEAD)
        patch             str   optional
        test_command      str   required
        timeout           int   optional  (default: 300)
        lint_command      str   optional
        capture_diff      bool  optional  (default: false)
        reference_patch   str   optional

    Returns 202: { "task_id": "<uuid>", "status": "pending" }
    """
    if not _check_auth():
        return jsonify(error="Unauthorized"), HTTPStatus.UNAUTHORIZED

    _evict_old_tasks()

    body = request.get_json(force=True, silent=True)
    if not body:
        return jsonify(error="Request body must be valid JSON"), HTTPStatus.BAD_REQUEST

    missing = [f for f in ("repo_url", "test_command") if not body.get(f)]
    if missing:
        return jsonify(error=f"Missing required fields: {missing}"), HTTPStatus.BAD_REQUEST

    task_id = str(uuid.uuid4())
    record: dict = {
        "task_id":          task_id,
        "status":           "pending",
        "_created":         time.monotonic(),
        "repo_url":         body["repo_url"],
        "base_commit":      body.get("base_commit", "HEAD"),
        "test_command":     body["test_command"],
        "timeout":          int(body.get("timeout", 300)),
        "exit_code":        None,
        "stdout":           None,
        "stderr":           None,
        "tests_passed":     None,
        "tests_failed":     None,
        "lint_errors":      None,
        "lint_output":      None,
        "patch_diff":       None,
        "patch_similarity": None,
        "execution_time":   None,
    }

    with _tasks_lock:
        _tasks[task_id] = record

    threading.Thread(
        target=_execute,
        args=(
            task_id,
            body["repo_url"],
            body.get("base_commit", "HEAD"),
            body.get("patch", ""),
            body["test_command"],
            int(body.get("timeout", 300)),
            body.get("lint_command", ""),
            bool(body.get("capture_diff", False)),
            body.get("reference_patch", ""),
        ),
        daemon=True,
    ).start()

    log.info("Task %s submitted — repo=%s", task_id, body["repo_url"])
    return jsonify(task_id=task_id, status="pending"), HTTPStatus.ACCEPTED


@app.route("/task/<task_id>", methods=["GET"])
def status(task_id: str):
    if not _check_auth():
        return jsonify(error="Unauthorized"), HTTPStatus.UNAUTHORIZED
    with _tasks_lock:
        t = _tasks.get(task_id)
    if t is None:
        return jsonify(error="Task not found"), HTTPStatus.NOT_FOUND
    return jsonify(task_id=t["task_id"], status=t["status"])


@app.route("/task/<task_id>/result", methods=["GET"])
def result(task_id: str):
    if not _check_auth():
        return jsonify(error="Unauthorized"), HTTPStatus.UNAUTHORIZED
    with _tasks_lock:
        t = _tasks.get(task_id)
    if t is None:
        return jsonify(error="Task not found"), HTTPStatus.NOT_FOUND
    if t["status"] in ("pending", "running"):
        return jsonify(
            task_id=task_id,
            status=t["status"],
            message="Task not yet complete — poll again shortly",
        ), HTTPStatus.ACCEPTED
    return jsonify(t)


@app.route("/task/<task_id>", methods=["DELETE"])
def delete(task_id: str):
    if not _check_auth():
        return jsonify(error="Unauthorized"), HTTPStatus.UNAUTHORIZED
    with _tasks_lock:
        if task_id not in _tasks:
            return jsonify(error="Task not found"), HTTPStatus.NOT_FOUND
        _tasks.pop(task_id)
    log.info("Task %s deleted", task_id)
    return jsonify(task_id=task_id, deleted=True)


if __name__ == "__main__":
    log.info("Task executor starting on 0.0.0.0:%d", API_PORT)
    serve(app, host="0.0.0.0", port=API_PORT, threads=16)
