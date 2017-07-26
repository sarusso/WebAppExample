#!/bin/bash

# Load Reyns env
source /env.sh

# Move in the correct dir
cd /opt/eDjango_sample_app/eDjango/

# Sqlite conf (uncomment and comment the Postgres one to use it)
#export DJANGO_DB_NAME="/data/eDjango.sqlite3"

# Postgres conf
export DJANGO_DB_ENGINE="django.db.backends.postgresql_psycopg2"
export DJANGO_DB_NAME="edjango"
export DJANGO_DB_USER="edjango"
export DJANGO_DB_PASSWORD="8623rfc61"
export DJANGO_DB_HOST="postgres-one"
export DJANGO_DB_PORT=5432

# Make migrations for new changes, install (applies them) and populate
# We run the populate evrytime since if the base data is there it will
# anyway not be re-written

fab makemigrations &>> /var/log/eDjango_makemigrations.log
fab install &>> /var/log/eDjango_install.log
fab populate &>> /var/log/eDjango_populate.log

# Run the development server
exec fab runserver:noreload=True
