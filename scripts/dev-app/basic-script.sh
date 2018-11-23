#!/bin/bash

# INSTALL DJANGO AND CREATE PROJECT
pip install django~=2.0.8

echo "enter project name, no spaces or hyphens"
read -p 'Project Name: ' ProjectName

django-admin startproject $ProjectName .

# ENVIORNMENT VARIABLES
# add projectname to bashrc so it can be used as enviornment variable
echo "# ============================================================================ #" >> ~/.bashrc
echo "# +++++++++++++++++ $ProjectName Enviornment Variables" >> ~/.bashrc
echo "# ============================================================================ #" >> ~/.bashrc
echo >> ~/.bashrc
echo "# Django Project Name" >> ~/.bashrc
echo -e export DJANGO_PROJECT=$ProjectName >> ~/.bashrc

# BASH ALIASES
echo >> ~/.bash_aliases
echo -e \alias run=\"python ~/workspace/manage.py runserver '\u0024'IP:'\u0024'C9_PORT\" >> ~/.bash_aliases


# CREATE DIRECTORIES
mkdir -p static/css
mkdir static/js
mkdir static/lib
mkdir static/images

mkdir media

mkdir templates

# CREATE FILES
touch static/css/style.css
touch static/js/custom.js

touch templates/base.html


# =================SETTINGS
# Delete all lines in the files
:> $ProjectName/settings.py

# Add basic settings code
cat <<EOT >> $ProjectName/settings.py
import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '%)*tu&w_vq7vz+bk(2p3gjx121hk!#8$0qpkmw770=24-_s2vg'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['$C9_HOSTNAME']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = '$ProjectName.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.media',
            ],
        },
    },
]

WSGI_APPLICATION = '$ProjectName.wsgi.application'


# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}


# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',},
]


# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True


# Static files (CSS, JavaScript, Images)
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

MESSAGE_STORAGE = 'django.contrib.messages.storage.session.SessionStorage'
EOT

# MEDIA
# create media folder and add it to .gitignore file

# GIT IGNORE
echo db.sqlite3 >> .gitignore
echo media >> .gitignore
echo htmlcov >> .gitignore

# INSTALLATIONS
pip install Pillow
pip install coverage
pip freeze > requirements.txt

# MIGRATE AND CREATE SUPERUSER
python manage.py migrate
python manage.py createsuperuser

