#!/bin/bash

paths=(
  # Frontend apps
  "/notes/"
  "/bank/"
  "/quiz/"
  "/video/"
  "/hospital/"
  "/blog/"
  "/social/"
  "/api-service/"
  "/document/"
  "/intro/"
  # API endpoints
  "/notes/api/"
  "/bank/api/"
  "/video/api/"
  "/api-service/api/"
  "/document/api/"
  "/hospital/api/"
  # Blog specific
  "/blog/admin/"
  "/blog/admin/login/"
  "/blog/api/"
  # Social media
  "/social/api/"
  "/social/api/auth/me/"
  "/social/api/metrics"
  "/social/minio/"
  # Spring Boot actuator
  "/bank/api/actuator"
  "/bank/api/actuator/health"
  "/bank/api/actuator/env"
  "/bank/api/actuator/mappings"
  # Sensitive files
  "/blog/robots.txt"
  "/blog/.env"
  "/.git/config"
  "/document/api/admin/"
)

echo "=== Gateway Recon ==="
for path in "${paths[@]}"; do
  code=$(curl -o /dev/null -sw "%{http_code}" --max-time 3 http://localhost"$path")
  echo "$code  =>  $path"
done