#!/bin/sh
set -e

# Start MinIO with console (WebUI) on fixed port
minio server /data --console-address ":9001" &
MINIO_PID=$!

# Wait until MinIO API responds
echo "Waiting for MinIO to be ready..."
until mc alias set local http://127.0.0.1:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD >/dev/null 2>&1; do
    sleep 1
done

echo "MinIO is ready, creating 'media' bucket if it doesn't exist..."
mc mb --ignore-existing local/media

# Wait for MinIO process to exit
wait $MINIO_PID
