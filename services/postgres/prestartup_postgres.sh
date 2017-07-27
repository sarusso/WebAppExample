#!/bin/bash

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


if [ ! -f /data/postgres/configured_flag ]; then
    echo 'Configuring as /data/postgres/configured_flag is not found...'   
    echo "Running postgres server in standalone mode for configuring users..."
    # Run Postgres
    /etc/supervisor/conf.d/run_postgres.sh &

    # Save PID
    PID=$!

    echo "PID=$PID"

    # Wait for postgres to become ready
    # Should be improved
    sleep 5

    echo 'Creating eDjango user/db...'
    su postgres -c "psql -f /create_eDjango_user.sql"

    # Set configured flag
    touch /data/postgres/configured_flag

    echo "Stopping Postgres"

    # Stop Postgres
    kill $PID

    echo "Ok, configured"
else
    echo ' Not configuring as /data/postgres/configured_flag is found.'
fi

