# ============================================================
# ADD / REPLACE these sections in your settings.py
# ============================================================

# --- INSTALLED_APPS ---
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Third-party
    "rest_framework",
    "rest_framework_simplejwt",
    "rest_framework_simplejwt.token_blacklist",
    "corsheaders",
    "django_prometheus",
    # Local apps
    "apps.users",
    "apps.posts",
    "apps.stories",
    "apps.notifications",
    "apps.messages",
]

# --- MIDDLEWARE (add corsheaders near top) ---
MIDDLEWARE = [
    "django_prometheus.middleware.PrometheusBeforeMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "django_prometheus.middleware.PrometheusAfterMiddleware",
]

# --- AUTH USER ---
AUTH_USER_MODEL = "users.CustomUser"

# --- REST FRAMEWORK ---
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 10,
}

# --- JWT ---
from datetime import timedelta
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(hours=2),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=7),
    "ROTATE_REFRESH_TOKENS": True,
    "BLACKLIST_AFTER_ROTATION": True,
}

# --- CORS ---
# Dev: allow all origins. Prod: set ALLOWED_HOSTS env var
import os as _os
if _os.environ.get('DEBUG', 'True') == 'True':
    CORS_ALLOW_ALL_ORIGINS = True
else:
    CORS_ALLOWED_ORIGINS = [
        o.strip() for o in
        _os.environ.get('CORS_ALLOWED_ORIGINS', 'http://localhost').split(',')
    ]
CORS_ALLOW_CREDENTIALS = True

# --- MEDIA FILES (MinIO / local fallback) ---
import os
MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")

# --- If using MinIO with django-storages (production) ---
# DEFAULT_FILE_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"
# AWS_ACCESS_KEY_ID = os.environ.get("MEDIA_STORAGE_KEY", "minio")
# AWS_SECRET_ACCESS_KEY = os.environ.get("MEDIA_STORAGE_SECRET", "minio123")
# AWS_STORAGE_BUCKET_NAME = "media"
# AWS_S3_ENDPOINT_URL = os.environ.get("MEDIA_STORAGE_URL", "http://minio:9000")
# AWS_DEFAULT_ACL = "public-read"
# AWS_S3_FILE_OVERWRITE = False

