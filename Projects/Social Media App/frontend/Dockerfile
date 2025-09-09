FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install bash
RUN apk add --no-cache bash

# Copy package.json and package-lock.json first for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source files
COPY . .

# Expose Vite dev server port
EXPOSE 5173

# Use Vite dev server with host binding for HMR
CMD ["npm", "run", "dev"]
