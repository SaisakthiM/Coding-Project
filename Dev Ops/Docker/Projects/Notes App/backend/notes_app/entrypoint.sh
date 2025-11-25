#!/bin/sh
python manage.py migrate --noinput
python manage.py collectstatic --noinput
gunicorn notes_app.wsgi:application --bind 0.0.0.0:8000
