#!/bin/sh

echo "Waiting for database..."

# Keep checking until Postgres is ready
until nc -z db 5432; do
  sleep 1
done

echo "Database ready! Running migrations and static collection..."

# Run Django migrations and collect static files
python manage.py migrate --noinput
python manage.py collectstatic --noinput

echo "Starting Django server..."
exec python manage.py runserver 0.0.0.0:8000
