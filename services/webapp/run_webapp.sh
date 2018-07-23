#!/bin/bash

# Do not use a "set -e" here or it will fail on some specific wrong lines in loading the env.

# Load Reyns env
source /env.sh

# Move in the correct dir
cd /opt/webapp

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

# Init
cd /opt/webapp/eDjango/ && fab makemigrations &>> /var/log/webapp/makemigrations.log
cd /opt/webapp/eDjango/ && fab install:noinput=True &>> /var/log/webapp/install.log
cd /opt/webapp/eDjango/ && fab populate &>> /var/log/webapp/populate.log

# Run the development server
exec fab runserver
