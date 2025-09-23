# Stage 1: build Go binary
FROM golang:1.21-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o microservice-go .

# Stage 2: runtime
FROM alpine:latest
WORKDIR /app

# Install tools for wait script
RUN apk add --no-cache bash curl netcat-openbsd coreutils

# Copy Go binary
COPY --from=build /app/microservice-go ./

# Copy wait script
COPY wait-for-redis.sh /wait-for-redis.sh
RUN chmod +x /wait-for-redis.sh

# Start service
ENTRYPOINT ["/wait-for-redis.sh"]
