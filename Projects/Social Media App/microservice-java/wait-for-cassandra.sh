#!/bin/sh
echo "Waiting for Cassandra to be available..."
while ! nc -z cassandra 9042; do
  echo "Cassandra not ready yet..."
  sleep 2
done
echo "Cassandra is up! Starting microservice..."

# Find the jar file dynamically
JAR_FILE=$(ls /app/*.jar | head -n 1)

if [ -z "$JAR_FILE" ]; then
  echo "Error: No JAR file found in /app/"
  exit 1
fi

echo "Launching $JAR_FILE..."
exec java -jar "$JAR_FILE"
