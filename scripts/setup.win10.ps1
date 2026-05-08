# =============================================================================
# setup-win10.ps1
# One-command clone + automatic download of win10.qcow2 into win10-image/
# Windows PowerShell version (uses uv as recommended by Hugging Face)
# =============================================================================

param(
    [string]$GithubRepo = "https://github.com/nullvoider07/win10-base"
)

$RepoName = Split-Path $GithubRepo -Leaf

Write-Host "🚀 Cloning GitHub repo: $GithubRepo" -ForegroundColor Cyan

# ----------------------------- Clone with GitHub CLI -----------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ GitHub CLI (gh) is not installed. Please install it first:" -ForegroundColor Red
    Write-Host "   https://cli.github.com" -ForegroundColor Yellow
    exit 1
}

gh repo clone $GithubRepo $RepoName -- --depth=1

# ----------------------------- Create folder -------------------------------
Write-Host "📁 Creating folder: $RepoName/win10-image/" -ForegroundColor Cyan
New-Item -Path "$RepoName/win10-image" -ItemType Directory -Force | Out-Null

# ----------------------------- Ensure hf CLI via uv -----------------------
Write-Host "🔧 Checking Hugging Face CLI (hf)..." -ForegroundColor Cyan

if (-not (Get-Command hf -ErrorAction SilentlyContinue)) {
    Write-Host "❌ hf CLI not found. Installing via uv (recommended method)..." -ForegroundColor Yellow

    # Explicit uv check
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        Write-Host "   uv already available — skipping uv installation." -ForegroundColor Green
    }
    else {
        Write-Host "   Installing uv package manager..." -ForegroundColor Yellow
        irm https://astral.sh/uv/install.ps1 | iex

        # Refresh PATH for current session
        $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
    }

    Write-Host "   Installing huggingface-hub with uv..." -ForegroundColor Yellow
    uv pip install -U huggingface-hub

    # Refresh PATH again (hf CLI is usually available after this)
    $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"
}

# ----------------------------- Download QCOW2 ------------------------------
Write-Host "📥 Downloading win10.qcow2 (large file) into $RepoName/win10-image/ ..." -ForegroundColor Cyan
Write-Host "    (This may take a while — progress bar will show)" -ForegroundColor Cyan

hf download NullVoider/win10-base win10.qcow2 --local-dir "$RepoName/win10-image"

# ----------------------------- Final message -------------------------------
Write-Host ""
Write-Host "✅ SUCCESS!" -ForegroundColor Green
Write-Host "   Repository cloned → $RepoName/" -ForegroundColor Green
Write-Host "   QCOW2 image ready at: $RepoName/win10-image/win10.qcow2" -ForegroundColor Green
Write-Host ""
Write-Host "   Next time just run: cd $RepoName && git pull" -ForegroundColor Green