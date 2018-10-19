# Bash Scripting for Django App built in Cloud9

This repo is a collection of scripts that can be used to automate processes in django

## Installation 
`$ svn export https://github.com/bglynch/automate-django-bash-scripting/trunk/scripts`  

This imports a directory name 'scripts' which holds the script files

## Usage
**scripts/a-up-and-running.sh**  
- installs [django 2](https://docs.djangoproject.com/en/2.0/)
- creates project
- adds run and PROJECTNAME to bash_alias
- adds user to ALLOWED_HOSTS in settings.py
- adds local database to .gitignore

```bash
$ bash scripts/a-up-and-running.sh <projectname>
```

Note: <projectname> must adhere to django project naming conventions - ie no spaces  

**Test it worked**  
First close and then reopen the terminal  
```bash
$ run
```  
Open new tab on port 8080 and should see the following screen  
<img src="https://raw.githubusercontent.com/bglynch/automate-django-bash-scripting/master/images/screengrab-01.png" height="500px"/>

---

**scripts/b-superuser-migrate.sh**  
- initial migrate
- creates superuser

```bash
$ bash scripts/b-superuser-migrate.sh
```  
**Test it worked**  
Open the app and add /admin to the end of the URL  
Login using the username and password create when adding superuser  
Should see the following screen  
<img src="https://raw.githubusercontent.com/bglynch/automate-django-bash-scripting/master/images/screengrab-02.png" height="500px"/>  

---

**scripts/c-static-files.sh**  
- create static directory
- populate directory with ./static/css/style.css
- populate directory with ./static/js/custom.js
- populate directory with ./static/images
- creates templates directory
- populate directory with ./templates/base.html
- add path to ./templates to settings.py

```bash
$ bash scripts/c-static-files.sh
``` 

---

**scripts/d-media.sh**  
- create media directory
- install [Pillow](https://github.com/python-pillow/Pillow)
- add media context processor to settings.py
- add MEDIA_URL and MEDIA_ROOT to base of settings.py

```bash
$ bash scripts/d-media.sh
``` 
