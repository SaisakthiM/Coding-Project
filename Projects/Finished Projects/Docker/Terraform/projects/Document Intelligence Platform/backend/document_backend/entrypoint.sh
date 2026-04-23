#!/bin/sh

echo "⏳ Waiting for DB to be ready..."

# Wait until Django can reach the database
until python manage.py showmigrations > /dev/null 2>&1; do
  echo "  DB not ready yet, retrying in 3s..."
  sleep 3
done

echo "✅ DB is ready"

echo "🔄 Running migrations..."
python manage.py migrate --noinput

echo "📦 Collecting static files..."
python manage.py collectstatic --noinput

echo "🚀 Starting Gunicorn..."
exec "$@"