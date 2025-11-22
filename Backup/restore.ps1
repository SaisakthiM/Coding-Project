# NPM Restoration Script
# Run this after setting up Node.js on your new system

Write-Host "Starting package restoration..." -ForegroundColor Green

# Check if Node.js is installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Node.js is not installed!" -ForegroundColor Red
    Write-Host "Download from: https://nodejs.org/" -ForegroundColor Yellow
    exit
}

Write-Host "Node version: $(node --version)" -ForegroundColor Cyan
Write-Host "NPM version: $(npm --version)" -ForegroundColor Cyan

# Restore local packages (from package.json)
if (Test-Path package.json) {
    Write-Host "
Installing project dependencies..." -ForegroundColor Yellow
    npm install
    Write-Host "Local packages installed!" -ForegroundColor Green
} else {
    Write-Host "WARNING: package.json not found!" -ForegroundColor Red
}

# Restore global packages (optional)
Write-Host "
Global packages found in npm-packages-global.txt" -ForegroundColor Yellow
Write-Host "To install them, review the file and run:" -ForegroundColor Yellow
Write-Host "npm install -g <package-name>" -ForegroundColor Cyan

Write-Host "
Restoration complete!" -ForegroundColor Green
