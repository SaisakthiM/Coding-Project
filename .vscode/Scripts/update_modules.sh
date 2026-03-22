#!/bin/bash

# ─── Config ───────────────────────────────────────────────────────────────────
AGGREGATOR_POM="/home/saisakthi/Coding-Project/pom.xml"
ROOT_DIR="/home/saisakthi/Coding-Project"
LINKS_DIR="$ROOT_DIR/.vscode/java-links"
# ──────────────────────────────────────────────────────────────────────────────

echo "🔍 Scanning for pom.xml files under: $ROOT_DIR"

# Clean and recreate symlinks directory
rm -rf "$LINKS_DIR"
mkdir -p "$LINKS_DIR"

MODULE_PATHS=()

while IFS= read -r pom_file; do
    pom_dir=$(dirname "$pom_file")

    # Skip the aggregator pom itself
    if [ "$pom_dir" == "$ROOT_DIR" ]; then
        continue
    fi

    # Skip symlink targets (inside .vscode/java-links) to avoid duplicates
    if [[ "$pom_dir" == "$LINKS_DIR"* ]]; then
        continue
    fi

    rel_path="${pom_dir#$ROOT_DIR/}"

    # If path contains spaces, create a symlink and use that instead
    if [[ "$rel_path" == *" "* ]]; then
        # Use the FULL relative path as the link name (spaces→hyphens, slashes→hyphens)
        # This guarantees uniqueness across all projects
        safe_name=$(echo "$rel_path" | tr ' ' '-' | tr '/' '-')

        link_path="$LINKS_DIR/$safe_name"
        ln -sf "$pom_dir" "$link_path"
        rel_path=".vscode/java-links/$safe_name"
        echo "  🔗 Symlinked (spaces): $rel_path"
    else
        echo "  ✅ Found: $rel_path"
    fi

    MODULE_PATHS+=("$rel_path")

done < <(find "$ROOT_DIR" \
    -not -path "*/target/*" \
    -not -path "*/.git/*" \
    -not -path "*/.vscode/java-links/*" \
    -name "pom.xml" \
    | sort)

echo ""
echo "📦 Total modules found: ${#MODULE_PATHS[@]}"

# ─── Build the <modules> block ────────────────────────────────────────────────
MODULES_XML="    <modules>\n"
for path in "${MODULE_PATHS[@]}"; do
    MODULES_XML+="        <module>${path}</module>\n"
done
MODULES_XML+="    </modules>"

# ─── Replace the existing <modules>...</modules> block in the aggregator ──────
python3 - "$AGGREGATOR_POM" "$MODULES_XML" <<'EOF'
import sys, re

pom_path = sys.argv[1]
new_modules_block = sys.argv[2]

with open(pom_path, 'r') as f:
    content = f.read()

updated = re.sub(
    r'[ \t]*<modules>.*?</modules>',
    new_modules_block,
    content,
    flags=re.DOTALL
)

with open(pom_path, 'w') as f:
    f.write(updated)

print("✅ aggregator pom.xml updated successfully!")
EOF

echo ""
echo "🎉 Done! Reload VS Code with:"
echo "   Ctrl+Shift+P → Java: Clean Java Language Server Workspace → Restart and delete"