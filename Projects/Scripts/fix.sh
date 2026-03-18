#!/bin/bash
set -e

BASE="$HOME/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects"

# ─── STEP 1: STOP & REMOVE OLD CONTAINERS ────────────────────────────────────
echo "🛑 Stopping old containers..."
docker stop notes-frontend quiz-app bank-manager-frontend 2>/dev/null || true
docker rm   notes-frontend quiz-app bank-manager-frontend 2>/dev/null || true

# ─── STEP 2: DELETE OLD BROKEN IMAGES ────────────────────────────────────────
echo "🗑️  Removing old broken images..."
docker rmi \
  quiz-app-quiz_build:latest \
  quiz_app:latest \
  notesapp-frontend_build:latest \
  notesapp-frontend_dev:latest \
  notesapp-frontend_prod:latest \
  bankmanager-frontend_build:latest \
  bankmanager-frontend:latest \
  2>/dev/null || true

echo "✅ Old images removed"

# ─── STEP 3: FIX NOTES APP ───────────────────────────────────────────────────
NOTES="$BASE/Notes App/frontend/notes_app_frontend"
mkdir -p "$NOTES/nginx"

cat > "$NOTES/Dockerfile.dev" << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
EOF

cat > "$NOTES/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > "$NOTES/nginx/default.conf" << 'EOF'
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://notes-backend:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

cat > "$BASE/Notes App/docker-compose.dev.yml" << 'EOF'
services:
  postgres:
    image: postgres:16
    container_name: notes-postgres
    environment:
      POSTGRES_DB: notes_app
      POSTGRES_USER: saisakthi
      POSTGRES_PASSWORD: sai2008
    volumes:
      - pgdata:/var/lib/postgresql/data

  backend:
    build: ./backend
    container_name: notes-backend
    command: >
      sh -c "python manage.py migrate &&
             python manage.py collectstatic --noinput &&
             gunicorn notes_app.wsgi:application --bind 0.0.0.0:8000"
    volumes:
      - static_volume:/static
      - media_volume:/media
    environment:
      DATABASE_NAME: notes_app
      DATABASE_USER: saisakthi
      DATABASE_PASSWORD: sai2008
      DATABASE_HOST: postgres
    depends_on:
      - postgres

  frontend:
    build:
      context: ./frontend/notes_app_frontend
      dockerfile: Dockerfile.dev
    container_name: notes-frontend
    volumes:
      - ./frontend/notes_app_frontend:/app
      - /app/node_modules
    ports:
      - "5174:5173"
    environment:
      - CHOKIDAR_USEPOLLING=true
    depends_on:
      - backend

volumes:
  pgdata:
  static_volume:
  media_volume:
EOF

cat > "$BASE/Notes App/docker-compose.prod.yml" << 'EOF'
services:
  postgres:
    image: postgres:16
    container_name: notes-postgres
    environment:
      POSTGRES_DB: notes_app
      POSTGRES_USER: saisakthi
      POSTGRES_PASSWORD: sai2008
    volumes:
      - pgdata:/var/lib/postgresql/data

  backend:
    build: ./backend
    container_name: notes-backend
    command: >
      sh -c "python manage.py migrate &&
             python manage.py collectstatic --noinput &&
             gunicorn notes_app.wsgi:application --bind 0.0.0.0:8000"
    volumes:
      - static_volume:/static
      - media_volume:/media
    environment:
      DATABASE_NAME: notes_app
      DATABASE_USER: saisakthi
      DATABASE_PASSWORD: sai2008
      DATABASE_HOST: postgres
    depends_on:
      - postgres

  frontend:
    build:
      context: ./frontend/notes_app_frontend
      dockerfile: Dockerfile.prod
    container_name: notes-frontend-prod
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  pgdata:
  static_volume:
  media_volume:
EOF

echo "✅ Notes App fixed"

# ─── STEP 4: FIX BANK MANAGER ────────────────────────────────────────────────
BANK="$BASE/Bank Manager/frontend"
mkdir -p "$BANK/nginx"

cat > "$BANK/Dockerfile.dev" << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3000"]
EOF

cat > "$BANK/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > "$BANK/nginx/default.conf" << 'EOF'
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://bank-backend:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

cat > "$BASE/Bank Manager/docker-compose.dev.yml" << 'EOF'
services:
  db:
    image: postgres:16-alpine
    container_name: bank-postgres
    environment:
      POSTGRES_USER: bankmanagement
      POSTGRES_PASSWORD: bankmanagement@2008
      POSTGRES_DB: bank
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - bank-network

  backend:
    build:
      context: "./backend/bank_management"
    container_name: bank-backend
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/bank
      SPRING_DATASOURCE_USERNAME: bankmanagement
      SPRING_DATASOURCE_PASSWORD: bankmanagement@2008
    ports:
      - "8080:8080"
    networks:
      - bank-network

  frontend:
    build:
      context: "./frontend"
      dockerfile: Dockerfile.dev
    container_name: bank-frontend
    volumes:
      - ./frontend:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    networks:
      - bank-network

volumes:
  pgdata:
networks:
  bank-network:
EOF

cat > "$BASE/Bank Manager/docker-compose.prod.yml" << 'EOF'
services:
  db:
    image: postgres:16-alpine
    container_name: bank-postgres
    environment:
      POSTGRES_USER: bankmanagement
      POSTGRES_PASSWORD: bankmanagement@2008
      POSTGRES_DB: bank
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - bank-network

  backend:
    build:
      context: "./backend/bank_management"
    container_name: bank-backend
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/bank
      SPRING_DATASOURCE_USERNAME: bankmanagement
      SPRING_DATASOURCE_PASSWORD: bankmanagement@2008
    networks:
      - bank-network

  frontend:
    build:
      context: "./frontend"
      dockerfile: Dockerfile.prod
    container_name: bank-frontend-prod
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - bank-network

volumes:
  pgdata:
networks:
  bank-network:
EOF

echo "✅ Bank Manager fixed"

# ─── STEP 5: FIX QUIZ APP ────────────────────────────────────────────────────
QUIZ="$BASE/Quiz App/quiz-app"
mkdir -p "$QUIZ/nginx"

cat > "$QUIZ/Dockerfile.dev" << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
EOF

cat > "$QUIZ/Dockerfile.prod" << 'EOF'
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > "$QUIZ/nginx/default.conf" << 'EOF'
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

cat > "$QUIZ/docker-compose.dev.yml" << 'EOF'
services:
  frontend:
    build:
      context: .
      dockerfile: Dockerfile.dev
    container_name: quiz-frontend
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "5173:5173"
    environment:
      - CHOKIDAR_USEPOLLING=true
EOF

cat > "$QUIZ/docker-compose.prod.yml" << 'EOF'
services:
  frontend:
    build:
      context: .
      dockerfile: Dockerfile.prod
    container_name: quiz-frontend-prod
    ports:
      - "80:80"
EOF

echo "✅ Quiz App fixed"

# ─── STEP 6: REBUILD & RUN IN DEV MODE ───────────────────────────────────────
echo ""
echo "🔨 Rebuilding and starting all projects in DEV mode..."

echo ""
echo "▶ Starting Notes App (dev)..."
cd "$BASE/Notes App"
docker compose -f docker-compose.dev.yml up -d --build

echo ""
echo "▶ Starting Bank Manager (dev)..."
cd "$BASE/Bank Manager"
docker compose -f docker-compose.dev.yml up -d --build

echo ""
echo "▶ Starting Quiz App (dev)..."
cd "$BASE/Quiz App/quiz-app"
docker compose -f docker-compose.dev.yml up -d --build

# ─── DONE ────────────────────────────────────────────────────────────────────
echo ""
echo "🎉 All done! Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ACCESS YOUR APPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Notes App    (dev)  → http://localhost:5174"
echo "  Bank Manager (dev)  → http://localhost:3000"
echo "  Quiz App     (dev)  → http://localhost:5173"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  To switch any app to PROD (nginx on port 80):"
echo ""
echo "  Notes:  cd 'Notes App'        && docker compose -f docker-compose.prod.yml up -d --build"
echo "  Bank:   cd 'Bank Manager'     && docker compose -f docker-compose.prod.yml up -d --build"
echo "  Quiz:   cd 'Quiz App/quiz-app'&& docker compose -f docker-compose.prod.yml up -d --build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"