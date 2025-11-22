# auto-commit.ps1

$today = Get-Date -Format "yyyy-MM-dd"
$commitMessage = "Changes made on Date : $today"

# Navigate to the repo folder
Set-Location "C:\Coding Project"

# --- STEP 1: Pull first to sync remote -> local ---
try {
    git pull --rebase origin Coding-Project
} catch {
    Write-Host "Pull failed. Resolve conflicts manually before continuing."
    exit 1
}

# --- STEP 2: Stage changes (tracked + untracked) ---
git add -A

# --- STEP 3: Commit only if there are staged changes ---
if (git diff --cached --name-only) {
    git commit -m "$commitMessage"
}

# --- STEP 4: Push updates to remote ---
git push origin Coding-Project
