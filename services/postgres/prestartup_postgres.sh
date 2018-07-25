#!/bin/bash
set -e

echo 'Executing Postgres Prestartup'

#------------------------------
# Postgres-specific (data dir)
#------------------------------

if [ ! -d "/data/postgres/9.3" ]; then
    echo "Data dir does not exist"
    # Setup /data/postgres
    mkdir -p /data/postgres
    chown postgres:postgres  /data/postgres
    chmod 700 /data/postgres

    # Setup /data/postgres/9.3
    mkdir -p /data/postgres/9.3
    chown postgres:postgres /data/postgres/9.3
    chmod 700 /data/postgres/9.3

    # Copy files
    mv /var/lib/postgresql/9.3/main /data/postgres/9.3/

    # Create link
    ln -s /data/postgres/9.3/main /var/lib/postgresql/9.3/main

    # Move conf
    mv /etc/postgresql/9.3/main/pg_hba.conf /data/postgres
    ln -s /data/postgres/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
    chown postgres:postgres /data/postgres/pg_hba.conf

    # Move conf
    mv /etc/postgresql/9.3/main/postgresql.conf /data/postgres
    ln -s /data/postgres/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
    chown postgres:postgres /data/postgres/postgresql.conf

else
    echo "Data dir does exist"
    mv /var/lib/postgresql/9.3/main /var/lib/postgresql/9.3/main_or
    ln -s /data/postgres/9.3/main /var/lib/postgresql/9.3/main

    mv /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf_or
    ln -s /data/postgres/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
    chown postgres:postgres /data/postgres/pg_hba.conf

    mv /etc/postgresql/9.3/main/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf_or
    ln -s /data/postgres/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
    chown postgres:postgres /data/postgres/postgresql.conf

fi

# Check correct permissions. Incorrect permissions might occur when changing base images,
# as the user "postgres" might get mapped to a differend uid / guid.
PERMISSIONS=$(ls -alh /data/postgres/9.3 | grep main | awk '{print $3 ":" $4}')
if [[ "x$PERMISSIONS" == "xpostgres:postgres" ]] ; then
    # Everything ok
    :
else
    # Fix permissions
    chown -R postgres:postgres /data/postgres/9.3 
    chown -R postgres:postgres /data/postgres/pg_hba.conf  
    chown -R postgres:postgres /data/postgres/postgresql.conf
    chown -R postgres:postgres /var/run/postgresql
fi


# Configure Postgres (create user etc.)
if [ ! -f /data/postgres/configured_flag ]; then
    echo 'Configuring as /data/postgres/configured_flag is not found...'   
    echo "Running postgres server in standalone mode for configuring users..."
    # Run Postgres. Use > /dev/null or a file, otherwise Reyns prestarup scripts end detection will fail
    /etc/supervisor/conf.d/run_postgres.sh &> /dev/null &

    # Save PID
    PID=$!

    echo "PID=$PID"

    # Wait for postgres to become ready (should be improved)
    sleep 5

    echo 'Creating user/db...'
    # Execute sql commands for webapp user/db
    su postgres -c "psql -f /create_webapp_user.sql"

    # Set configured flag
    touch /data/postgres/configured_flag

    echo "Stopping Postgres"

    # Stop Postgres
    kill $PID

    echo "Ok, configured"
else
    echo ' Not configuring as /data/postgres/configured_flag is found.'
fi








