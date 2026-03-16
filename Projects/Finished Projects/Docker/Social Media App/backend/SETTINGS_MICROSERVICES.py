# ============================================================
# Add these to your existing SETTINGS_ADDITIONS.py / settings.py
# ============================================================

import os

# ── Microservice URLs ────────────────────────────────────────
GO_SERVICE_URL   = os.environ.get('GO_SERVICE_URL',   'http://microservice-go:8080')
JAVA_SERVICE_URL = os.environ.get('JAVA_SERVICE_URL', 'http://microservice-java:8080')

# ── Kafka ────────────────────────────────────────────────────
KAFKA_BOOTSTRAP_SERVERS = os.environ.get('KAFKA_BOOTSTRAP_SERVERS', 'kafka:9092')

# ── MinIO Media Storage ───────────────────────────────────────
# Uncomment this block to enable MinIO instead of local file storage
#
# DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
# AWS_ACCESS_KEY_ID       = os.environ.get('MEDIA_STORAGE_KEY',    'minio')
# AWS_SECRET_ACCESS_KEY   = os.environ.get('MEDIA_STORAGE_SECRET', 'minio123')
# AWS_STORAGE_BUCKET_NAME = 'media'
# AWS_S3_ENDPOINT_URL     = os.environ.get('MEDIA_STORAGE_URL',    'http://minio:9000')
# AWS_DEFAULT_ACL         = 'public-read'
# AWS_S3_FILE_OVERWRITE   = False
# AWS_S3_CUSTOM_DOMAIN    = None
# MEDIA_URL = f"{AWS_S3_ENDPOINT_URL}/media/"

# ── OpenTelemetry → Tempo ────────────────────────────────────
# Uncomment to enable distributed tracing
#
# from opentelemetry import trace
# from opentelemetry.sdk.trace import TracerProvider
# from opentelemetry.sdk.trace.export import BatchSpanProcessor
# from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
# from opentelemetry.instrumentation.django import DjangoInstrumentor
# from opentelemetry.instrumentation.requests import RequestsInstrumentor
#
# provider = TracerProvider()
# provider.add_span_processor(BatchSpanProcessor(
#     OTLPSpanExporter(endpoint="http://tempo:4317", insecure=True)
# ))
# trace.set_tracer_provider(provider)
# DjangoInstrumentor().instrument()
# RequestsInstrumentor().instrument()

# ── apps/kafka_events.py location ────────────────────────────
# Copy django-kafka/kafka_events.py → backend/social_media/apps/kafka_events.py
# Then import in views:
#   from apps.kafka_events import publish_post_created

