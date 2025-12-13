FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Set working directory to where manage.py exists
WORKDIR /app/notes_app

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "notes_app.wsgi:application", "--bind", "0.0.0.0:8000"]
