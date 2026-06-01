from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Use local file storage instead of MinIO in tests
DEFAULT_FILE_STORAGE = 'django.core.files.storage.FileSystemStorage'
MINIO_ENDPOINT = None