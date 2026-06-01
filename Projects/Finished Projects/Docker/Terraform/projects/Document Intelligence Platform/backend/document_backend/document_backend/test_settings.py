from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

MINIO_ENDPOINT = 'localhost:9000'
MINIO_SECURE = False
GEMINI_API_KEY = 'test-key'
OLLAMA_HOST = 'localhost'