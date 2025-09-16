FROM python:3.12-slim-bookworm

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    netcat-openbsd gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (without graphene-django)
COPY requirements.txt .

# Upgrade pip, setuptools, wheel and install other dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && pip check

# Now install graphene-django separately
RUN pip install graphene-django

# Copy the project files
COPY . .

# Copy wait-for-db.sh and make it executable
COPY wait-for-db.sh /wait-for-db.sh
RUN chmod +x /wait-for-db.sh

# Set working directory to Django app
WORKDIR /app/social_media

# Run wait-for-db.sh when container starts
CMD ["/wait-for-db.sh"]
