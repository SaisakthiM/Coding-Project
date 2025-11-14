# -----------------------------
# update-wine-check.ps1
# -----------------------------
$timestampFile = "$env:USERPROFILE\.wine_update_last.txt"
$wslScript     = "/mnt/c/Coding Project/.vscode/Scripts/update-wine-tools.sh"
$logFile       = "$env:USERPROFILE\.wine_update_log.txt"
$daysInterval  = 30

$now = Get-Date
$runUpdate = $true

if (Test-Path $timestampFile) {
    try {
        $lastRunRaw = Get-Content $timestampFile -Raw
        $lastRun = [DateTime]::Parse($lastRunRaw)
        $daysSinceLastRun = ($now - $lastRun).Days

        if ($daysSinceLastRun -lt $daysInterval) {
            # Not yet 30 days → ask the user
            $response = Read-Host "It’s only been $daysSinceLastRun days since last update. Run update? (y/n)"
            if ($response -notin @("y", "Y", "yes", "YES")) {
                Write-Host "Skipping update by user choice."
                $runUpdate = $false
            }
        } else {
            # ≥ 30 days → auto-run without asking
            Write-Host "[$now] More than $daysInterval days since last update. Running automatically."
            $runUpdate = $true
        }
    } catch {
        Write-Host "Invalid timestamp file. Running update."
        $runUpdate = $true
    }
}

if (-not $runUpdate) { exit 0 }

Write-Host "[$now] Running WSL reshim..." | Tee-Object -FilePath $logFile -Append

wsl bash -lc "bash '$wslScript'" 2>&1 | Tee-Object -FilePath $logFile -Append
if ($LASTEXITCODE -ne 0) {
    Write-Host "[$now] Update failed (exit $LASTEXITCODE)." | Tee-Object -FilePath $logFile -Append
    exit $LASTEXITCODE
}

$now | Out-File $timestampFile -Force
Write-Host "[$now] Update completed successfully." | Tee-Object -FilePath $logFile -Append
