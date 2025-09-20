FROM golang:1.25-alpine AS build
WORKDIR /app

# Copy mod files (even if go.sum is empty)
COPY go.mod go.sum ./

# Download dependencies (optional since none)
RUN go mod download

# Copy source code
COPY . .

# Build binary
RUN go build -o main .

# Minimal runtime image
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=build /app/main .
CMD ["./main"]
