FROM node:20-alpine

WORKDIR /app

# Install bash & deps
RUN apk add --no-cache bash

# Install deps separately for caching
COPY package*.json ./
RUN npm install

# Copy the rest
COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
