#!/usr/bin/env bash
set -e

cd "$HOME/Coding-Project" || {
  echo "Directory not found"
  exit 1
}

BRANCH=$(git branch --show-current)

if [[ -z "$BRANCH" ]]; then
  echo "Not on a branch (detached HEAD)"
  exit 1
fi

today=$(date +"%Y-%m-%d")
commitMessage="Changes made on Date : $today"

# Stage all changes
git add -A

# Commit FIRST before pulling (avoids stash/pop conflicts)
if ! git diff --cached --quiet; then
  echo "✅ Committing local changes..."
  git commit -m "$commitMessage"
else
  echo "ℹ️  No changes to commit"
fi

# Now pull safely — working tree is clean
echo "⬇️  Pulling latest from origin/$BRANCH..."
git pull --rebase origin "$BRANCH"

# Push
echo "⬆️  Pushing to origin/$BRANCH..."
git push origin "$BRANCH"

echo "🎉 Done!"