#!/bin/bash

# This script is run by Supervisor to start PostgreSQL 9.3 in foreground mode
# https://github.com/Karumi/docker-sentry/blob/master/conf/run_postgres.sh

# Check if Firewall is set up. If not, keep waiting.
#while true
#do
#    echo "Checking Firewall setup..."    
#    if [  -f /run/fw_ready ]; then
#        echo "Ok, Firewall is set up."
#        break
#    fi
#    sleep 5
#done

if [[ "x$DISABLE_FIREWALL" == "xTrue" ]] ; then
    echo "Not enabling firewall"
else
    # Setup firewall (we can do it here as we are root)
    sudo /setup_firewall.sh
fi

if [ -d /var/run/postgresql ]; then
    chmod 2775 /var/run/postgresql
else
    install -d -m 2775 -o postgres -g postgres /var/run/postgresql
fi

exec su reyns -c "/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf"