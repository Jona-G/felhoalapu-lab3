import os
from django.conf import settings

def config():
    engine = os.getenv('DATABASE_ENGINE', 'sqlite').lower()
    
    if engine == 'postgresql':
        return {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': os.getenv('DATABASE_NAME', 'sampledb'),
            'USER': os.getenv('DATABASE_USER', 'myuser'),
            'PASSWORD': os.getenv('DATABASE_PASSWORD', 'mypassword'),
            'HOST': os.getenv('DATABASE_HOST', 'postgresql'),
            'PORT': os.getenv('DATABASE_PORT', '5432'),
        }
    
    # Fallback to local SQLite
    return {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(settings.BASE_DIR, 'db.sqlite3'),
    }