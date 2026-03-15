import os
from django.conf import settings

def config():
    engine = os.getenv('DATABASE_ENGINE', 'sqlite').lower()
    
    if engine == 'postgresql':
        return {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'postgresdb',
            'USER': 'myuser',
            'PASSWORD': 'mypassword',
            'HOST': 'postgresdb',
            'PORT': '5432'
        }
    
    # Fallback to local SQLite
    return {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(settings.BASE_DIR, 'db.sqlite3'),
    }