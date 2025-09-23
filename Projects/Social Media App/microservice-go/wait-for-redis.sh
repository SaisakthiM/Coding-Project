#!/bin/sh
echo "Waiting for Redis to be available..."
while ! nc -z redis 6379; do
  echo "Redis not ready yet..."
  sleep 2
done
echo "Redis is up! Starting microservice..."

# Run the binary
exec /app/microservice-go
