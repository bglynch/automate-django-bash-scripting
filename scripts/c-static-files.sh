#!/bin/bash
# Create folders and blank files for custom static files
mkdir -p static/css
wget https://raw.githubusercontent.com/bglynch/templates/master/css/bootstrap.css -O ./static/css/style.css 

mkdir -p static/js
touch static/js/custom.js

mkdir -p static/lib

mkdir -p static/images

# add static files locations to settings
echo STATICFILES_DIRS = \(os.path.join\(BASE_DIR, 'static'\), \) >> ./$DJANGO_PROJECT/settings.py 
echo STATIC_ROOT = os.path.join\(BASE_DIR, 'static'\) >> ./$DJANGO_PROJECT/settings.py 

# # create template file and add basic base.html
mkdir -p templates
wget https://raw.githubusercontent.com/bglynch/templates/master/django/html/bootstrap-home.html -O ./templates/base.html 

# add templates to settings.py
sed -i "/DIRS/s/\[\]/\[os.path.join\(BASE_DIR, 'templates'\)\]/g" ./$DJANGO_PROJECT/settings.py