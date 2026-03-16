#!/bin/sh

# Maximum wait time in seconds
TIMEOUT=60
i=0

echo "Waiting for Postgres..."
# Wait for Postgres
until nc -z postgres 5432; do
  sleep 1
  i=$((i+1))
  if [ $i -ge $TIMEOUT ]; then
    echo "Postgres not ready after $TIMEOUT seconds, exiting."
    exit 1
  fi
done
echo "Postgres is ready!"

# Reset counter for MinIO
i=0
echo "Waiting for MinIO..."
# Wait for MinIO
until nc -z minio 9000; do
  sleep 1
  i=$((i+1))
  if [ $i -ge $TIMEOUT ]; then
    echo "MinIO not ready after $TIMEOUT seconds, exiting."
    exit 1
  fi
done
echo "MinIO is ready!"

# Run Django migrations and collect static files
echo "Running migrations and collecting static files..."
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Start Gunicorn server
echo "Starting Gunicorn server..."
exec gunicorn social_media.wsgi:application \
     --bind 0.0.0.0:8000 \
     --workers 3 \
     --log-level info
