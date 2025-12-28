$ErrorActionPreference = "Stop"

$today = Get-Date -Format "yyyy-MM-dd"
$commitMessage = "Changes made on Date : $today"

Set-Location "C:\Coding Project"

# Detect current branch
$branch = git branch --show-current

if (-not $branch) {
    Write-Host "Not on a branch (detached HEAD)"
    exit 1
}

# Pull latest changes
git pull --rebase origin $branch

# Stage changes
git add -A

# Commit only if there are staged changes
$changes = git diff --cached --name-only
if ($changes) {
    git commit -m $commitMessage
} else {
    Write-Host "No changes to commit"
}

# Push changes
git push origin $branch
