#!/bin/bash
# =============================================================================
# setup-win10.sh
# One-command clone + automatic download of win10.qcow2 into win10-image/
# =============================================================================

set -e  # Exit immediately if any command fails

GITHUB_REPO="https://github.com/nullvoider07/windows10-base"
REPO_NAME=$(basename "$GITHUB_REPO")

echo "🚀 Cloning GitHub repo: $GITHUB_REPO"

# ----------------------------- Clone with GitHub CLI -----------------------
if ! command -v gh >/dev/null 2>&1; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first:"
    echo "   https://cli.github.com"
    exit 1
fi

gh repo clone "$GITHUB_REPO" "$REPO_NAME" -- --depth=1

# ----------------------------- Create folder -------------------------------
echo "📁 Creating folder: win10-image/"
mkdir -p "$REPO_NAME/win10-image"

# ----------------------------- Ensure uv is available ---------------------
echo "🔧 Checking uv..."

if command -v uv >/dev/null 2>&1; then
    echo "   uv already available — skipping installation."
else
    echo "   Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    hash -r
fi

# ----------------------------- Ephemeral venv for huggingface-cli ----------
# Create a temporary venv, install huggingface-hub into it, run the download,
# then delete the venv. This avoids all PATH/hash-cache/interpreter-mismatch
# issues caused by stale system-wide or tool-level installs.
echo "🔧 Creating ephemeral venv for huggingface-cli..."

HF_VENV="$(mktemp -d)/hf-venv"

# uv venv picks the correct current Python automatically
uv venv "$HF_VENV" --quiet

# Install directly into the venv — no --system, no activation needed
uv pip install --python "$HF_VENV" huggingface-hub --quiet

echo "   ✅ huggingface-hub installed in ephemeral venv."

# ----------------------------- Download QCOW2 ------------------------------
echo "📥 Downloading win10.qcow2 (large file) into $REPO_NAME/win10-image/ ..."
echo "    (This may take a while — progress bar will show)"

# Call huggingface-cli directly by its venv path — no PATH lookup, no cache
"$HF_VENV/bin/huggingface-cli" download NullVoider/windows10-base win10.qcow2 \
    --local-dir "$REPO_NAME/win10-image"

# ----------------------------- Cleanup venv --------------------------------
echo "🧹 Cleaning up ephemeral venv..."
rm -rf "$HF_VENV"

# ----------------------------- Final message -------------------------------
echo ""
echo "✅ SUCCESS!"
echo "   Repository cloned → $REPO_NAME/"
echo "   QCOW2 image ready at: $REPO_NAME/win10-image/win10.qcow2"
echo ""
echo "   Next time just run: cd $REPO_NAME && git pull"