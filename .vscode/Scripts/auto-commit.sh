#!/bin/bash

# Navigate to project directory
cd "$HOME/Coding-Project" || exit 1

today=$(date +"%Y-%m-%d")
commitMessage="Changes made on Date : $today"

# Pull first (sync remote -> local)
if ! git pull --rebase origin Coding-Project; then
    echo "Pull failed. Resolve conflicts manually."
    exit 1
fi

# Add all changes
git add -A

# Commit only if the index has changes
if [[ -n $(git diff --cached --name-only) ]]; then
    git commit -m "$commitMessage"
fi

# Push changes
git push origin Coding-Project
