#!/bin/bash

DATE=$(date)

echo ""
echo "===================================================="
echo "  Starting WebApp @ $DATE"
echo "===================================================="
echo ""

echo "1) Loading/sourcing env and settings"

# Load Reyns env
source /env.sh

# Move in the correct dir
cd /opt/web

# Database conf
source db_conf.sh

# Set log levels
export EDJANGO_LOG_LEVEL=INFO
export DJANGO_LOG_LEVEL=INFO

# eDjango Project conf
export EDJANGO_EMAIL_SERVICE="Sendgrid"
export EDJANGO_EMAIL_FROM="WebApp <info@web.app>"
export EDJANGO_EMAIL_APIKEY=""
export EDJANGO_PROJECT_NAME="WebApp"
export EDJANGO_PUBLIC_HTTP_HOST="https://localhost"

export DJANGO_SECRET_KEY='#k%899hw@w%1((_&=640-4w#p)fret$m4%#(9x^+it5(h1b6zy'

# To Python3
export EDJANGO_PYTHON=python3

# Set Python unbuffered or some error messages might not appear in logs
export PYTHONUNBUFFERED=1

# Stay quiet
export PYTHONWARNINGS=ignore

# Check if there is something to migrate or populate
echo ""
echo "2) Making migrations..."
cd /opt/web/eDjango/ && fab makemigrations:noinput=True
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
if [[ "x$EXIT_CODE" != "x0" ]] ; then
    echo "This exit code is an error, sleeping 5s and exiting." 
    sleep 5
    exit $?
fi
echo ""

echo "3) Migrating..."
cd /opt/web/eDjango/ && fab migrate:noinput=True
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
if [[ "x$EXIT_CODE" != "x0" ]] ; then
    echo "This exit code is an error, sleeping 5s and exiting." 
    sleep 5
    exit $?
fi
echo ""

echo "4) Populating..."
cd /opt/web/eDjango/ && fab populate
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
if [[ "x$EXIT_CODE" != "x0" ]] ; then
    echo "This exit code is an error, sleeping 5s and exiting." 
    sleep 5
    exit $?
fi
echo ""

# Run the (development) server
echo "5) Now starting the server and logging in /var/log/web/server.log."
exec fab runserver 2>> /var/log/web/server.log



