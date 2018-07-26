#!/bin/bash

# Load Reyns env
source /env.sh

# Source DB conf
source /opt/webapp/db_conf.sh

# Add extra libraries to Pythonpath
#export PYTHONPATH=$PYTHONPATH:/opt/your_library

# Set custom log Levels
export DJANGO_LOG_LEVEL=INFO
export EDJANGO_LOG_LEVEL=DEBUG

# To Python3
export EDJANGO_PYTHON=python3

# Run the tests
cd /opt/webapp/eDjango/ && fab install && fab test
