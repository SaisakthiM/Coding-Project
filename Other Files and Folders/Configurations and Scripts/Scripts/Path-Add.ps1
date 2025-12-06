# =========================================
# Script: add-to-path.ps1
# Adds installed compiler/interpreter binaries to system PATH
# =========================================

$root = "C:\Coding Project\Configurations and Scripts"

function Add-ToPath($folder){
    if (-not (Test-Path $folder)) {
        Write-Host "Warning: $folder does not exist!"
        return
    }
    $current = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if (-not $current.Split(';') -contains $folder) {
        [Environment]::SetEnvironmentVariable("Path", "$current;$folder", "Machine")
        Write-Host "Added $folder to PATH"
    } else {
        Write-Host "$folder already in PATH"
    }
}

# -------------------------
# NASM
# -------------------------
Add-ToPath "$root\NASM"

# -------------------------
# Python
# -------------------------
Add-ToPath "$root\Python"

# -------------------------
# OpenJDK (Java)
# Pick the folder that contains java.exe
$javaBin = Get-ChildItem -Path "$root\Java" -Recurse -Directory | Where-Object { Test-Path "$($_.FullName)\bin\java.exe" } | Select-Object -First 1
if ($javaBin) { Add-ToPath "$($javaBin.FullName)\bin" }

# -------------------------
# Go
# -------------------------
Add-ToPath "$root\Go\go\bin"

# -------------------------
# Node.js
$nodeBin = Get-ChildItem -Path "$root\NodeJS" -Recurse -Directory | Where-Object { Test-Path "$($_.FullName)\node.exe" } | Select-Object -First 1
if ($nodeBin) { Add-ToPath $nodeBin.FullName }

# -------------------------
# Ruby (if manually extracted)
Add-ToPath "$root\Ruby"

Write-Host "`nAll binaries added to PATH. Restart PowerShell to apply changes."
