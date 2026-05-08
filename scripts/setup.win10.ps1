# =============================================================================
# setup-win10.ps1
# One-command clone + automatic download of win10.qcow2 into win10-image/
# =============================================================================

$ErrorActionPreference = "Stop"

$GitHubRepo = "https://github.com/nullvoider07/windows10-base"
$RepoName   = "windows10-base"

Write-Host "🚀 Cloning GitHub repo: $GitHubRepo" -ForegroundColor Cyan

# ----------------------------- Clone with GitHub CLI -----------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ GitHub CLI (gh) is not installed." -ForegroundColor Red
    Write-Host "   Please install it from: https://cli.github.com" -ForegroundColor Yellow
    exit 1
}

if (Test-Path $RepoName) {
    Write-Host "   Repository already exists. Pulling latest changes..." -ForegroundColor Yellow
    Push-Location $RepoName
    git pull --depth=1
    Pop-Location
} else {
    gh repo clone $GitHubRepo $RepoName -- --depth=1
}

# ----------------------------- Create folder -------------------------------
$ImageDir = Join-Path $RepoName "win10-image"
if (-not (Test-Path $ImageDir)) {
    New-Item -ItemType Directory -Path $ImageDir -Force | Out-Null
    Write-Host "📁 Created folder: win10-image/" -ForegroundColor Cyan
}

# ----------------------------- Ensure uv is available ---------------------
Write-Host "🔧 Checking uv..." -ForegroundColor Cyan

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "   Installing uv package manager..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri "https://astral.sh/uv/install.ps1" -OutFile "uv-install.ps1"
    .\uv-install.ps1
    Remove-Item uv-install.ps1 -Force
} else {
    Write-Host "   uv already available — skipping installation." -ForegroundColor Green
}

# ----------------------------- Ephemeral venv for huggingface-cli ----------
Write-Host "🔧 Creating ephemeral venv for huggingface-cli..." -ForegroundColor Cyan

$HF_VENV = Join-Path ([System.IO.Path]::GetTempPath()) "hf-venv-$(Get-Random)"
uv venv $HF_VENV --quiet

Write-Host "   ✅ Temporary venv created." -ForegroundColor Green

# Install huggingface-hub
uv pip install --python "$HF_VENV\Scripts\python.exe" transformers --quiet
Write-Host "   ✅ huggingface-hub installed in ephemeral venv." -ForegroundColor Green

# ----------------------------- Download QCOW2 ------------------------------
Write-Host "📥 Downloading win10.qcow2 (large file) into $ImageDir ..." -ForegroundColor Cyan
Write-Host "    (This may take a while — progress bar will show)" -ForegroundColor Yellow

$hfPath = Join-Path $HF_VENV "Scripts\hf.exe"

& $hfPath download NullVoider/windows10-base win10.qcow2 --local-dir $ImageDir

# ----------------------------- Cleanup venv --------------------------------
Write-Host "🧹 Cleaning up ephemeral venv..." -ForegroundColor Cyan
Remove-Item -Recurse -Force $HF_VENV -ErrorAction SilentlyContinue

# ----------------------------- Final message -------------------------------
Write-Host ""
Write-Host "✅ SUCCESS!" -ForegroundColor Green
Write-Host "   Repository cloned → $RepoName\"
Write-Host "   QCOW2 image ready at: $ImageDir\win10.qcow2"
Write-Host ""
Write-Host "   Next time just run: cd $RepoName && git pull" -ForegroundColor Gray