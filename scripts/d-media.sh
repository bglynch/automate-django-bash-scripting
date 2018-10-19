#!/bin/bash
# Install pillow
sudo pip3 install pillow

# add media folder
mkdir -p media

# add media context processors to settings.py
sed -i -e "/'django.contrib.messages.context_processors.messages',/a\                'django.template.context_processors.media'," ./$DJANGO_PROJECT/settings.py

# add media roots to settings.py
echo " "
echo MEDIA_URL = '/media/' >> ./$DJANGO_PROJECT/settings.py 
echo MEDIA_ROOT = os.path.join\(BASE_DIR, 'media'\) >> ./$DJANGO_PROJECT/settings.py 

pip3 freeze --local > requirements.txt