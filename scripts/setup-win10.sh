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

# ----------------------------- Ensure huggingface-cli via uv ---------------
echo "🔧 Checking Hugging Face CLI (huggingface-cli)..."

# Step 1: Repair broken huggingface-cli if it exists but doesn't work
if command -v huggingface-cli >/dev/null 2>&1; then
    if ! huggingface-cli --help >/dev/null 2>&1; then
        echo "   huggingface-cli exists but is broken. Repairing..."
        rm -f "$HOME/.local/bin/huggingface-cli" 2>/dev/null || true
    fi
fi

# Step 2: Check if everything is already good
if command -v huggingface-cli >/dev/null 2>&1; then
    echo "   ✅ huggingface-cli already installed and working. Skipping install."
else
    echo "   huggingface-cli not found. Installing via uv..."

    # uv check
    if command -v uv >/dev/null 2>&1; then
        echo "   uv already available — skipping uv installation."
    else
        echo "   Installing uv package manager..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
    fi

    # uv tool install puts the CLI entry point into ~/.local/bin
    # and manages its own isolated environment — no system Python needed.
    echo "   Installing huggingface-hub via uv tool..."
    uv tool install huggingface-hub

    # Make sure ~/.local/bin is on PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    # Refresh shell command cache
    hash -r
fi

# ----------------------------- Download QCOW2 ------------------------------
echo "📥 Downloading win10.qcow2 (large file) into $REPO_NAME/win10-image/ ..."
echo "    (This may take a while — progress bar will show)"

huggingface-cli download NullVoider/windows10-base win10.qcow2 --local-dir "$REPO_NAME/win10-image"

# ----------------------------- Final message -------------------------------
echo ""
echo "✅ SUCCESS!"
echo "   Repository cloned → $REPO_NAME/"
echo "   QCOW2 image ready at: $REPO_NAME/win10-image/win10.qcow2"
echo ""
echo "   Next time just run: cd $REPO_NAME && git pull"