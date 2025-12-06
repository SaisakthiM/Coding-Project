# Python Environment Restoration Script
# Run this after installing Python on your new system

Write-Host "Starting Python environment restoration..." -ForegroundColor Green

# Check if Python is installed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Python is not installed!" -ForegroundColor Red
    Write-Host "Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit
}

$pythonVersion = python --version
Write-Host "Python version: $pythonVersion" -ForegroundColor Cyan

# Check Python version compatibility
Write-Host "
Recommended Python version from backup:" -ForegroundColor Yellow
Get-Content python-versions.txt | Select-Object -First 1

# Create new virtual environment
Write-Host "
Creating virtual environment..." -ForegroundColor Yellow
python -m venv .venv-12

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\.venv-12\Scripts\Activate.ps1

# Upgrade pip
Write-Host "Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install packages from requirements.txt
if (Test-Path requirements.txt) {
    Write-Host "
Installing packages from requirements.txt..." -ForegroundColor Yellow
    pip install -r requirements.txt
    Write-Host "All packages installed!" -ForegroundColor Green
} else {
    Write-Host "WARNING: requirements.txt not found!" -ForegroundColor Red
}

Write-Host "
=== Restoration Complete ===" -ForegroundColor Green
Write-Host "Virtual environment: .venv-12" -ForegroundColor Cyan
Write-Host "To activate: .\.venv-12\Scripts\Activate.ps1" -ForegroundColor Cyan
