#!/bin/bash

# Get current folder name
FOLDER=${PWD##*/}

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

echo ""

if hash git 2>/dev/null; then
    echo "[OK] Git found"
else
    echo "[ERROR] Git is missing" 
    exit 1
fi

if hash docker 2>/dev/null; then
    echo "[OK] Docker found"
else
    echo "[ERROR] Docker is missing" 
    exit 1
fi


echo ""

REYNS_COMMIT_HASH=717db5886c64dde870eb20cab0b4f5d08c3103ac

if [ ! -d Reyns ]; then
    echo "Installing Reyns..."
    git clone https://github.com/sarusso/Reyns.git
    cd Reyns
    git checkout $REYNS_COMMIT_HASH
    cd ..
else
    echo "Checking Reyns version..."
    cd Reyns
    commit=$(git log -n1 | head -n1 | cut -d ' ' -f2)
    if [ "x$commit" != "x$REYNS_COMMIT_HASH" ]; then
        echo "This codebase version requires a different Reyns version. Updating Reyns..."
        git pull
        git checkout $REYNS_COMMIT_HASH
        echo ""
        echo "Done."
    else
        echo "Reyns is already the required version."
    fi
    cd ..
fi


echo ""
echo "This script will setup a DEVELOPMENT configuration. This include"
echo "self-signed certificates and local Postgres database connection."
echo ""

# TODO: Ask (twice) only if not found

read -p "Are you sure? [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo "Working..."

    # Use dev certificates
    if [ ! -d services/proxy/certificates ]; then
        echo "Using dev certificates."
        cp -a services/proxy/certificates-dev services/proxy/certificates
    else
        echo "Not using dev certificates as certificates are already present."
    fi

    # Use dev (local) Postgres database
    if [ ! -f services/webapp/db_conf.sh ]; then
        echo "Using dev database settings."
        cp services/webapp/db_conf-dev.sh  services/webapp/db_conf.sh
    else
        echo "Not using dev database settings as settings are already present."
    fi

    echo "All done."
fi
echo ""




echo ""
echo "Done"




