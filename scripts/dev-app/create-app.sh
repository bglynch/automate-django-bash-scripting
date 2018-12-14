#!/bin/bash

# GET PROJECT NAME
# get the project name from the 6th line of the manage.py file
GetStringContainingProjectName="$(sed -n '6p' manage.py)"
StringToArray=($(echo "$GetStringContainingProjectName" | tr ',".' '\n'))
ProjectName=${StringToArray[4]}

# ask for app name
echo "What is the name of your app"
read -p 'App Name: ' AppName

# create app
python manage.py startapp $AppName

# create templates folder in the app
mkdir -p $AppName/templates/$AppName

# create a urls file in the app
AppUrl="$AppName"_urls
touch $AppName/$AppUrl.py

cat <<EOT >> $AppName/$AppUrl.py
from django.urls import path
import $AppName.views as view


urlpatterns = [
    # path('url_pattern', view.view_name, name='url_name'),
    path('', view.sample_view, name='sample'),
    ]
EOT

# add app to settings
sed -i "/INSTALLED_APPS/s/\[/\[\n    '$AppName',/g" $ProjectName/settings.py

# add app/urls to project urls
sed -i "/from django.urls import path, include/s/include/include\nfrom $AppName import $AppUrl/g" $ProjectName/urls.py

sed -i "/admin/s/),/),\n    path('$AppName\/', include\($AppUrl\)),/g" $ProjectName/urls.py

# create sample view
:> $AppName/views.py

cat <<EOT >> $AppName/views.py
from django.shortcuts import render
from django.http import HttpResponse


def sample_view(request):
    ''' sample view '''
    return HttpResponse('<h1>$AppName Home</h1>')

EOT



# USER FEEDBACK
echo
echo -e "\e[1;36m/---------- Create App script ----------/\e[0m"
echo "Created App: '$AppName'"
echo "Added templates directory: '$AppName/templates/$AppName'"
echo "Added app urls file: '$AppName/$AppUrl.py'"
echo "Updated $ProjectName/urls.py to include '$AppName urls'"
echo