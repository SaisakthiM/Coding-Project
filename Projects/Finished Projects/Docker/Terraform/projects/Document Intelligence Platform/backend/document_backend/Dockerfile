FROM python:trixie-slim

WORKDIR /app

# Copy only requirements first for better layer caching
COPY requirements.txt .

# Combine pip installs and clean up cache in one layer
RUN pip install --no-cache-dir -r requirements.txt mysqlclient

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY . .

ENTRYPOINT ["/entrypoint.sh"]