# auto-commit.ps1
$today = Get-Date -Format "yyyy-MM-dd"
$commitMessage = "Changes made on Date : $today"

# Navigate to the repo folder
Set-Location "C:\Coding Project"

# Stage all changes (tracked + untracked files)
git add -A

# Commit if there are staged changes
if (git diff --cached --name-only) {
    git commit -m "$commitMessage"
}

# Sync with remote (rebase to avoid merge commits)
try {
    git pull --rebase origin Coding-Project
} catch {
    Write-Host "Pull failed. Please resolve conflicts manually."
    exit 1
}

# Push changes
git push origin Coding-Project

