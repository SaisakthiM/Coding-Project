# -------------------------------
# PowerShell Setup Script
# -------------------------------

# 1️⃣ Ensure PSGallery is registered and trusted
if (-not (Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" })) {
    Write-Host "Registering PSGallery..."
    Register-PSRepository -Name PSGallery -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted
} else {
    Write-Host "PSGallery already registered."
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# 2️⃣ Install posh-git & oh-my-posh
$modules = @("posh-git", "oh-my-posh", "PowerShell.MCP")
foreach ($mod in $modules) {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Write-Host "Installing $mod..."
        Install-Module -Name $mod -Force -AllowClobber
    } else {
        Write-Host "$mod already installed."
    }
}

# 3️⃣ Import modules
Import-Module posh-git -ErrorAction SilentlyContinue
Import-Module oh-my-posh -ErrorAction SilentlyContinue
Import-Module PowerShell.MCP -ErrorAction SilentlyContinue

# 4️⃣ Set Oh-My-Posh theme
try {
    Set-PoshPrompt -Theme Paradox
} catch {
    Write-Warning "Failed to set theme. Make sure oh-my-posh is imported correctly."
}

# 5️⃣ Placeholder instructions for MCP manual modules
Write-Host "`n⚡ Manual MCP Modules Setup:"
Write-Host "1. dfinke/mcp-powershell-exec:"
Write-Host "   git clone https://github.com/dfinke/mcp-powershell-exec.git C:\Tools\mcp-powershell-exec"
Write-Host "   Import-Module C:\Tools\mcp-powershell-exec\src`n"
Write-Host "2. maithaen-pwsh-mcp:"
Write-Host "   pip install maithaen-pwsh-mcp`n"

Write-Host "✅ Setup script finished. Open a new PowerShell session to see your new prompt!"
