#!/bin/bash

# Get current folder name
FOLDER=${PWD##*/}

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

if [[ $# -eq 0 ]] ; then
    Reyns/reyns clean:all,force=True && Reyns/reyns run:all 
else
    Reyns/reyns rerun:$@
fi

