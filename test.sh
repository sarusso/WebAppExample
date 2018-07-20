#!/bin/bash

# Get current folder name
FOLDER=${PWD##*/}

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

if [[ $# -eq 0 ]] ; then
    reyens/shell webapp,command="cd /opt/webapp/eDjango && fab install && fab test"
else
    echo "No args accepted for this script"
    exit 1
fi

