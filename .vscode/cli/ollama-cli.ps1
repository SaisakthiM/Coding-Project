<#
.SYNOPSIS
    Ollama CLI - Enhanced Terminal.Gui (TUI) interface for Ollama.
.DESCRIPTION
    Provides a rich, windowed chat interface for interacting with
    the Ollama API with improved UI, error handling, and features.
    FIXED: Proper event handling and focus management.
.NOTES
    Requires: 'Terminal.Gui' module or GUI.cs assembly
    PowerShell 7+ recommended for best experience
.PARAMETER Model
    Default model to use (default: codellama)
.PARAMETER ApiUrl
    Ollama API endpoint (default: http://localhost:11434)
.EXAMPLE
    .\Ollama-CLI-Enhanced.ps1 -Model llama3 -ApiUrl http://localhost:11434
#>

[CmdletBinding()]
param(
    [string]$Model = "codellama",
    [string]$ApiUrl = "http://localhost:11434"
)

#Requires -Version 5.1

# --- Global Job Variables for Async Fix ---
$global:OllamaJob = $null
$global:IsQuerying = $false
# ------------------------------------------

# --- Module Installation & Validation ---
function Install-TerminalGui {
    Write-Host "`n🔍 Checking for Terminal.Gui..." -ForegroundColor Cyan
    
    # Try to load Terminal.Gui module first
    try {
        Import-Module Terminal.Gui -ErrorAction Stop
        Write-Host "✓ Terminal.Gui module loaded!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "⚠ Terminal.Gui module not found, trying alternative..." -ForegroundColor Yellow
    }
    
    # Try Microsoft.PowerShell.ConsoleGuiTools and load its assembly
    try {
        if (-not (Get-Module -ListAvailable -Name Microsoft.PowerShell.ConsoleGuiTools)) {
            Write-Host "📦 Installing Microsoft.PowerShell.ConsoleGuiTools..." -ForegroundColor Cyan
            Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
        }
        
        Import-Module Microsoft.PowerShell.ConsoleGuiTools -Force
        
        # Find and load the Terminal.Gui assembly
        $module = Get-Module Microsoft.PowerShell.ConsoleGuiTools
        $modulePath = Split-Path $module.Path
        $guiAssembly = Get-ChildItem -Path $modulePath -Filter "Terminal.Gui.dll" -Recurse | Select-Object -First 1
        
        if ($guiAssembly) {
            Add-Type -Path $guiAssembly.FullName
            Write-Host "✓ Terminal.Gui loaded from ConsoleGuiTools!" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "⚠ ConsoleGuiTools approach failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Last resort: Try to install Terminal.Gui directly
    try {
        Write-Host "📦 Installing Terminal.Gui module..." -ForegroundColor Cyan
        Install-Module -Name Terminal.Gui -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
        Import-Module Terminal.Gui -Force
        Write-Host "✓ Terminal.Gui module installed and loaded!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ Failed to install Terminal.Gui" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n📝 Manual installation:" -ForegroundColor Yellow
        Write-Host "  Install-Module -Name Terminal.Gui -Force" -ForegroundColor White
        return $false
    }
}

if (-not (Install-TerminalGui)) {
    Write-Host "`n❌ Cannot load Terminal.Gui. Exiting..." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    return
}

# Verify Terminal.Gui is accessible
try {
    $null = [Terminal.Gui.Application]
    Write-Host "✓ Terminal.Gui types verified!" -ForegroundColor Green
}
catch {
    Write-Host "❌ Terminal.Gui types still not accessible!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    return
}

# --- Enhanced OllamaAgent Class ---
class OllamaAgent {
    [string]$ApiUrl
    [string]$Model
    [array]$Models = @()
    [string]$CurrentDir
    [array]$ContextFiles = @()
    [string]$ConfigDir
    [string]$SettingsFile
    [string]$HistoryFile
    [hashtable]$Settings
    [array]$ChatHistory = @()
    [string]$SystemPrompt = "You are a helpful AI assistant. Provide clear, concise, and practical responses."
    [int]$MaxHistoryItems = 100

    OllamaAgent([string]$ApiUrl, [string]$Model) {
        $this.ApiUrl = $ApiUrl
        $this.Model = $Model
        $this.CurrentDir = (Get-Location).Path
        $this.ConfigDir = Join-Path $env:USERPROFILE ".ollama-cli"
        $this.SettingsFile = Join-Path $this.ConfigDir "settings.json"
        $this.HistoryFile = Join-Path $this.ConfigDir "history.json"
        
        $this.Settings = @{
            Model = $Model
            ApiUrl = $ApiUrl
            AutoSave = $true
            Theme = "dark"
            SystemPrompt = $this.SystemPrompt
            Temperature = 0.7
            MaxTokens = 2048
        }

        $this.EnsureConfigDir()
        $this.LoadSettings()
        $this.LoadHistory()
        $this.LoadModels()
        
        # Apply loaded settings
        $this.Model = $this.Settings.Model
        $this.ApiUrl = $this.Settings.ApiUrl
        if ($this.Settings.SystemPrompt) {
            $this.SystemPrompt = $this.Settings.SystemPrompt
        }
    }

    [void]EnsureConfigDir() {
        if (!(Test-Path $this.ConfigDir)) {
            New-Item -ItemType Directory -Path $this.ConfigDir -Force | Out-Null
        }
    }

    [void]LoadSettings() {
        if (Test-Path $this.SettingsFile) {
            try {
                $loadedSettings = Get-Content $this.SettingsFile -Raw | ConvertFrom-Json -AsHashtable
                foreach ($key in $loadedSettings.Keys) {
                    $this.Settings[$key] = $loadedSettings[$key]
                }
            }
            catch {
                # Use defaults on error
            }
        }
    }

    [void]SaveSettings() {
        try {
            $this.Settings | ConvertTo-Json -Depth 10 | Set-Content $this.SettingsFile
        }
        catch {
            # Silently fail
        }
    }

    [void]LoadHistory() {
        if (Test-Path $this.HistoryFile) {
            try {
                $this.ChatHistory = Get-Content $this.HistoryFile -Raw | ConvertFrom-Json
                if ($this.ChatHistory.Count -gt $this.MaxHistoryItems) {
                    $this.ChatHistory = $this.ChatHistory[-$this.MaxHistoryItems..-1]
                }
            }
            catch {
                $this.ChatHistory = @()
            }
        }
    }

    [void]SaveHistory() {
        try {
            if ($this.Settings.AutoSave) {
                $this.ChatHistory | ConvertTo-Json -Depth 10 | Set-Content $this.HistoryFile
            }
        }
        catch {
            # Silently fail
        }
    }

    [void]AddToHistory([string]$Role, [string]$Content) {
        $this.ChatHistory += @{
            timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            role = $Role
            content = $Content
        }
        if ($this.ChatHistory.Count -gt $this.MaxHistoryItems) {
            $this.ChatHistory = $this.ChatHistory[-$this.MaxHistoryItems..-1]
        }
        $this.SaveHistory()
    }

    [void]LoadModels() {
        try {
            $response = Invoke-RestMethod -Uri "$($this.ApiUrl)/api/tags" -Method Get -ErrorAction Stop -TimeoutSec 10
            if ($response.models) {
                $this.Models = $response.models | ForEach-Object { $_.name }
            }
            else {
                $this.Models = @($this.Model)
            }
        }
        catch {
            # Fallback models
            $this.Models = @("codellama", "llama3", "llama3.1", "phi3", "mistral", "gemma")
        }
    }

    [bool]TestConnection() {
        try {
            $null = Invoke-RestMethod -Uri "$($this.ApiUrl)/api/tags" -Method Get -ErrorAction Stop -TimeoutSec 5
            return $true
        }
        catch {
            return $false
        }
    }

    [string]RunShellCommand([string]$Command) {
        try {
            $output = Invoke-Expression $Command 2>&1 | Out-String
            if ([string]::IsNullOrWhiteSpace($output)) {
                return "✓ Command executed successfully (no output)"
            }
            return $output
        }
        catch {
            return "✗ Error executing command: $($_.Exception.Message)"
        }
    }

    [bool]SwitchModel([string]$ModelName) {
        if ($this.Models -contains $ModelName) {
            $this.Model = $ModelName
            $this.Settings['Model'] = $ModelName
            $this.SaveSettings()
            return $true
        }
        return $false
    }
    
    [string]LoadFileContext([string]$FilePath) {
        try {
            $fullPath = (Resolve-Path $FilePath -ErrorAction Stop).Path
            if (Test-Path $fullPath -PathType Leaf) {
                # Check file size (limit to 1MB)
                $fileInfo = Get-Item $fullPath
                if ($fileInfo.Length -gt 1MB) {
                    return "✗ File too large: $($fileInfo.Length / 1MB) MB (max 1MB)"
                }
                
                $content = Get-Content $fullPath -Raw -ErrorAction Stop
                
                # Check if already loaded
                $existing = $this.ContextFiles | Where-Object { $_.path -eq $fullPath }
                if ($existing) {
                    $existing.content = $content
                    return "↻ Reloaded: $(Split-Path $fullPath -Leaf) ($($content.Length) chars)"
                }
                else {
                    $this.ContextFiles += @{ path = $fullPath; content = $content }
                    return "✓ Loaded: $(Split-Path $fullPath -Leaf) ($($content.Length) chars)"
                }
            }
        }
        catch {
            return "✗ Error loading file: $($_.Exception.Message)"
        }
        return "✗ File not found: $FilePath"
    }

    [string]UnloadFileContext([string]$FilePath) {
        $fullPath = (Resolve-Path $FilePath -ErrorAction SilentlyContinue).Path
        $initialCount = $this.ContextFiles.Count
        $this.ContextFiles = $this.ContextFiles | Where-Object { $_.path -ne $fullPath }
        if ($this.ContextFiles.Count -lt $initialCount) {
            return "✓ Unloaded: $(Split-Path $FilePath -Leaf)"
        }
        return "✗ File not in context: $FilePath"
    }

    [string]SetDirectoryContext([string]$DirPath) {
        try {
            $fullPath = (Resolve-Path $DirPath -ErrorAction Stop).Path
            if (Test-Path $fullPath -PathType Container) {
                Set-Location $fullPath
                $this.CurrentDir = (Get-Location).Path
                return "✓ Changed directory to: $fullPath"
            }
        }
        catch {
            return "✗ Directory not found: $DirPath"
        }
        return "✗ Invalid directory: $DirPath"
    }

    [void]ClearHistory() {
        $this.ChatHistory = @()
        $this.SaveHistory()
    }
}

# --- TUI Application ---
try {
    Write-Host "`n🚀 Initializing Ollama CLI..." -ForegroundColor Cyan
    
    # Initialize Terminal.Gui
    [Terminal.Gui.Application]::Init()
    
    # Create agent
    $global:Agent = [OllamaAgent]::new($ApiUrl, $Model)
    
    # Test connection
    Write-Host "🔌 Testing Ollama connection..." -ForegroundColor Cyan
    if (-not $global:Agent.TestConnection()) {
        Write-Host "⚠ Warning: Cannot connect to Ollama at $ApiUrl" -ForegroundColor Yellow
        Write-Host "  Make sure Ollama is running: ollama serve`n" -ForegroundColor Yellow
    }
    else {
        Write-Host "✓ Connected to Ollama successfully!`n" -ForegroundColor Green
    }
    
    # Setup main window
    $Toplevel = [Terminal.Gui.Application]::Top
    
    if ($null -eq $Toplevel) {
        Write-Host "❌ Error: Failed to get Application.Top" -ForegroundColor Red
        [Terminal.Gui.Application]::Shutdown()
        return
    }
    
    $MainWindow = [Terminal.Gui.Window]::new()
    $MainWindow.Title = "🦙 Ollama CLI - Enhanced"
    $MainWindow.X = 0
    $MainWindow.Y = 1
    $MainWindow.Width = [Terminal.Gui.Dim]::Fill()
    $MainWindow.Height = [Terminal.Gui.Dim]::Fill() - 1

    # --- Chat History View ---
    $ChatView = [Terminal.Gui.TextView]::new()
    $ChatView.X = 0
    $ChatView.Y = 0
    $ChatView.Width = [Terminal.Gui.Dim]::Fill()
    $ChatView.Height = [Terminal.Gui.Dim]::Fill() - 3
    $ChatView.ReadOnly = $true
    $ChatView.WordWrap = $true
    $ChatView.ColorScheme = [Terminal.Gui.Colors]::Base

    # --- Prompt Section ---
    $PromptFrame = [Terminal.Gui.FrameView]::new()
    $PromptFrame.Title = "Input (Press Enter to send)"
    $PromptFrame.X = 0
    $PromptFrame.Y = [Terminal.Gui.Pos]::AnchorEnd(3)
    $PromptFrame.Width = [Terminal.Gui.Dim]::Fill()
    $PromptFrame.Height = 3

    $PromptField = [Terminal.Gui.TextField]::new("")
    $PromptField.X = 1
    $PromptField.Y = 0
    $PromptField.Width = [Terminal.Gui.Dim]::Fill() - 2
    
    $PromptFrame.Add($PromptField)

    # --- Helper Functions ---
    function Add-TextToChat {
        param(
            [string]$Text,
            [string]$Style = "normal"
        )
        
        $timestamp = (Get-Date).ToString("HH:mm:ss")
        $prefix = switch ($Style) {
            "user" { "[$timestamp] 👤 You" }
            "ai" { "[$timestamp] 🤖 AI" }
            "system" { "[$timestamp] ⚙️ System" }
            "error" { "[$timestamp] ❌ Error" }
            "success" { "[$timestamp] ✓" }
            "command" { "[$timestamp] 💻 Shell" }
            default { "[$timestamp]" }
        }
        
        $separator = "-" * 80
        $currentText = $ChatView.Text.ToString()
        $newText = "$currentText$prefix`n$Text`n$separator`n`n"
        
        [Terminal.Gui.Application]::MainLoop.Invoke({
            $ChatView.Text = [NStack.ustring]::Make($newText)
            $ChatView.MoveEnd()
            $ChatView.SetNeedsDisplay()
        }.GetNewClosure())
    }

    function Show-HelpDialog {
        $dialog = [Terminal.Gui.Dialog]::new("Help - Ollama CLI", 70, 22)
        $helpText = @"
📚 COMMANDS

Chat Commands:
  /help          Show this help menu
  /clear         Clear conversation history
  /exit, /quit   Exit application

Model Management:
  /model         Switch AI model
  /models        List available models
  /settings      Configure settings

Context Management:
  /file          Load file into context
  /unload        Remove file from context
  /dir           Change working directory
  /context       View loaded context files

Shell Integration:
  !<command>     Execute PowerShell command
                 Example: !Get-ChildItem

⌨️  KEYBOARD SHORTCUTS

  Enter          Send message
  Ctrl+C         Exit application
  F1             Help menu
  F5             Refresh models list
"@
        $label = [Terminal.Gui.Label]::new(1, 0, $helpText)
        $dialog.Add($label)
        
        $closeBtn = [Terminal.Gui.Button]::new("Close")
        $closeBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($dialog) })
        $dialog.AddButton($closeBtn)
        
        [Terminal.Gui.Application]::Run($dialog)
    }

    function Show-ModelDialog {
        $dialog = [Terminal.Gui.Dialog]::new("Select Model", 60, 20)
        
        if ($global:Agent.Models.Count -eq 0) {
            $dialog.Add([Terminal.Gui.Label]::new(1, 1, "⚠ No models found. Pull a model first:"))
            $dialog.Add([Terminal.Gui.Label]::new(1, 2, "  ollama pull llama3"))
            $closeBtn = [Terminal.Gui.Button]::new("Close")
            $closeBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($dialog) })
            $dialog.AddButton($closeBtn)
        }
        else {
            $currentIdx = [array]::IndexOf($global:Agent.Models, $global:Agent.Model)
            if ($currentIdx -lt 0) { $currentIdx = 0 }
            
            $radioGroup = [Terminal.Gui.RadioGroup]::new(1, 1, $global:Agent.Models)
            $radioGroup.SelectedItem = $currentIdx
            $radioGroup.Width = [Terminal.Gui.Dim]::Fill() - 2
            $radioGroup.Height = [Terminal.Gui.Dim]::Fill() - 4
            
            $dialog.Add($radioGroup)
            
            $okBtn = [Terminal.Gui.Button]::new("OK")
            $okBtn.Clicked.Add({
                $selectedModel = $global:Agent.Models[$radioGroup.SelectedItem]
                if ($global:Agent.SwitchModel($selectedModel)) {
                    Add-TextToChat "Switched to model: $selectedModel" -Style "success"
                    Update-StatusBar
                }
                [Terminal.Gui.Application]::RequestStop($dialog)
            }.GetNewClosure())
            
            $cancelBtn = [Terminal.Gui.Button]::new("Cancel")
            $cancelBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($dialog) })
            
            $refreshBtn = [Terminal.Gui.Button]::new("Refresh")
            $refreshBtn.Clicked.Add({
                $global:Agent.LoadModels()
                [Terminal.Gui.Application]::RequestStop($dialog)
                Show-ModelDialog
            }.GetNewClosure())
            
            $dialog.AddButton($okBtn)
            $dialog.AddButton($cancelBtn)
            $dialog.AddButton($refreshBtn)
        }
        
        [Terminal.Gui.Application]::Run($dialog)
    }

    function Show-SettingsDialog {
        $dialog = [Terminal.Gui.Dialog]::new("Settings", 70, 16)
        
        # API URL
        $dialog.Add([Terminal.Gui.Label]::new(1, 1, "API URL:"))
        $apiField = [Terminal.Gui.TextField]::new($global:Agent.ApiUrl)
        $apiField.X = 1
        $apiField.Y = 2
        $apiField.Width = [Terminal.Gui.Dim]::Fill() - 2
        $dialog.Add($apiField)
        
        # System Prompt
        $dialog.Add([Terminal.Gui.Label]::new(1, 4, "System Prompt:"))
        $promptView = [Terminal.Gui.TextView]::new()
        $promptView.X = 1
        $promptView.Y = 5
        $promptView.Width = [Terminal.Gui.Dim]::Fill() - 2
        $promptView.Height = 3
        $promptView.Text = $global:Agent.SystemPrompt
        $dialog.Add($promptView)
        
        # Temperature
        $dialog.Add([Terminal.Gui.Label]::new(1, 9, "Temperature (0.0-2.0):"))
        $tempField = [Terminal.Gui.TextField]::new($global:Agent.Settings.Temperature.ToString())
        $tempField.X = 25
        $tempField.Y = 9
        $tempField.Width = 10
        $dialog.Add($tempField)
        
        # Save button
        $saveBtn = [Terminal.Gui.Button]::new("Save")
        $saveBtn.Clicked.Add({
            $global:Agent.ApiUrl = $apiField.Text.ToString()
            $global:Agent.SystemPrompt = $promptView.Text.ToString()
            
            $tempValue = 0.7
            if ([double]::TryParse($tempField.Text.ToString(), [ref]$tempValue)) {
                $tempValue = [Math]::Max(0.0, [Math]::Min(2.0, $tempValue))
                $global:Agent.Settings['Temperature'] = $tempValue
            }
            
            $global:Agent.Settings['ApiUrl'] = $global:Agent.ApiUrl
            $global:Agent.Settings['SystemPrompt'] = $global:Agent.SystemPrompt
            $global:Agent.SaveSettings()
            
            Add-TextToChat "Settings saved successfully" -Style "success"
            [Terminal.Gui.Application]::RequestStop($dialog)
        }.GetNewClosure())
        
        $cancelBtn = [Terminal.Gui.Button]::new("Cancel")
        $cancelBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($dialog) })
        
        $dialog.AddButton($saveBtn)
        $dialog.AddButton($cancelBtn)
        
        [Terminal.Gui.Application]::Run($dialog)
    }

    function Show-ContextDialog {
        $dialog = [Terminal.Gui.Dialog]::new("Context Files", 70, 18)
        
        if ($global:Agent.ContextFiles.Count -eq 0) {
            $dialog.Add([Terminal.Gui.Label]::new(1, 1, "No files currently loaded in context."))
            $dialog.Add([Terminal.Gui.Label]::new(1, 3, "Use /file command to load files."))
        }
        else {
            $listView = [Terminal.Gui.ListView]::new()
            $listView.X = 1
            $listView.Y = 1
            $listView.Width = [Terminal.Gui.Dim]::Fill() - 2
            $listView.Height = [Terminal.Gui.Dim]::Fill() - 4
            
            $items = $global:Agent.ContextFiles | ForEach-Object {
                $size = $_.content.Length
                "$($_.path) ($size chars)"
            }
            $listView.SetSource($items)
            
            $dialog.Add($listView)
            
            $clearBtn = [Terminal.Gui.Button]::new("Clear All")
            $clearBtn.Clicked.Add({
                $global:Agent.ContextFiles = @()
                Add-TextToChat "All context files cleared" -Style "success"
                [Terminal.Gui.Application]::RequestStop($dialog)
            }.GetNewClosure())
            $dialog.AddButton($clearBtn)
        }
        
        $closeBtn = [Terminal.Gui.Button]::new("Close")
        $closeBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($dialog) })
        $dialog.AddButton($closeBtn)
        
        [Terminal.Gui.Application]::Run($dialog)
    }

    function Update-StatusBar {
        [Terminal.Gui.Application]::MainLoop.Invoke({
            $modelInfo = "Model: $($global:Agent.Model)"
            $pathInfo = "Path: $($global:Agent.CurrentDir)"
            $contextInfo = "Context: $($global:Agent.ContextFiles.Count) file(s)"
            
            $statusText = "$modelInfo | $pathInfo | $contextInfo"
            
            try {
                $global:StatusBar.RemoveAll()
                $statusItem = New-Object Terminal.Gui.StatusItem -ArgumentList @(0, $statusText, $null)
                $global:StatusBar.AddItemAt(0, $statusItem)
                $global:StatusBar.SetNeedsDisplay()
            }
            catch {
                # Silently fail if status bar update doesn't work
            }
        }.GetNewClosure())
    }

    # --- ASYNCHRONOUS QUERY FUNCTION ---
    function Run-OllamaQueryAsync {
        param([string]$Prompt)

        if ($global:IsQuerying) {
            Add-TextToChat "Already running a query. Please wait..." -Style "system"
            return
        }

        $global:IsQuerying = $true
        Add-TextToChat $Prompt -Style "user"
        
        # Update UI state before starting the job
        [Terminal.Gui.Application]::MainLoop.Invoke({
            try {
                $global:StatusBar.RemoveAll()
                $statusItem = New-Object Terminal.Gui.StatusItem -ArgumentList @(0, "⏳ Querying $($global:Agent.Model)...", $null)
                $global:StatusBar.AddItemAt(0, $statusItem)
                $global:StatusBar.SetNeedsDisplay()
            } catch {}
        }.GetNewClosure())

        # Script block to run in the background job
        $scriptBlock = {
            param($AgentSettings, $AgentModel, $AgentApiUrl, $Prompt, $SystemPrompt, $ContextFiles, $CurrentDir)

            # Reconstruct full prompt
            $FullPrompt = $Prompt

            # Add file context
            if ($ContextFiles.Count -gt 0) {
                $fileContext = ($ContextFiles | ForEach-Object {
                    "`n--- File: $($_.path) ---`n$($_.content)"
                }) -join "`n"
                $FullPrompt = "File Context:`n$fileContext`n`nUser Query:`n$Prompt"
            }

            # Add GEMINI.md context
            $geminiMdPath = Join-Path $CurrentDir "GEMINI.md"
            if (Test-Path $geminiMdPath) {
                $GeminiContext = Get-Content $geminiMdPath -Raw -ErrorAction SilentlyContinue
                if ($GeminiContext) {
                    $FullPrompt = "Project Instructions:`n$GeminiContext`n`n$FullPrompt"
                }
            }

            try {
                $Body = @{
                    model = $AgentModel
                    prompt = $FullPrompt
                    system = $SystemPrompt
                    stream = $false
                    options = @{
                        temperature = $AgentSettings.Temperature
                        num_predict = $AgentSettings.MaxTokens
                    }
                } | ConvertTo-Json -Depth 10

                $response = Invoke-RestMethod -Uri "$($AgentApiUrl)/api/generate" -Method Post -Body $Body -ContentType "application/json" -ErrorAction Stop -TimeoutSec 120
                
                $aiResponse = $response.response.Trim()
                
                return @{ UserPrompt = $Prompt; AiResponse = $aiResponse; Error = $null }
            }
            catch {
                $errorMsg = "Error: $($_.Exception.Message)"
                if ($_.Exception.Message -match "unable to connect") {
                    $errorMsg += "`n`nTroubleshooting:`n• Ensure Ollama is running: ollama serve`n• Check API URL: $($AgentApiUrl)`n• Verify model is pulled: ollama pull $($AgentModel)"
                }
                return @{ UserPrompt = $Prompt; AiResponse = $null; Error = $errorMsg }
            }
        }

        $global:OllamaJob = Start-Job -ScriptBlock $scriptBlock -ArgumentList @(
            $global:Agent.Settings, 
            $global:Agent.Model, 
            $global:Agent.ApiUrl, 
            $Prompt, 
            $global:Agent.SystemPrompt, 
            $global:Agent.ContextFiles, 
            $global:Agent.CurrentDir
        )
    }

    function Check-JobStatus {
        if ($null -eq $global:OllamaJob) { return }
        
        if ($global:OllamaJob.State -eq "Completed") {
            $result = Receive-Job $global:OllamaJob -Keep
            Remove-Job $global:OllamaJob

            $global:IsQuerying = $false

            Add-TextToChat "Job Failed: $($error | Out-String)" -Style "error"

            $global:OllamaJob = $null
            Update-StatusBar
            
            [Terminal.Gui.Application]::MainLoop.Invoke({
                $PromptField.SetFocus()
                [Terminal.Gui.Application]::Refresh()
            }.GetNewClosure())
        }
    }

    function Handle-Input {
        param([string]$Input)
        
        if ([string]::IsNullOrWhiteSpace($Input)) { return }

        if ($Input.StartsWith("/")) {
            # Command handling
            $parts = $Input.Substring(1).Trim() -split '\s+', 2
            $cmd = $parts[0].ToLower()
            $args = if ($parts.Count -gt 1) { $parts[1] } else { "" }

            switch ($cmd) {
                { $_ -in "help", "?" } { Show-HelpDialog }
                "model" { Show-ModelDialog }
                "models" { Show-ModelDialog }
                "settings" { Show-SettingsDialog }
                "context" { Show-ContextDialog }
                { $_ -in "clear", "cls" } {
                    $ChatView.Text = ""
                    $global:Agent.ClearHistory()
                    Add-TextToChat "Conversation cleared" -Style "success"
                }
                { $_ -in "exit", "quit", "q" } {
                    [Terminal.Gui.Application]::RequestStop()
                }
                "file" {
                    $fileDialog = [Terminal.Gui.OpenDialog]::new("Load File", "Select file for context")
                    $fileDialog.AllowsMultipleSelection = $false
                    [Terminal.Gui.Application]::Run($fileDialog)
                    if (-not $fileDialog.Canceled) {
                        $result = $global:Agent.LoadFileContext($fileDialog.FilePath.ToString())
                        Add-TextToChat $result -Style "system"
                        Update-StatusBar
                    }
                }
                "unload" {
                    if ($args) {
                        $result = $global:Agent.UnloadFileContext($args)
                        Add-TextToChat $result -Style "system"
                        Update-StatusBar
                    }
                    else {
                        Add-TextToChat "Usage: /unload <filepath>" -Style "error"
                    }
                }
                "dir" {
                    $dirDialog = [Terminal.Gui.OpenDialog]::new("Change Directory", "Select directory")
                    $dirDialog.CanChooseFiles = $false
                    $dirDialog.CanChooseDirectories = $true
                    [Terminal.Gui.Application]::Run($dirDialog)
                    if (-not $dirDialog.Canceled) {
                        $result = $global:Agent.SetDirectoryContext($dirDialog.FilePath.ToString())
                        Add-TextToChat $result -Style "system"
                        Update-StatusBar
                    }
                }
                default {
                    Add-TextToChat "Unknown command: $Input`nType /help for available commands" -Style "error"
                }
            }
        }
        elseif ($Input.StartsWith("!")) {
            # Shell command
            $shellCmd = $Input.Substring(1).Trim()
            Add-TextToChat $shellCmd -Style "command"
            
            $output = $global:Agent.RunShellCommand($shellCmd)
            Add-TextToChat $output -Style "system"
        }
        else {
            # AI query
            Run-OllamaQueryAsync $Input
        }
    }
    
    # Handle Enter key press with proper event subscription
    $PromptField.add_KeyPress({
        param($keyEvent)
        
        if ($keyEvent.KeyEvent.Key -eq [Terminal.Gui.Key]::Enter) {
            $inputText = $PromptField.Text.ToString()
            if (-not [string]::IsNullOrWhiteSpace($inputText)) {
                $PromptField.Text = ""
                Handle-Input $inputText
            }
            $keyEvent.Handled = $true
        }
    }.GetNewClosure())

    # --- Menu Bar ---
    try {
        $fileMenuItems = [System.Collections.Generic.List[Terminal.Gui.MenuItem]]::new()
        $fileMenuItems.Add([Terminal.Gui.MenuItem]::new("_Load File", "", { Handle-Input "/file" }.GetNewClosure()))
        $fileMenuItems.Add([Terminal.Gui.MenuItem]::new("Change _Directory", "", { Handle-Input "/dir" }.GetNewClosure()))
        $fileMenuItems.Add([Terminal.Gui.MenuItem]::new("E_xit", "", { [Terminal.Gui.Application]::RequestStop() }))
        
        $editMenuItems = [System.Collections.Generic.List[Terminal.Gui.MenuItem]]::new()
        $editMenuItems.Add([Terminal.Gui.MenuItem]::new("_Clear Chat", "", { Handle-Input "/clear" }.GetNewClosure()))
        $editMenuItems.Add([Terminal.Gui.MenuItem]::new("View _Context", "", { Handle-Input "/context" }.GetNewClosure()))
        
        $modelMenuItems = [System.Collections.Generic.List[Terminal.Gui.MenuItem]]::new()
        $modelMenuItems.Add([Terminal.Gui.MenuItem]::new("_Switch Model", "", { Handle-Input "/model" }.GetNewClosure()))
        $modelMenuItems.Add([Terminal.Gui.MenuItem]::new("_Refresh Models", "", {
            $global:Agent.LoadModels()
            Add-TextToChat "Models list refreshed" -Style "success"
        }.GetNewClosure()))
        $modelMenuItems.Add([Terminal.Gui.MenuItem]::new("Se_ttings", "", { Show-SettingsDialog }.GetNewClosure()))
        
        $helpMenuItems = [System.Collections.Generic.List[Terminal.Gui.MenuItem]]::new()
        $helpMenuItems.Add([Terminal.Gui.MenuItem]::new("_Help", "", { Show-HelpDialog }.GetNewClosure()))
        $helpMenuItems.Add([Terminal.Gui.MenuItem]::new("_About", "", {
            $aboutDialog = [Terminal.Gui.Dialog]::new("About", 50, 10)
            $aboutText = @"
🦙 Ollama CLI - Enhanced
Version: 2.1 (Fixed)

A powerful Terminal UI for Ollama
Created with PowerShell + Terminal.Gui
"@
            $aboutDialog.Add([Terminal.Gui.Label]::new(1, 1, $aboutText))
            $closeBtn = [Terminal.Gui.Button]::new("Close")
            $closeBtn.Clicked.Add({ [Terminal.Gui.Application]::RequestStop($aboutDialog) })
            $aboutDialog.AddButton($closeBtn)
            [Terminal.Gui.Application]::Run($aboutDialog)
        }.GetNewClosure()))
        
        $menuBarItems = [System.Collections.Generic.List[Terminal.Gui.MenuBarItem]]::new()
        $menuBarItems.Add([Terminal.Gui.MenuBarItem]::new("_File", $fileMenuItems.ToArray()))
        $menuBarItems.Add([Terminal.Gui.MenuBarItem]::new("_Edit", $editMenuItems.ToArray()))
        $menuBarItems.Add([Terminal.Gui.MenuBarItem]::new("_Model", $modelMenuItems.ToArray()))
        $menuBarItems.Add([Terminal.Gui.MenuBarItem]::new("_Help", $helpMenuItems.ToArray()))
        
        $MenuBar = [Terminal.Gui.MenuBar]::new($menuBarItems.ToArray())
    }
    catch {
        Write-Host "⚠ Warning: Could not create MenuBar: $($_.Exception.Message)" -ForegroundColor Yellow
        $MenuBar = $null
    }

    # --- Status Bar ---
    $statusText = "Model: $($global:Agent.Model) | Path: $($global:Agent.CurrentDir)"
    $global:StatusBar = [Terminal.Gui.StatusBar]::new()

    # --- Assemble UI ---
    $MainWindow.Add($ChatView)
    $MainWindow.Add($PromptFrame)
    
    # Add components to top level
    if ($null -ne $Toplevel) {
        if ($null -ne $MenuBar) {
            $Toplevel.Add($MenuBar)
        }
        $Toplevel.Add($MainWindow)
        $Toplevel.Add($global:StatusBar)
    }
    else {
        Write-Host "Error: Toplevel is null!" -ForegroundColor Red
        [Terminal.Gui.Application]::Shutdown()
        return
    }
    
    # Welcome message
    Add-TextToChat @"
Welcome to Ollama CLI Enhanced! 🦙

Quick Start:
• Type your message and press Enter to chat
• Use /help to see all commands
• Press F1 for help, or use menu bar

Current Model: $($global:Agent.Model)
API Endpoint: $($global:Agent.ApiUrl)
"@ -Style "system"

    $PromptField.SetFocus()
    Update-StatusBar

    # Add timeout to check job status periodically (every 200ms)
    [Terminal.Gui.Application]::MainLoop.AddTimeout(200, {
        Check-JobStatus
        return $true
    }.GetNewClosure())

    # Run application
    [Terminal.Gui.Application]::Run($Toplevel)
}
catch {
    Write-Host "`n❌ Fatal Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray
    Read-Host "`nPress Enter to exit"
}
finally {
    # Ensure terminal is properly restored
    try {
        [Terminal.Gui.Application]::Shutdown()
    }
    catch {
        # Already shutdown
    }
    # Clean up any residual background job
    if ($global:OllamaJob) {
        Stop-Job $global:OllamaJob -ErrorAction SilentlyContinue
        Remove-Job $global:OllamaJob -ErrorAction SilentlyContinue
    }
    Write-Host "`n👋 Thanks for using Ollama CLI! Goodbye.`n" -ForegroundColor Cyan
}