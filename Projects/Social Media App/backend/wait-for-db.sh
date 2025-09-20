#!/bin/sh
echo "Waiting for database..."

until nc -z db 5432; do
  sleep 1
done

echo "Database ready! Running migrations and static collection..."
python manage.py migrate --noinput
python manage.py collectstatic --noinput

echo "Starting Gunicorn server..."
exec gunicorn social_media.wsgi:application \
     --bind 0.0.0.0:8000 \
     --workers 3 \
     --log-level info
