# --------- Stage 0: Base Node Image ---------
FROM node:20-bullseye AS base
WORKDIR /app
COPY package*.json ./

# Install dependencies with proper flags for Docker
RUN npm ci --include=optional --legacy-peer-deps

# --------- Stage 1: Dev Frontend (Vite/HMR) ---------
FROM base AS dev
COPY . .
EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

# --------- Stage 2: Build Frontend for Production ---------
FROM base AS builder
COPY . .
RUN npm run build

# --------- Stage 3: Serve Production with Nginx ---------
FROM nginx:alpine AS production
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]