from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Remove debug toolbar for tests
INSTALLED_APPS = [app for app in INSTALLED_APPS if app != 'debug_toolbar']
DEBUG_TOOLBAR_CONFIG = {'IS_RUNNING_TESTS': False}

SECRET_KEY = 'test-secret-key-for-ci'
DEBUG = True