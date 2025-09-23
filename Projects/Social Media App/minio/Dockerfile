# Use official MinIO image as base
FROM minio/minio:latest

# Copy startup script
COPY start-minio.sh /usr/local/bin/start-minio.sh
RUN chmod +x /usr/local/bin/start-minio.sh

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/start-minio.sh"]

