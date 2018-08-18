#!/bin/bash

# Use dev certificates
if [ ! -d services/proxy/certificates ]; then
    echo "Using dev certificates."
    cp -a services/proxy/certificates-dev services/proxy/certificates
else
    echo "Not using dev certificates as certificates are already present."
fi

# Use dev (local) Postgres database
if [ ! -f services/web/db_conf.sh ]; then
    echo "Using dev database settings."
    cp services/web/db_conf-dev.sh  services/web/db_conf.sh
else
    echo "Not using dev database settings as settings are already present."
fi
