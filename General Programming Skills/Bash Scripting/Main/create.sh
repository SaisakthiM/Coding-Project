#!/usr/bin/env bash

set -e

ROOT="$HOME/Coding-Project"
LINK_DIR="$ROOT/.vscode/java-links"

echo "Cleaning old java-links..."
rm -rf "$LINK_DIR"

mkdir -p "$LINK_DIR"

echo "Searching for Maven projects..."

find "$ROOT" -type f -name "pom.xml" | while read -r pom
do
    project_dir="$(dirname "$pom")"

    # Skip the root aggregator pom itself
    if [[ "$project_dir" == "$ROOT" ]]; then
        continue
    fi

    # Create sanitized name
    relative_path="${project_dir#$ROOT/}"

    safe_name=$(echo "$relative_path" \
        | sed 's/[ \/]/-/g')

    link_path="$LINK_DIR/$safe_name"

    echo "Creating symlink:"
    echo "  $link_path -> $project_dir"

    ln -s "$project_dir" "$link_path"
done

echo
echo "Symlink rebuild complete."