# Bash Scripting for Django App built in Cloud9

This repo is a collection of scripts that can be used to automate processes in django

## Installation 
`$ svn export https://github.com/bglynch/automate-django-bash-scripting/trunk/scripts`  

This imports a directory name 'scripts' which holds the script files

## Usage
**scripts/a-up-and-running.sh**  
- installs django 2
- creates project
- adds run and PROJECTNAME to bash_alias
- adds user to ALLOWED_HOSTS in settings.py
- adds local database to .gitignore

```bash
$ bash scripts/a-up-and-running.sh <projectname>
```

Note: <projectname> must adhere to django project naming conventions - ie no spaces  

<img src="https://github.com/bglynch/automate-django-bash-scripting/tree/master/images/screengrab-01.png" alt="drawing" height="100px"/>