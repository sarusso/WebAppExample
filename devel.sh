#!/bin/bash

# Get current folder name
FOLDER=${PWD##*/}

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

if [[ $# -eq 0 ]] ; then
    Reyns/reyns run:all, conf=devel
else
    Reyns/reyns run:$@,conf=devel
fi

