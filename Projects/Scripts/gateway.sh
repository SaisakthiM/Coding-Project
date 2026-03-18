#!/bin/bash
set -e

BASE="$HOME/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects"
GATEWAY="$BASE/gateway"

mkdir -p "$GATEWAY/nginx"

# ─── STEP 1: UPDATE VITE CONFIGS (add base path) ─────────────────────────────

echo "📝 Updating vite.config.js base paths..."

cat > "$BASE/Notes App/frontend/notes_app_frontend/vite.config.js" << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  base: '/notes/',
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://notes-backend:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

cat > "$BASE/Bank Manager/frontend/vite.config.js" << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  base: '/bank/',
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 3000,
    strictPort: true,
    watch: {
      usePolling: true,
      interval: 100
    },
    hmr: {
      clientPort: 3000
    },
    proxy: {
      '/api': {
        target: 'http://bank-backend:8080',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
EOF

cat > "$BASE/Quiz App/quiz-app/vite.config.js" << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  base: '/quiz/',
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
  }
})
EOF

# Video already has base: '/video/' — leave it alone
echo "✅ Vite configs updated"

# ─── STEP 2: UPDATE PROD DOCKERFILES (no nginx inside, just build) ────────────

echo "📝 Updating Dockerfile.prod files to output only dist/..."

cat > "$BASE/Notes App/frontend/notes_app_frontend/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Just export the dist — gateway nginx will serve it via volume
FROM alpine
WORKDIR /dist
COPY --from=build /app/dist .
CMD ["sleep", "infinity"]
EOF

cat > "$BASE/Bank Manager/frontend/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM alpine
WORKDIR /dist
COPY --from=build /app/dist .
CMD ["sleep", "infinity"]
EOF

cat > "$BASE/Quiz App/quiz-app/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM alpine
WORKDIR /dist
COPY --from=build /app/dist .
CMD ["sleep", "infinity"]
EOF

cat > "$BASE/Video Uploader/Main/frontend/video-uploader/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM alpine
WORKDIR /dist
COPY --from=build /app/dist .
CMD ["sleep", "infinity"]
EOF

echo "✅ Prod Dockerfiles updated"

# ─── STEP 3: NGINX GATEWAY CONFIG ────────────────────────────────────────────

echo "📝 Writing nginx gateway config..."

cat > "$GATEWAY/nginx/default.conf" << 'EOF'
server {
    listen 80;
    server_name localhost;

    # ─── NOTES ───────────────────────────────────────────────
    location /notes/api/ {
        proxy_pass http://notes-backend:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /notes/ {
        root /apps;
        try_files $uri $uri/ /notes/index.html;
    }

    # ─── BANK ─────────────────────────────────────────────────
    location /bank/api/ {
        proxy_pass http://bank-backend:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /bank/ {
        root /apps;
        try_files $uri $uri/ /bank/index.html;
    }

    # ─── QUIZ ─────────────────────────────────────────────────
    location /quiz/ {
        root /apps;
        try_files $uri $uri/ /quiz/index.html;
    }

    # ─── VIDEO ────────────────────────────────────────────────
    location /video/api/ {
        proxy_pass http://video-uploader-backend:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /video/ {
        root /apps;
        try_files $uri $uri/ /video/index.html;
    }

    # ─── HOSPITAL (Django only, no frontend) ──────────────────
    location /hospital/ {
        proxy_pass http://hospital-management:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ─── BLOG (Django only, no frontend) ──────────────────────
    location /blog/ {
        proxy_pass http://blog-website:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ─── DEFAULT ──────────────────────────────────────────────
    location / {
        return 200 '{"status":"gateway running","apps":["/notes/","/bank/","/quiz/","/video/","/hospital/","/blog/"]}';
        add_header Content-Type application/json;
    }
}
EOF

echo "✅ Nginx gateway config written"

# ─── STEP 4: MASTER DOCKER-COMPOSE ───────────────────────────────────────────

echo "📝 Writing master docker-compose.yml..."

cat > "$GATEWAY/docker-compose.yml" << 'EOF'
services:

  # ─── GATEWAY ────────────────────────────────────────────────
  gateway:
    image: nginx:alpine
    container_name: gateway
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
      - notes-dist:/apps/notes
      - bank-dist:/apps/bank
      - quiz-dist:/apps/quiz
      - video-dist:/apps/video
    depends_on:
      - notes-frontend-build
      - bank-frontend-build
      - quiz-frontend-build
      - video-frontend-build
    networks:
      - gateway-net

  # ─── NOTES ──────────────────────────────────────────────────
  notes-postgres:
    image: postgres:16
    container_name: notes-postgres
    environment:
      POSTGRES_DB: notes_app
      POSTGRES_USER: saisakthi
      POSTGRES_PASSWORD: sai2008
    volumes:
      - notes-pgdata:/var/lib/postgresql/data
    networks:
      - gateway-net

  notes-backend:
    build:
      context: ../Notes App/backend
    container_name: notes-backend
    command: >
      sh -c "python manage.py migrate &&
             python manage.py collectstatic --noinput &&
             gunicorn notes_app.wsgi:application --bind 0.0.0.0:8000"
    volumes:
      - notes-static:/static
      - notes-media:/media
    environment:
      DATABASE_NAME: notes_app
      DATABASE_USER: saisakthi
      DATABASE_PASSWORD: sai2008
      DATABASE_HOST: notes-postgres
    depends_on:
      - notes-postgres
    networks:
      - gateway-net

  notes-frontend-build:
    build:
      context: ../Notes App/frontend/notes_app_frontend
      dockerfile: Dockerfile.prod
    container_name: notes-frontend-build
    volumes:
      - notes-dist:/dist
    networks:
      - gateway-net

  # ─── BANK ───────────────────────────────────────────────────
  bank-postgres:
    image: postgres:16-alpine
    container_name: bank-postgres
    environment:
      POSTGRES_USER: bankmanagement
      POSTGRES_PASSWORD: bankmanagement@2008
      POSTGRES_DB: bank
    volumes:
      - bank-pgdata:/var/lib/postgresql/data
    networks:
      - gateway-net

  bank-backend:
    build:
      context: ../Bank Manager/backend/bank_management
    container_name: bank-backend
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://bank-postgres:5432/bank
      SPRING_DATASOURCE_USERNAME: bankmanagement
      SPRING_DATASOURCE_PASSWORD: bankmanagement@2008
    depends_on:
      - bank-postgres
    networks:
      - gateway-net

  bank-frontend-build:
    build:
      context: ../Bank Manager/frontend
      dockerfile: Dockerfile.prod
    container_name: bank-frontend-build
    volumes:
      - bank-dist:/dist
    networks:
      - gateway-net

  # ─── QUIZ ───────────────────────────────────────────────────
  quiz-frontend-build:
    build:
      context: ../Quiz App/quiz-app
      dockerfile: Dockerfile.prod
    container_name: quiz-frontend-build
    volumes:
      - quiz-dist:/dist
    networks:
      - gateway-net

  # ─── VIDEO UPLOADER ─────────────────────────────────────────
  video-uploader-backend:
    build:
      context: ../Video Uploader/Main/backend
    container_name: video-uploader-backend
    volumes:
      - ./backend/Uploads:/app/Uploads
    networks:
      - gateway-net

  video-frontend-build:
    build:
      context: ../Video Uploader/Main/frontend/video-uploader
      dockerfile: Dockerfile.prod
    container_name: video-frontend-build
    volumes:
      - video-dist:/dist
    networks:
      - gateway-net

  # ─── HOSPITAL (Django, no frontend) ─────────────────────────
  hospital-management:
    image: hospital_management:latest
    container_name: hospital-management
    networks:
      - gateway-net

  # ─── BLOG (Django, no frontend) ─────────────────────────────
  blog-website:
    image: blogsite:latest
    container_name: blog-website
    networks:
      - gateway-net

networks:
  gateway-net:
    driver: bridge

volumes:
  notes-pgdata:
  notes-static:
  notes-media:
  notes-dist:
  bank-pgdata:
  bank-dist:
  quiz-dist:
  video-dist:
EOF

echo "✅ Master docker-compose.yml written"

# ─── DONE ────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SETUP COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  To start everything:"
echo "  cd '$GATEWAY'"
echo "  docker compose up -d --build"
echo ""
echo "  Your apps will be at:"
echo "  http://localhost/notes/"
echo "  http://localhost/bank/"
echo "  http://localhost/quiz/"
echo "  http://localhost/video/"
echo "  http://localhost/hospital/"
echo "  http://localhost/blog/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"