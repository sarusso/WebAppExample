#!/bin/bash

# Do not use a "set -e" here or it will fail on some specific wrong lines in loading the env.

# Load Reyns env
source /env.sh

# Move in the correct dir
cd /opt/web

# Database conf
source db_conf.sh

# Set log levels
export EDJANGO_LOG_LEVEL=DEBUG
export DJANGO_LOG_LEVEL=ERROR

# eDjango Project conf
export EDJANGO_EMAIL_SERVICE="Sendgrid"
export EDJANGO_EMAIL_FROM="WebApp <info@web.app>"
export EDJANGO_EMAIL_APIKEY=""
export EDJANGO_PROJECT_NAME="WebApp"
export EDJANGO_PUBLIC_HTTP_HOST="https://localhost"

# To Python3
export EDJANGO_PYTHON=python3

# Set Python unbuffered or some error messages might not appear in logs
export PYTHONUNBUFFERED=1

# Init
cd /opt/web/eDjango/ && fab makemigrations &>> #/var/log/web/makemigrations.log
cd /opt/web/eDjango/ && fab install:noinput=True #&>> /var/log/web/install.log
cd /opt/web/eDjango/ && fab populate #&>> /var/log/web/populate.log

# Run the development server
exec fab runserver
