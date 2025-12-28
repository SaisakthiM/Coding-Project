#!/usr/bin/env bash
set -e

# Navigate to project directory
cd "$HOME/Coding-Project" || {
  echo "Directory not found"
  exit 1
}

# Detect current branch
BRANCH=$(git branch --show-current)

if [[ -z "$BRANCH" ]]; then
  echo "Not on a branch (detached HEAD)"
  exit 1
fi

today=$(date +"%Y-%m-%d")
commitMessage="Changes made on Date : $today"

# Pull latest changes
git pull --rebase origin "$BRANCH"

# Stage all changes
git add -A

# Commit only if there are staged changes
if ! git diff --cached --quiet; then
  git commit -m "$commitMessage"
else
  echo "No changes to commit"
fi

# Push changes
git push origin "$BRANCH"
