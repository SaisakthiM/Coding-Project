# Paths to Python installations
$py12 = "$env:LocalAppData\Programs\Python\Python312\python.exe"
$py13 = "$env:LocalAppData\Programs\Python\Python313\python.exe"

# Virtual environment names
$envs = @(
    @{ Name = ".venv-12"; Python = $py12 },
    @{ Name = ".venv-13"; Python = $py13 }
)

# Delete old environments (if they exist)
foreach ($env in $envs) {
    if (Test-Path $env.Name) {
        Write-Host "🧹 Removing $($env.Name)..."
        Remove-Item -Recurse -Force $env.Name
    }
}

# Create virtual environments
foreach ($env in $envs) {
    Write-Host "📦 Creating $($env.Name)..."
    & $env.Python -m venv $env.Name
}

# Install requirements.txt in each
foreach ($env in $envs) {
    $pip = Join-Path $env.Name "Scripts\pip.exe"
    if (Test-Path $pip) {
        Write-Host "📦 Installing in $($env.Name)..."
        & $pip install -r requirements.txt
    } else {
        Write-Host "❌ pip not found in $($env.Name)"
    }
}
