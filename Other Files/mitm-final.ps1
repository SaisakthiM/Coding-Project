# MITMProxy Docker Setup Script
# Run this in an elevated PowerShell (Run as Administrator)

param (
    [int]$MitmPort = 8080
)

Write-Host "[*] Setting up mitmproxy Docker proxy..." -ForegroundColor Cyan

# Paths
$DockerCertsDir = "C:\ProgramData\Docker\certs.d\registry-1.docker.io"
$MitmCert = "$env:USERPROFILE\.mitmproxy\mitmproxy-ca-cert.pem"
$DockerSettingsPath = "$env:APPDATA\Docker\settings.json"

# Create Docker certs directory if it doesn't exist
if (-not (Test-Path $DockerCertsDir)) {
    Write-Host "[*] Creating Docker certs directory..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $DockerCertsDir -Force | Out-Null
}

# Copy MITM certificate to Docker certs
if (-not (Test-Path $MitmCert)) {
    Write-Host "[!] mitmproxy CA not found. Make sure mitmproxy has generated its CA." -ForegroundColor Red
    exit 1
}

Copy-Item -Path $MitmCert -Destination "$DockerCertsDir\ca.crt" -Force
Write-Host "[*] Mitmproxy CA copied to Docker certs." -ForegroundColor Green

# Configure Docker Desktop proxy settings
if (-not (Test-Path $DockerSettingsPath)) {
    Write-Host "[*] Docker settings file not found, creating one..." -ForegroundColor Cyan
    '{}' | Set-Content -Encoding UTF8 $DockerSettingsPath
}

# Load settings JSON
$SettingsJson = Get-Content $DockerSettingsPath -Raw
$Settings = $SettingsJson | ConvertFrom-Json

# Ensure 'proxies' exists and is a hashtable
if (-not $Settings.PSObject.Properties.Name -contains "proxies" -or $Settings.proxies -eq $null) {
    $Settings | Add-Member -MemberType NoteProperty -Name "proxies" -Value @{}
} elseif (-not ($Settings.proxies -is [hashtable])) {
    $Settings.proxies = @{}
}

# Set default proxy
$Settings.proxies["default"] = @{
    httpProxy  = "http://127.0.0.1:$MitmPort"
    httpsProxy = "http://127.0.0.1:$MitmPort"
    noProxy    = "localhost,127.0.0.1"
}

# Save updated settings
$Settings | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $DockerSettingsPath
Write-Host "[*] Docker Desktop proxy configured to use mitmproxy on port $MitmPort." -ForegroundColor Green

# Add mitmproxy CA to Windows Trusted Root
Write-Host "[*] Adding mitmproxy CA to Windows Trusted Root..." -ForegroundColor Cyan
certutil -addstore -f "Root" $MitmCert
Write-Host "[*] CA added successfully." -ForegroundColor Green

Write-Host "[*] Setup complete!" -ForegroundColor Cyan
Write-Host "    - Quit Docker Desktop completely and reopen it." -ForegroundColor Yellow
Write-Host "    - Ensure mitmproxy is running on 127.0.0.1:$MitmPort." -ForegroundColor Yellow
Write-Host "    - Test with: docker pull hello-world" -ForegroundColor Yellow
