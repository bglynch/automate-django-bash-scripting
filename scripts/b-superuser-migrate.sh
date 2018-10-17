#!/bin/bash
# migrate to create database
python3 manage.py migrate

# create superuser
python3 manage.py createsuperuser