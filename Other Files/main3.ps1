# -----------------------------------------------
# Minimal ASCII Prompt + MCP + Claude Setup
# -----------------------------------------------

# 1️⃣ Set execution policy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# 2️⃣ Install and import posh-git
Install-Module posh-git -Force -AllowClobber
Import-Module posh-git

# 3️⃣ Install and import oh-my-posh
winget install JanDeDobbeleer.OhMyPosh

# 4️⃣ Set ASCII-only theme
Set-PoshPrompt -Theme Robbyrussell  # fully ASCII, no glyphs

# 5️⃣ Install/Update Python MCP module for Claude
pip install --upgrade mcp

# 6️⃣ Create a simple helper function for Claude
Function Ask-Claude {
    param([string]$Prompt)
    try {
        $response = Invoke-MCPRequest -Prompt $Prompt -Model "claude-instant-v1"
        $response.Text
    } catch {
        Write-Host "⚠️ Error: Could not reach Claude. Check your MCP setup or API key." -ForegroundColor Red
    }
}

Write-Host "✅ Minimal ASCII setup complete!"
Write-Host "Use Ask-Claude 'Your question here' to query Claude."
Write-Host "Restart VS Code or Windows Terminal to see the changes."

