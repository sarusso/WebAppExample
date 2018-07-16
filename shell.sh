#!/bin/bash

# Get current folder name
FOLDER=${PWD##*/}

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

if [[ $# -eq 0 ]] ; then
    echo "You must provide as first argument the service to open a shell on"
    echo ""
    exit 1
else
    Reyns/reyns shell:$@
fi

