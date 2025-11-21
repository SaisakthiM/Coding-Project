FROM node:22-slim

WORKDIR /app

# Copy only dependency files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy project files
COPY . .

# Expose Vite port
EXPOSE 5173

# Enable HMR + container access
CMD ["npm", "run", "dev", "--host"]
