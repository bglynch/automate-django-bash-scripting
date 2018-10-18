#!/bin/bash
# install django 2.0
sudo pip3 install django==2.0

# create django project - same name as to name of the workspace
django-admin startproject $1 .

# updated tohe bash_aliases to type 'run' to run the application
echo -e \alias run=\"python3 ~/workspace/manage.py runserver '\u0024'IP:'\u0024'C9_PORT\" >> ~/.bash_aliases

echo -e \alias PROJECTNAME=\"$1\" >> ~/.bash_aliases



# add allowed host in settings.py
sed -i "/ALLOWED_HOSTS/s/\[\]/\['$C9_HOSTNAME'\]/g" ./$1/settings.py  

# add database to git ignore
echo db.sqlite3 > .gitignore
