#!/bin/bash
set -e

echo "Waiting for PostgreSQL..."

until (echo > /dev/tcp/$DB_HOST/$DB_PORT) >/dev/null 2>&1; do
  echo "PostgreSQL unavailable..."
  sleep 2
done

echo "Running tests..."

mvn test

echo "Packaging application..."

mvn clean package -DskipTests

echo "Starting application..."

exec java -jar target/*.jar