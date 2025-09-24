FROM python:3.12-slim-bookworm

WORKDIR /app

# Install system dependencies + dos2unix
RUN apt-get update && apt-get install -y \
    netcat-openbsd gcc libpq-dev dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && pip check

# Install graphene-django separately
RUN pip install graphene-django

# Copy project files
COPY . .

# Copy wait-for-db.sh and make it executable
COPY wait-for-db.sh /wait-for-db.sh
RUN dos2unix /wait-for-db.sh && chmod +x /wait-for-db.sh

WORKDIR /app/social_media

# Run wait-for-db.sh when container starts
CMD ["/wait-for-db.sh"]
