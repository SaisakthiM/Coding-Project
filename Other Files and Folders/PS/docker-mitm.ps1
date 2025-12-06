# ===============================================
# docker-mitm.ps1
# Configure Docker Desktop to use mitmproxy
# ===============================================

# --- SETTINGS ---
$MitmCertPath = "$env:USERPROFILE\.mitmproxy\mitmproxy-ca-cert.pem"
$DockerCertsDir = "C:\ProgramData\Docker\certs.d\registry-1.docker.io"
$DockerSettingsPath = "C:\Users\$env:USERNAME\AppData\Roaming\Docker\settings.json"

Write-Host "[*] Starting Docker mitmproxy setup..."

# --- CHECK MITMPROXY CERTIFICATE ---
if (-Not (Test-Path $MitmCertPath)) {
    Write-Error "[!] Mitmproxy certificate not found at $MitmCertPath. Export it first."
    exit 1
} else {
    Write-Host "[*] Found mitmproxy certificate at $MitmCertPath"
}

# --- CREATE DOCKER CERTS DIRECTORY ---
if (-Not (Test-Path $DockerCertsDir)) {
    Write-Host "[*] Creating Docker certs directory at $DockerCertsDir..."
    New-Item -ItemType Directory -Force -Path $DockerCertsDir
} else {
    Write-Host "[*] Docker certs directory already exists."
}

# --- COPY MITMPROXY CERT TO DOCKER ---
Write-Host "[*] Copying mitmproxy CA certificate to Docker certs directory..."
Copy-Item -Path $MitmCertPath -Destination "$DockerCertsDir\ca.crt" -Force

# --- ENSURE DOCKER SETTINGS FILE EXISTS ---
if (-Not (Test-Path $DockerSettingsPath)) {
    Write-Host "[*] Docker settings file not found. Creating a new one..."
    New-Item -ItemType File -Force -Path $DockerSettingsPath
    Set-Content -Path $DockerSettingsPath -Value '{}'
}

# --- LOAD AND MODIFY DOCKER SETTINGS ---
$SettingsJson = Get-Content $DockerSettingsPath -Raw
$Settings = $SettingsJson | ConvertFrom-Json

if (-Not $Settings.proxies) { $Settings | Add-Member -MemberType NoteProperty -Name proxies -Value @{} }
if (-Not $Settings.proxies.default) { $Settings.proxies | Add-Member -MemberType NoteProperty -Name default -Value @{} }

$Settings.proxies.default.httpProxy = "http://127.0.0.1:8080"
$Settings.proxies.default.httpsProxy = "http://127.0.0.1:8080"
$Settings.proxies.default.noProxy = "localhost,127.0.0.1"

# --- SAVE SETTINGS ---
$Settings | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $DockerSettingsPath

Write-Host "[*] Docker proxy settings configured."

# --- PROMPT USER TO RESTART DOCKER ---
Write-Host "[*] Please restart Docker Desktop for changes to take effect."
Write-Host "[*] After Docker restarts, test with: docker pull hello-world"

Write-Host "[*] Setup complete!"
