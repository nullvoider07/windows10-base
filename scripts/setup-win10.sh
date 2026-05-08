# =============================================================================
# setup-win10.ps1
# One-command clone + automatic download of win10.qcow2 into win10-image/
# =============================================================================

$ErrorActionPreference = 'Stop' # Exit immediately if any command fails

$GithubRepo = "https://github.com/nullvoider07/windows10-base"
$RepoName = Split-Path $GithubRepo -Leaf

Write-Host "🚀 Cloning GitHub repo: $GithubRepo"

# ----------------------------- Clone with GitHub CLI -----------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ GitHub CLI (gh) is not installed. Please install it first:" -ForegroundColor Red
    Write-Host "   https://cli.github.com"
    exit 1
}

gh repo clone $GithubRepo $RepoName -- --depth=1

# ----------------------------- Create folder -------------------------------
Write-Host "📁 Creating folder: win10-image/"
$ImagePath = Join-Path $RepoName "win10-image"
New-Item -ItemType Directory -Force -Path $ImagePath | Out-Null

# ----------------------------- Ensure uv is available ---------------------
Write-Host "🔧 Checking uv..."

if (Get-Command uv -ErrorAction SilentlyContinue) {
    Write-Host "   uv already available — skipping installation."
} else {
    Write-Host "   Installing uv package manager..."
    Invoke-RestMethod -Uri https://astral.sh/uv/install.ps1 | Invoke-Expression
    $env:Path += ";$HOME\.cargo\bin;$HOME\.local\bin"
}

# ----------------------------- Ephemeral venv for huggingface-cli ----------
Write-Host "🔧 Creating ephemeral venv for huggingface-cli..."

$TempDir = [System.IO.Path]::GetTempPath()
$HfVenv = Join-Path $TempDir "hf-venv-$(New-Guid)"

# uv venv picks the correct current Python automatically
uv venv $HfVenv --quiet

# Install directly into the venv — no --system, no activation needed
uv pip install --python "$HfVenv\Scripts\python.exe" transformers --quiet

Write-Host "   ✅ huggingface-hub installed in ephemeral venv."

# ----------------------------- Download QCOW2 ------------------------------
Write-Host "📥 Downloading win10.qcow2 (large file) into $RepoName\win10-image\ ..."
Write-Host "    (This may take a while — progress bar will show)"

# Call huggingface-cli directly by its venv path — no PATH lookup, no cache
& "$HfVenv\Scripts\huggingface-cli.exe" download NullVoider/windows10-base win10.qcow2 --local-dir $ImagePath

# ----------------------------- Cleanup venv --------------------------------
Write-Host "🧹 Cleaning up ephemeral venv..."
Remove-Item -Recurse -Force $HfVenv

# ----------------------------- Final message -------------------------------
Write-Host ""
Write-Host "✅ SUCCESS!" -ForegroundColor Green
Write-Host "   Repository cloned → $RepoName\"
Write-Host "   QCOW2 image ready at: $RepoName\win10-image\win10.qcow2"
Write-Host ""
Write-Host "   Next time just run: cd $RepoName ; git pull"