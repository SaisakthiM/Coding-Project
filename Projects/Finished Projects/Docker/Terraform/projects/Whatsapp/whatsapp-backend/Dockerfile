# Stage 1: Build Environment
FROM rust:1-bookworm AS builder

WORKDIR /app

# Install musl-dev to compile C-dependencies required by sqlx/tokio on Alpine
RUN apk add --no-cache musl-dev

# Copy all source files
COPY . .

# Build the release binary
RUN cargo build --release

# Stage 2: Production Environment
FROM alpine:latest

WORKDIR /app

# Copy ONLY the compiled binary from the builder stage
COPY --from=builder /app/target/release/whatsapp-backend .

# Copy your .env file so the database URL and JWT secret are loaded
COPY .env .

# Expose the port your Axum server runs on
EXPOSE 8000

# Run the binary
CMD ["./whatsapp-backend"]