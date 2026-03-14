import os
from django.conf import settings

def config():
    return {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.getenv('DATABASE_NAME', 'sampledb'),
        'USER': os.getenv('DATABASE_USER', 'myuser'),
        'PASSWORD': os.getenv('DATABASE_PASSWORD', 'mypassword'),
        'HOST': os.getenv('DATABASE_HOST', 'postgresql'),
        'PORT': os.getenv('DATABASE_PORT', '5432'),
    }