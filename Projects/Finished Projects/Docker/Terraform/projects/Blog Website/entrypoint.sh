#!/bin/sh

echo "Waiting for MySQL..."
until python -c "
import socket, sys
try:
    socket.create_connection(('db', 3306), timeout=3)
    sys.exit(0)
except:
    sys.exit(1)
" 2>/dev/null; do
  echo "MySQL not ready, retrying in 3s..."
  sleep 3
done

echo "MySQL is ready!"
python manage.py makemigrations --noinput
python manage.py migrate --noinput
python manage.py collectstatic --noinput
exec gunicorn blogsite.wsgi:application --bind 0.0.0.0:8000