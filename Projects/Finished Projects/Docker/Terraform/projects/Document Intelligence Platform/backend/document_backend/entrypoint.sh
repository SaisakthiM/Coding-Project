#!/bin/sh

echo "⏳ Waiting for DB to be ready..."

until python -c "import socket; s=socket.create_connection(('db', 3306), timeout=3)" 2>/dev/null; do
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