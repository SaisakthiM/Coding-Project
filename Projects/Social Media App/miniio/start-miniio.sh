#!/bin/sh
set -e

# Start MinIO in the background
minio server /data &

# Get PID of MinIO process
MINIO_PID=$!

# Wait until MinIO responds
echo "Waiting for MinIO to be ready..."
while ! mc alias set local http://127.0.0.1:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD >/dev/null 2>&1; do
    sleep 1
done

echo "MinIO is ready, creating 'media' bucket if it doesn't exist..."
mc mb --ignore-existing local/media

# Bring MinIO process to foreground
wait $MINIO_PID
