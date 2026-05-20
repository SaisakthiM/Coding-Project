#!/bin/sh

echo "Running tests..."
python manage.py test hospital.tests.test_hospital -v 2

if [ $? -ne 0 ]; then
    echo "Tests failed — stopping!"
    exit 1
fi

echo "Tests passed — starting server..."
exec gunicorn hospital_management.wsgi:application --bind 0.0.0.0:8000