#!/bin/bash
# install django 2.0
sudo pip3 install django==2.0

# create django project - same name as to name of the workspace
django-admin startproject $C9_PROJECT .

# updated tohe bash_aliases to type 'run' to run the application
echo -e \alias run=\"python3 ~/workspace/manage.py runserver '\u0024'IP:'\u0024'C9_PORT\" >> ~/.bash_aliases

# add allowed host in settings.py
sed -i "/ALLOWED_HOSTS/s/\[\]/\['$C9_HOSTNAME'\]/g" ./$C9_PROJECT/settings.py  

# start github and do initial commit
git init
git status
echo db.sqlite3 > .gitignore
git add .
git commit -m "initial commit"