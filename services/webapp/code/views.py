# Django imports
from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth import update_session_auth_hash

# eDjango imports
from edjango.common.utils import send_email
from edjango.common.views import private_view, public_view
from edjango.common.views import login_view_template, logout_view_template, register_view_template
from edjango.common.exceptions import ErrorMessage

# WebApp imports
from .models import Profile
from .common import timezonize

# Setup logging
import logging
logger = logging.getLogger(__name__)


#=========================
#  User login view
#=========================

@public_view
def user_login(request, template='login.html'):
    return login_view_template(request, redirect='/')


#=========================
#  User logout view
#=========================

@private_view
def user_logout(request):
    return logout_view_template(request, redirect='/')


#=========================
#  Register view
#=========================

@public_view
def register(request, template='register.html'):

    # Define the callback that we will use on success to create the profile
    def create_profile(user):
        logger.debug('Creating user profile for user "{}"'.format(user.email))
        try:
            Profile.objects.get(user=request.user)
        except Profile.DoesNotExist:
            Profile.objects.create(user=request.user)

    return register_view_template(request, invitation_code='WebApp', redirect='/', callback=create_profile)


#=========================
#  Main view
#=========================

@public_view
def main(request, template='main.html'):

    import sys

    data={}
    data['user'] = request.user
    data['title'] = None #"Home"
    data['version'] = sys.version_info
    
    return data


#=========================
#  Account view
#=========================

@private_view
def account(request, template='account.html'):

    data={}
    data['user']  = request.user
    data['title'] = "Account"
    data['text']  = "Account"
    
    # Set profile (not really necessary..)
    data['profile'] = request.user.profile

    # Set values from POST and GET
    edit = request.POST.get('edit', None)
    if not edit:
        edit = request.GET.get('edit', None)
        data['edit'] = edit
    value = request.POST.get('value', None)

    # Fix None
    if value and value.upper() == 'NONE':
        value = None
    if edit and edit.upper() == 'NONE':
        edit = None

    if edit and value:
        try:
            logger.info('Setting "{}" to "{}"'.format(edit,value))
            
            # Timezone
            if edit=='timezone' and value:
                # Validate
                timezonize(value)
                request.user.profile.timezone = value
                request.user.profile.save()

            # Email
            elif edit=='email' and value:
                request.user.email=value
                request.user.save()

            # Password
            elif edit=='password' and value:
                request.user.set_password(value)
                request.user.save()
                #user = User.objects.get(username=username)
                update_session_auth_hash(request, request.user)    
                #login(request, user)

            # API key
            elif edit=='apikey' and value:
                request.user.profile.apikey=value
                request.user.profile.save()

            # Plan
            elif edit=='plan' and value:
                request.user.profile.plan=value
                request.user.profile.save()
            
            # Unknown property
            elif edit and value:
                raise ErrorMessage('The property "{}" does not exists or the value "{}" is not valid.'.format(edit, value))
           
        except Exception:
            raise ErrorMessage('The property "{}" does not exists or the value "{}" is not valid.'.format(edit, value))

    return data
    

