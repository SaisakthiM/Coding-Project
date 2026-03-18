#!/bin/bash
set -e

BASE="/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects"

# ─── NOTES APP ───────────────────────────────────────────────────────────────
echo "📝 Fixing Notes App..."

# Fix NoteHandler.js - hardcoded localhost:8000
sed -i 's|http://localhost:8000/api|/api|g' \
  "$BASE/Notes App/frontend/notes_app_frontend/src/notes/NoteHandler.js"

# Fix apiHandler.js - uses API_BASE which likely points to localhost
cat > "$BASE/Notes App/frontend/notes_app_frontend/src/api/apiHandler.js" << 'EOF'
import axios from "axios";

const API_BASE = "/api";

const api = axios.create({
  baseURL: API_BASE,
  withCredentials: true,
});

export default api;
EOF

# Fix vite.config.js proxy target - should point to container name not localhost
sed -i "s|target: 'http://localhost:8000'|target: 'http://notes-backend:8000'|g" \
  "$BASE/Notes App/frontend/notes_app_frontend/vite.config.js"

echo "✅ Notes App fixed"

# ─── BANK MANAGER ────────────────────────────────────────────────────────────
echo "📝 Fixing Bank Manager..."

# Fix bankService.js - hardcoded localhost:8080
sed -i "s|import.meta.env.VITE_API_URL || 'http://localhost:8080'|'/bank/api'|g" \
  "$BASE/Bank Manager/frontend/src/components/bankService.js"

echo "✅ Bank Manager fixed"

# ─── VIDEO UPLOADER ──────────────────────────────────────────────────────────
echo "📝 Fixing Video Uploader..."

# Fix Upload.jsx - hardcoded localhost:8080
sed -i 's|http://localhost:8080/upload|/video/api/upload|g' \
  "$BASE/Video Uploader/Main/frontend/video-uploader/src/components/Upload.jsx"

# Fix Getter.js - hardcoded localhost:8080
sed -i 's|http://localhost:8080/getFiles|/video/api/getFiles|g' \
  "$BASE/Video Uploader/Main/frontend/video-uploader/src/components/Getter.js"

# Fix Download.jsx - hardcoded localhost:8080
sed -i 's|http://localhost:8080/download/|/video/api/download/|g' \
  "$BASE/Video Uploader/Main/frontend/video-uploader/src/components/Downlaod.jsx"

echo "✅ Video Uploader fixed"

# ─── VERIFY ──────────────────────────────────────────────────────────────────
echo ""
echo "🔍 Verifying no more hardcoded localhost URLs..."
grep -rn "localhost:8000\|localhost:8080\|localhost:8006" \
  "$BASE/Notes App/frontend" \
  "$BASE/Bank Manager/frontend" \
  "$BASE/Video Uploader/Main/frontend" \
  --include="*.js" --include="*.jsx" \
  2>/dev/null | grep -v node_modules | grep -v dist | grep -v vite.config.js \
  && echo "⚠️  Some localhost URLs still remain!" || echo "✅ All clean!"

# ─── REBUILD ─────────────────────────────────────────────────────────────────
echo ""
echo "🔨 Rebuilding affected frontend images..."

GATEWAY="/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects/gateway"

# Remove old volumes to force fresh build
docker volume rm gateway_notes-dist gateway_bank-dist gateway_video-dist 2>/dev/null || true

# Rebuild images
docker build -t notes-frontend-build:latest \
  -f "$BASE/Notes App/frontend/notes_app_frontend/Dockerfile.prod" \
  "$BASE/Notes App/frontend/notes_app_frontend"

docker build -t bank-frontend-build:latest \
  -f "$BASE/Bank Manager/frontend/Dockerfile.prod" \
  "$BASE/Bank Manager/frontend"

docker build -t video-frontend-build:latest \
  -f "$BASE/Video Uploader/Main/frontend/video-uploader/Dockerfile.prod" \
  "$BASE/Video Uploader/Main/frontend/video-uploader"

# Re-run build containers to populate volumes
docker rm -f notes-frontend-build bank-frontend-build video-frontend-build 2>/dev/null || true

docker run -d --name notes-frontend-build \
  -v gateway_notes-dist:/dist \
  notes-frontend-build:latest

docker run -d --name bank-frontend-build \
  -v gateway_bank-dist:/dist \
  bank-frontend-build:latest

docker run -d --name video-frontend-build \
  -v gateway_video-dist:/dist \
  video-frontend-build:latest

echo ""
echo "⏳ Waiting for builds to populate volumes..."
sleep 5

docker restart gateway

echo ""
echo "✅ All done! API routes:"
echo "  Notes API  → http://localhost/notes/api/"
echo "  Bank API   → http://localhost/bank/api/"
echo "  Video API  → http://localhost/video/api/"