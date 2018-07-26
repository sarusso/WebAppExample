#!/bin/bash

# Load Reyns env
source /env.sh

# Add extra libraries to Pythonpath
#export PYTHONPATH=$PYTHONPATH:/opt/your_library

# Set custom log Levels
export DJANGO_LOG_LEVEL=INFO
export EDJANGO_LOG_LEVEL=DEBUG

# To Python3
export EDJANGO_PYTHON=python3

# Since no database is configured here, eDjango will default to SQLite for the install phase
# (which is required to generate migrations used by the test phase), and we will remove the
# default database afterwards. Also, we check if there is a default database left over from 
# a previous run and in case we warn and abort the tests as might compromise the migrations.

if [ -f /opt/webapp/eDjango/db-edjango.sqlite3 ]; then
    echo "Found existent SQLite database file in /opt/webapp/eDjango/db-edjango.sqlite: please rerun the service or remove it manually"
    exit 1
fi

# Run the tests.
cd /opt/webapp/eDjango/ && fab install && fab test $@
rm /opt/webapp/eDjango/db-edjango.sqlite3
