# -----------------------------------------------
# Full Nerd Font + Oh-My-Posh Setup Script
# -----------------------------------------------

# 1️⃣ Set execution policy (if not already)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# 2️⃣ Install Oh-My-Posh and posh-git (if missing)
Install-Module posh-git -Force -AllowClobber
Install-Module oh-my-posh -Force -AllowClobber

# Import modules
Import-Module posh-git
Import-Module oh-my-posh

# 3️⃣ Download and install JetBrains Mono Nerd Font
$fontName = "JetBrainsMono NF"
$fontZip = "$env:TEMP\JetBrainsMono.zip"
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
$extractPath = "$env:TEMP\JetBrainsMono"

Write-Host "Downloading Nerd Font..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip

Write-Host "Extracting font..." -ForegroundColor Cyan
Expand-Archive -Path $fontZip -DestinationPath $extractPath -Force

Write-Host "Installing font files..." -ForegroundColor Cyan
Get-ChildItem -Path $extractPath -Filter "*.ttf" | ForEach-Object {
    $dest = "$env:WINDIR\Fonts\$($_.Name)"
    Copy-Item $_.FullName $dest -Force
}

# 4️⃣ Set Oh-My-Posh theme
Set-PoshPrompt -Theme paradox

Write-Host "✅ Nerd Font installed and Oh-My-Posh theme set!"

# 5️⃣ Configure VS Code integrated terminal font
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# Load existing settings
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $settings = @{}
}

# Set integrated terminal font and profile
$settings."terminal.integrated.fontFamily" = $fontName
$settings."terminal.integrated.profiles.windows" = @{
    "PowerShell 7" = @{
        path = "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
    }
}
$settings."terminal.integrated.defaultProfile.windows" = "PowerShell 7"

# Save back
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath

Write-Host "✅ VS Code terminal configured with $fontName and PowerShell 7"
Write-Host "🔁 Restart VS Code and Windows Terminal to see changes."
