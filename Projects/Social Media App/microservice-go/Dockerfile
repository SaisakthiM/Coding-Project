# Stage 1: build
FROM golang:1.25 AS build
WORKDIR /app

# Copy mod files for caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source and build
COPY . .
RUN go build -o microservice-go .

# Stage 2: runtime
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache bash curl netcat-openbsd coreutils

COPY --from=build /app/microservice-go . 
COPY wait-for-redis.sh /wait-for-redis.sh
RUN chmod +x /wait-for-redis.sh

ENTRYPOINT ["/wait-for-redis.sh"]
