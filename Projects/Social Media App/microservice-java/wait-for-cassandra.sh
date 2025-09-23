#!/bin/sh
echo "Waiting for Cassandra to be available..."
while ! nc -z cassandra 9042; do
  echo "Cassandra not ready yet..."
  sleep 2
done
echo "Cassandra is up! Starting microservice..."

# Pick the jar dynamically
JAR_FILE=\
exec java -jar \
