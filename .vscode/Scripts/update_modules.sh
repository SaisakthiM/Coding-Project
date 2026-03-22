#!/bin/bash

# ─── Config ───────────────────────────────────────────────────────────────────
AGGREGATOR_POM="/home/saisakthi/Coding-Project/pom.xml"
ROOT_DIR="/home/saisakthi/Coding-Project"
# ──────────────────────────────────────────────────────────────────────────────

echo "🔍 Scanning for pom.xml files under: $ROOT_DIR"

# Collect all pom.xml paths, excluding the aggregator itself and any target/ dirs
MODULE_PATHS=()
while IFS= read -r pom_file; do
    pom_dir=$(dirname "$pom_file")

    # Skip the aggregator pom itself
    if [ "$pom_dir" == "$ROOT_DIR" ]; then
        continue
    fi

    # Get path relative to aggregator
    rel_path="${pom_dir#$ROOT_DIR/}"
    MODULE_PATHS+=("$rel_path")
    echo "  ✅ Found: $rel_path"
done < <(find "$ROOT_DIR" \
    -not -path "*/target/*" \
    -not -path "*/.git/*" \
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
# Uses Python for reliable multi-line XML replacement
python3 - "$AGGREGATOR_POM" "$MODULES_XML" <<'EOF'
import sys, re

pom_path = sys.argv[1]
new_modules_block = sys.argv[2]

with open(pom_path, 'r') as f:
    content = f.read()

# Replace everything between <modules> and </modules> (inclusive)
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
echo "   Ctrl+Shift+P → Java: Reload Projects"