#!/bin/bash

# GET PROJECT NAME
# get the project name from the 6th line of the manage.py file
GetStringContainingProjectName="$(sed -n '6p' manage.py)"
StringToArray=($(echo "$GetStringContainingProjectName" | tr ',".' '\n'))
ProjectName=${StringToArray[4]}

# =============================
# ADD BASIC PAGE
# =============================

# CREATE BASE TEMPLATE
cat <<EOT >> templates/base.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    
    <link rel="stylesheet" href="https://bootswatch.com/3/sandstone/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css" />
</head>
<body>
    
   <h1>Our Django App</h1> 
<!-- Fixed masthead -->
    <nav class="navbar navbar-masthead navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/">ECommerce</a>
            </div>
            
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav navbar-right">
                    {% if user.is_authenticated %}
                        <li><a href="{% url 'logout' %}"><i class="fa fa-sign-out"></i> Logout</a></li>
                        <li><a href="{% url 'profile' %}"><i class="fa fa-user"></i> Profile</a></li>
                    {%  else %}
                        <li><a href="{% url 'register' %}"><i class="fa fa-user-plus"></i> Register</a></li>
                        <li><a href="{% url 'login' %}"><i class="fa fa-sign-in"></i> Login</a></li>
                    {% endif %}
                </ul>
            </div>
        </div>
    </nav>

   <hr>
   <div class="container">
           {% block content %}
           
           {% endblock content %}
   <hr>
       <p>Copyright 2018</p>
   </div>
</body>
</html>
EOT


# CREATE HOME PAGE
# create a simple home page with a navbar and h1 tag
touch templates/home.html

cat <<EOT >> templates/home.html
{% extends 'base.html' %}
{% block content %}
<h1>Home Page</h1>
{% endblock content %}
EOT


# BASE VIEWS
# create a views file in the project directory with a view to the home template
touch $ProjectName/views.py

cat <<EOT >> $ProjectName/views.py
from django.shortcuts import render


# View to show the homw page
def get_home(request):
    return render(request, 'home.html')

EOT


# UPDATET THE PROJECT URLS
:> $ProjectName/urls.py

cat <<EOT >> $ProjectName/urls.py
from django.contrib import admin
from django.urls import path, include
from .views import get_home


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', get_home, name="home"),
]

EOT

# =============================
# REGISTER AS A USER
# =============================

# CREATE THE APP AND ADD TO INSTALLED APPS
python manage.py startapp accounts

sed -i "/INSTALLED_APPS/s/\[/\[\n    'accounts',/g" $ProjectName/settings.py


# DIRECTORIES AND FILES
mkdir -p accounts/templates/accounts
touch accounts/templates/accounts/login.html
touch accounts/templates/accounts/register.html
touch accounts/forms.py

# CRISPY FORMS
pip install django-crispy-forms
sed -i "/INSTALLED_APPS/s/\[/\[\n    'crispy_forms',/g" $ProjectName/settings.py
echo "" >> $ProjectName/settings.py 
echo "CRISPY_TEMPLATE_PACK = 'bootstrap4'" >> $ProjectName/settings.py 

# ADD REGISTER VIEW
# Delete all lines in view file
:> accounts/views.py

# add register view and imports
cat <<EOT >> accounts/views.py
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .forms import UserRegisterForm

def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            messages.success(request, 'Your account has been created! You can now Log in')
            return redirect('login')
    else:
        form = UserRegisterForm()
    return render(request, 'accounts/register.html', {'form': form})

EOT


# ADD ACCOUNTS TO PROJECT URLS
sed -i "/path/s/import path, include/import path, include\nfrom accounts import views as accounts_views/g" $ProjectName/urls.py
sed -i "/admin/s/),/),\n    path('register\/', accounts_views.register, name='register'),/g" $ProjectName/urls.py

# CREATE FORMS
# create the user registration form
cat <<EOT >> accounts/forms.py
from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm


class UserRegisterForm(UserCreationForm):
    """Used by the user to sign up with the website"""
    email = forms.EmailField()
    
    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']
EOT


# CREATE HTML PAGES
# create the register page
cat <<EOT >> accounts/templates/accounts/register.html
{% extends "base.html" %}
{% load crispy_forms_tags %}
{% block content %}
    <div class="content-section">
        <form method="POST">
            {% csrf_token %}
            <fieldset class="form-group">
                <legend class="border-bottom mb-4">Join Today</legend>
                {{ form|crispy }}
            </fieldset>
            <div class="form-group">
                <button class="btn btn-outline-info" type="submit">Sign Up</button>
            </div>
        </form>
        <div class="border-top pt-3">
            <small class="text-muted">
                Already have an Account? <a href="#" class="ml-2">Sign In</a>
            </small>
        </div>
    </div>
{% endblock content %}
EOT

# =============================
# CREATE PROFILE PAGE
# =============================

# ADD PROFILE TO PROJECT URLS
sed -i "/admin/s/),/),\n    path('profile\/', accounts_views.profile, name='profile'),/g" $ProjectName/urls.py

# add register view and imports
sed -i "/contrib/s/import messages/import messages\nfrom django.contrib.auth.decorators import login_required/g" accounts/views.py


cat <<EOT >> accounts/views.py
# function to view user profile page, if user is logged in
@login_required
def profile(request):
    return render(request, 'accounts/profile.html')
    
EOT

# create the profile html template
touch accounts/templates/accounts/profile.html

cat <<EOT >> accounts/templates/accounts/profile.html
{% extends "base.html" %}
{% load crispy_forms_tags %}
{% block content %}
    <h1>{{ user.username }}</h1>
{% endblock content %}
EOT

# =============================
# LOGIN AND LOGOUT FUNCTIOANLTY
# =============================

# ADD LOGIN AND LOGOUT TO PROJECT URLS
# line after 'import admin' add from django.contrib.auth import views as auth_views
sed -i "/import admin/s/admin/admin\nfrom django.contrib.auth import views as auth_views/g" $ProjectName/urls.py
# add url patterns for login and logout
sed -i "/admin/s/),/),\n    path('login\/', auth_views.LoginView.as_view(template_name='accounts\/login.html'), name='login'),/g" $ProjectName/urls.py
sed -i "/admin/s/),/),\n    path('logout\/', auth_views.LogoutView.as_view(template_name='accounts\/logout.html'), name='logout'),/g" $ProjectName/urls.py



# ADD LOGIN FORM
touch accounts/templates/accounts/login.html

cat <<EOT >> accounts/templates/accounts/login.html
{% extends "base.html" %}
{% load crispy_forms_tags %}
{% block content %}
    <div class="content-section">
        <form method="POST">
            {% csrf_token %}
            <fieldset class="form-group">
                <legend class="border-bottom mb-4">Log in</legend>
                {{ form|crispy }}
            </fieldset>
            <div class="form-group">
                <button class="btn btn-outline-info" type="submit">Login</button>
            </div>
        </form>
        <div class="border-top pt-3">
            <small class="text-muted">
                Need an Account? <a href="{% url 'register' %}" class="ml-2">Sign Up Now</a>
            </small>
        </div>
    </div>
{% endblock content %}
EOT


# CHOOSE REDIRECT LOCATION ONCE LOGGED IN
echo "" >> $ProjectName/settings.py 
echo "LOGIN_REDIRECT_URL = 'home'" >> $ProjectName/settings.py 

# UPDATE THE VIEW FILE


# ADD LOGOUT FORM
touch accounts/templates/accounnts/logout.html

cat <<EOT >> accounts/templates/accounts/logout.html
{% extends "base.html" %}
{% block content %}
    <h2>You have been logged out</h2>
    <div class="border-top pt-3">
        <small class="text-muted">
            <a href="{% url 'login' %}">Log In Again</a>
        </small>
    </div>
{% endblock content %}
EOT
