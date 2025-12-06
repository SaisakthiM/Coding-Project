#Requires -Version 7.0
# Modern Code Runner TUI - PowerShell with Spectre.Console
# Requires: Install-Module Spectre.Console, PwshSpectreConsole

param(
    [string]$InitialPath = (Get-Location).Path
)

# ============================================================================
# MODULE IMPORTS & VALIDATION
# ============================================================================

$requiredModules = @(
    'Spectre.Console',
    'PwshSpectreConsole'
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module -Name $module -Force -Scope CurrentUser -SkipPublisherCheck
    }
    Import-Module $module -Force
}

# ============================================================================
# CONFIGURATION & STATE
# ============================================================================

$script:Config = @{
    RefreshRate     = 50
    MaxBufferSize   = 1000
    SearchTimeout   = 5000
    DefaultFileSize = 50
}

$script:ExecutorMap = @{
    '.py'   = 'python "{file}" 2>&1'
    '.js'   = 'node "{file}" 2>&1'
    '.ts'   = 'npx ts-node "{file}" 2>&1'
    '.java' = 'java -cp "{dir}" "{nameNoExt}" 2>&1'
    '.cpp'  = 'g++ "{file}" -o "{nameNoExt}" && "./{nameNoExt}.exe" 2>&1'
    '.c'    = 'gcc "{file}" -o "{nameNoExt}" && "./{nameNoExt}.exe" 2>&1'
    '.go'   = 'go run "{file}" 2>&1'
    '.rb'   = 'ruby "{file}" 2>&1'
    '.rs'   = 'rustc "{file}" && "./{nameNoExt}.exe" 2>&1'
    '.php'  = 'php "{file}" 2>&1'
    '.ps1'  = '& "{file}" 2>&1'
    '.sh'   = 'bash "{file}" 2>&1'
}

$script:State = @{
    CurrentPath    = $InitialPath
    Files          = @()
    SelectedIndex  = 0
    ScrollOffset   = 0
    SearchQuery    = ""
    ActiveTab      = "output"
    IsRunning      = $false
    OutputBuffer   = [System.Collections.Generic.List[string]]::new()
    ErrorBuffer    = [System.Collections.Generic.List[string]]::new()
    ExitCode       = $null
    Stats          = @{
        TotalRuns   = 0
        Success     = 0
        Errors      = 0
        TotalTime   = 0
    }
    LastRunFile    = $null
    LastRunTime    = $null
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

function New-SafePadding {
    param(
        [int]$DesiredLength,
        [int]$CurrentLength
    )
    
    $padding = $DesiredLength - $CurrentLength
    if ($padding -le 0) { return "" }
    return " " * [Math]::Min($padding, $DesiredLength)
}

function Test-ValidFile {
    param([string]$Path)
    $ext = [System.IO.Path]::GetExtension($Path).ToLower()
    return $script:ExecutorMap.ContainsKey($ext) -and (Test-Path $Path -PathType Leaf)
}

function Get-Files {
    param(
        [string]$Path,
        [string]$Filter = ""
    )
    
    try {
        if (-not (Test-Path $Path -PathType Container)) {
            return @()
        }
        
        $items = @(Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue)
        
        if (![string]::IsNullOrWhiteSpace($Filter)) {
            $items = $items | Where-Object { $_.Name -like "*$Filter*" }
        }
        
        return @($items | Where-Object { $script:ExecutorMap.ContainsKey($_.Extension.ToLower()) } | Sort-Object Name)
    }
    catch {
        return @()
    }
}

function Get-FileEmoji {
    param([string]$Extension)
    $emojiMap = @{
        '.py'   = '🐍'
        '.js'   = '⚡'
        '.ts'   = '🔷'
        '.java' = '☕'
        '.cpp'  = '⚙️'
        '.c'    = '©️'
        '.go'   = '🎯'
        '.rs'   = '🦀'
        '.rb'   = '💎'
        '.php'  = '🐘'
        '.ps1'  = '🔧'
        '.sh'   = '🐚'
    }
    return $emojiMap[$Extension.ToLower()] ?? '📄'
}

function Get-SystemStats {
    try {
        $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
        $mem = Get-CimInstance Win32_OperatingSystem
        $memPercent = [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize) * 100, 1)
        
        return @{
            CPU    = [math]::Round($cpu ?? 0, 1)
            Memory = $memPercent
        }
    }
    catch {
        return @{ CPU = 0; Memory = 0 }
    }
}

function Truncate-String {
    param(
        [string]$Text,
        [int]$MaxLength
    )
    
    if ($Text.Length -gt $MaxLength) {
        return $Text.Substring(0, [Math]::Max(1, $MaxLength - 1)) + "…"
    }
    return $Text
}

# ============================================================================
# EXECUTION ENGINE
# ============================================================================

function Invoke-CodeFile {
    param([string]$FilePath)
    
    if (-not (Test-ValidFile $FilePath)) {
        Add-ToBuffer -Buffer "ErrorBuffer" "Invalid or unsupported file type"
        return
    }
    
    $script:State.OutputBuffer.Clear()
    $script:State.ErrorBuffer.Clear()
    $script:State.IsRunning = $true
    $script:State.ExitCode = $null
    $script:State.ActiveTab = "output"
    $script:State.LastRunFile = [System.IO.Path]::GetFileName($FilePath)
    $script:State.LastRunTime = Get-Date
    
    $dir = [System.IO.Path]::GetDirectoryName($FilePath)
    $file = [System.IO.Path]::GetFileName($FilePath)
    $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    $ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
    
    $command = $script:ExecutorMap[$ext]
    $command = $command -replace '\{dir\}', $dir
    $command = $command -replace '\{file\}', $file
    $command = $command -replace '\{nameNoExt\}', $nameNoExt
    
    Add-ToBuffer -Buffer "OutputBuffer" "[▶] Running: $file"
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    
    try {
        $script:State.Stats.TotalRuns++
        
        Push-Location $dir -ErrorAction Stop
        $output = Invoke-Expression $command 2>&1
        
        foreach ($line in $output) {
            Add-ToBuffer -Buffer "OutputBuffer" $line.ToString()
        }
        
        $script:State.ExitCode = if ($LASTEXITCODE -eq 0 -or $?) { 0 } else { 1 }
        
        if ($script:State.ExitCode -eq 0) {
            $script:State.Stats.Success++
            Add-ToBuffer -Buffer "OutputBuffer" "[✓] Completed successfully"
        }
        else {
            $script:State.Stats.Errors++
            Add-ToBuffer -Buffer "ErrorBuffer" "[✗] Process failed with exit code $($script:State.ExitCode)"
        }
    }
    catch {
        $script:State.Stats.Errors++
        Add-ToBuffer -Buffer "ErrorBuffer" "[✗] Exception: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
        $stopwatch.Stop()
        $script:State.Stats.TotalTime += $stopwatch.ElapsedMilliseconds
        $script:State.IsRunning = $false
    }
}

function Add-ToBuffer {
    param(
        [ValidateSet("OutputBuffer", "ErrorBuffer")]
        [string]$Buffer,
        [string]$Message
    )
    
    $list = $script:State[$Buffer]
    $list.Add("[$(Get-Date -Format 'HH:mm:ss')] $Message")
    
    if ($list.Count -gt $script:Config.MaxBufferSize) {
        $list.RemoveAt(0)
    }
}

# ============================================================================
# UI RENDERING
# ============================================================================

function Show-FilePanel {
    param([int]$Height)
    
    $panel = [Spectre.Console.Panel]::new(
        [Spectre.Console.Text]::new("📂 File Browser", "cyan bold"),
        "cyan"
    )
    
    $fileList = @()
    $maxItems = $Height - 2
    
    $files = $script:State.Files | Select-Object -Skip $script:State.ScrollOffset -First $maxItems
    
    $idx = $script:State.ScrollOffset
    foreach ($file in $files) {
        $emoji = Get-FileEmoji $file.Extension
        $name = Truncate-String $file.Name 40
        $isSelected = $idx -eq $script:State.SelectedIndex
        
        if ($isSelected) {
            $fileList += "[bold cyan]▸ $emoji $name[/]"
        }
        else {
            $fileList += "▸ $emoji $name"
        }
        $idx++
    }
    
    if ($fileList.Count -eq 0) {
        $fileList = @("[dim]No files found[/]")
    }
    
    return $panel, ($fileList -join "`n")
}

function Show-StatsPanel {
    param([hashtable]$Stats)
    
    $statsText = @(
        "Total Runs: [yellow]$($Stats.TotalRuns)[/]",
        "Success: [green]✓ $($Stats.Success)[/]",
        "Errors: [red]✗ $($Stats.Errors)[/]",
        "Avg Time: [blue]$(if ($Stats.TotalRuns -gt 0) { [Math]::Round($Stats.TotalTime / $Stats.TotalRuns, 0) }ms else { 'N/A' })"
    ) -join "`n"
    
    return [Spectre.Console.Panel]::new($statsText, "magenta") | 
        ForEach-Object { $_.Header = "⚙️ Statistics" }
}

function Show-OutputPanel {
    param(
        [string]$Content,
        [ValidateSet("output", "error")]
        [string]$Type = "output"
    )
    
    $color = if ($Type -eq "error") { "red" } else { "white" }
    $icon = if ($Type -eq "error") { "✗" } else { "▶" }
    
    return [Spectre.Console.Panel]::new(
        "[${color}]$Content[/]",
        $color
    ) | ForEach-Object { $_.Header = "$icon Output"; $_ }
}

function Show-MainInterface {
    [Console]::Clear()
    
    $stats = Get-SystemStats
    
    # Header
    Write-Host ""
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold cyan]╔════════════════════════════════════════════════════════════════╗[/]")
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold cyan]║[/] [yellow]PowerShell Code Runner TUI[/] [dim]• Path: $($script:State.CurrentPath)[/] [bold cyan]║[/]")
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold cyan]╚════════════════════════════════════════════════════════════════╝[/]")
    Write-Host ""
    
    # System Stats Bar
    [Spectre.Console.AnsiConsole]::MarkupLine("[cyan]CPU: [yellow]$($stats.CPU)%[/] │ Memory: [magenta]$($stats.Memory)%[/][/]")
    Write-Host ""
    
    # Files
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold cyan]Files Found: [yellow]$($script:State.Files.Count)[/] | Search: [green]$($script:State.SearchQuery ?? 'None')[/][/]")
    
    if ($script:State.Files.Count -gt 0) {
        foreach ($i in 0..([Math]::Min(5, $script:State.Files.Count - 1))) {
            $file = $script:State.Files[$i]
            $emoji = Get-FileEmoji $file.Extension
            $marker = if ($i -eq $script:State.SelectedIndex) { "[bold yellow]▶[/]" } else { "  " }
            [Spectre.Console.AnsiConsole]::MarkupLine("  $marker $emoji $(Truncate-String $file.Name 50)")
        }
    }
    else {
        [Spectre.Console.AnsiConsole]::MarkupLine("  [dim]No executable files in directory[/]")
    }
    
    Write-Host ""
    
    # Output
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold]Output [$($script:State.ActiveTab)]:[/]")
    
    switch ($script:State.ActiveTab) {
        "output" {
            $lines = @($script:State.OutputBuffer | Select-Object -Last 8)
            foreach ($line in $lines) {
                [Spectre.Console.AnsiConsole]::MarkupLine("  [white]$line[/]")
            }
        }
        "errors" {
            $lines = @($script:State.ErrorBuffer | Select-Object -Last 8)
            foreach ($line in $lines) {
                [Spectre.Console.AnsiConsole]::MarkupLine("  [red]$line[/]")
            }
            if ($lines.Count -eq 0) {
                [Spectre.Console.AnsiConsole]::MarkupLine("  [green]No errors[/]")
            }
        }
    }
    
    Write-Host ""
    
    # Stats
    [Spectre.Console.AnsiConsole]::MarkupLine("[cyan]─────────────────────────────────────────────────────────────────[/]")
    [Spectre.Console.AnsiConsole]::MarkupLine("[cyan]Runs: [yellow]$($script:State.Stats.TotalRuns)[/] │ [green]✓ $($script:State.Stats.Success)[/] │ [red]✗ $($script:State.Stats.Errors)[/][/]")
    
    Write-Host ""
    
    # Controls
    [Spectre.Console.AnsiConsole]::MarkupLine("[dim]Controls:[/] [yellow]F[/]=Run │ [yellow]/[/]=Search │ [yellow]C[/]=Directory │ [yellow]↑↓[/]=Navigate │ [yellow]E[/]=Errors │ [yellow]Q[/]=Quit[/]")
}

# ============================================================================
# INPUT HANDLING
# ============================================================================

function Prompt-UserInput {
    param(
        [string]$Title,
        [string]$Prompt = "Enter value"
    )
    
    [Console]::CursorVisible = $true
    Clear-Host
    Write-Host ""
    Write-Host "▸ $Title" -ForegroundColor Cyan
    Write-Host ""
    Write-Host $Prompt -ForegroundColor Yellow -NoNewline
    Write-Host ": " -NoNewline
    
    $input = Read-Host
    [Console]::CursorVisible = $false
    
    return $input
}

function Handle-SearchInput {
    $query = Prompt-UserInput "File Search" "Enter search term"
    
    if (![string]::IsNullOrWhiteSpace($query)) {
        $script:State.SearchQuery = $query
        $script:State.Files = @(Get-Files $script:State.CurrentPath $query)
        $script:State.SelectedIndex = 0
        $script:State.ScrollOffset = 0
    }
}

function Handle-DirectoryChange {
    $newPath = Prompt-UserInput "Change Directory" "Enter path"
    
    if (-not [string]::IsNullOrWhiteSpace($newPath) -and (Test-Path $newPath -PathType Container)) {
        $script:State.CurrentPath = (Get-Item $newPath).FullName
        Set-Location $script:State.CurrentPath
        $script:State.Files = @(Get-Files $script:State.CurrentPath)
        $script:State.SelectedIndex = 0
        $script:State.SearchQuery = ""
    }
}

# ============================================================================
# MAIN LOOP
# ============================================================================

function Start-CodeRunner {
    [Console]::CursorVisible = $false
    $script:State.Files = @(Get-Files $script:State.CurrentPath)
    
    $running = $true
    
    while ($running) {
        Show-MainInterface
        
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            
            switch ($key.Character.ToUpper()) {
                'F' {
                    if ($script:State.Files.Count -gt 0 -and -not $script:State.IsRunning) {
                        $selectedFile = $script:State.Files[$script:State.SelectedIndex]
                        Invoke-CodeFile $selectedFile.FullName
                    }
                }
                '/' { Handle-SearchInput }
                'C' { Handle-DirectoryChange }
                'E' { $script:State.ActiveTab = if ($script:State.ActiveTab -eq "errors") { "output" } else { "errors" } }
                'R' { $script:State.Files = @(Get-Files $script:State.CurrentPath $script:State.SearchQuery) }
                'Q' { $running = $false }
            }
            
            switch ($key.Key) {
                'UpArrow' { 
                    if ($script:State.SelectedIndex -gt 0) { 
                        $script:State.SelectedIndex-- 
                    }
                }
                'DownArrow' { 
                    if ($script:State.SelectedIndex -lt ($script:State.Files.Count - 1)) { 
                        $script:State.SelectedIndex++ 
                    }
                }
            }
        }
        
        Start-Sleep -Milliseconds $script:Config.RefreshRate
    }
    
    [Console]::CursorVisible = $true
    Clear-Host
    [Spectre.Console.AnsiConsole]::MarkupLine("[bold cyan]Code Runner Closed[/]")
    Write-Host ""
    Write-Host "Statistics:" -ForegroundColor Cyan
    Write-Host "  Total Runs: $($script:State.Stats.TotalRuns)" -ForegroundColor Yellow
    Write-Host "  ✓ Success: $($script:State.Stats.Success)" -ForegroundColor Green
    Write-Host "  ✗ Errors: $($script:State.Stats.Errors)" -ForegroundColor Red
    Write-Host ""
}

# ============================================================================
# STARTUP
# ============================================================================

try {
    Start-CodeRunner
}
catch {
    [Console]::CursorVisible = $true
    Write-Host "Fatal Error: $_" -ForegroundColor Red
    Write-Error $_
}
finally {
    [Console]::CursorVisible = $true
}