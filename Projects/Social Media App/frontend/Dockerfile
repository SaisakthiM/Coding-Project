# -----------------------------
# Stage 1: Builder
# -----------------------------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copy package.json & package-lock.json first for caching
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy source files
COPY . .

# Build production files
RUN npm run build

# -----------------------------
# Stage 2: Production image (Nginx)
# -----------------------------
FROM nginx:alpine AS prod

# Copy built files
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default Nginx config and use custom
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# -----------------------------
# Stage 3: Development
# -----------------------------
FROM node:20-bullseye AS dev

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
