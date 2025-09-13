#!/bin/bash
set -e

# ===== 1️⃣ Upgrade asdf to v0.16+ =====
echo "Upgrading asdf to latest version..."
if [ -d "$HOME/.asdf" ]; then
    mv ~/.asdf ~/.asdf-backup
fi
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.16.1
echo ". \$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". \$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
source ~/.asdf/asdf.sh

# ===== 2️⃣ Install Node.js if missing =====
if ! command -v node >/dev/null 2>&1; then
    echo "Installing Node.js..."
    asdf plugin-add nodejs || true
    asdf install nodejs 22.14.0
    asdf local nodejs 22.14.0
fi

# ===== 3️⃣ Navigate to your project =====
PROJECT_DIR="/mnt/c/Coding Project/CSS/Tailwind CSS/Main/tailwind-project"
cd "$PROJECT_DIR"

# ===== 4️⃣ Clean old installs =====
rm -rf node_modules package-lock.json
npm cache clean --force

# ===== 5️⃣ Install Tailwind CLI + dependencies =====
npm install -D tailwindcss postcss autoprefixer

# ===== 6️⃣ Create folders =====
mkdir -p src dist

# ===== 7️⃣ Create starter CSS =====
INPUT_CSS="./src/input.css"
if [ ! -f "$INPUT_CSS" ]; then
cat <<EOL > "$INPUT_CSS"
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL
fi

# ===== 8️⃣ Initialize Tailwind config =====
npx tailwindcss init -p

# ===== 9️⃣ Add npm build script =====
PACKAGE_JSON="package.json"
if ! grep -q "\"build\"" "$PACKAGE_JSON"; then
    TMP_JSON=$(mktemp)
    jq '.scripts.build="npx tailwindcss -i ./src/input.css -o ./dist/output.css --watch"' package.json > "$TMP_JSON"
    mv "$TMP_JSON" package.json
fi

echo "✅ Tailwind setup complete!"
echo "Run 'npm run build' to start building your CSS."
