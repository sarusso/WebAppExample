#!/bin/bash

# Check that we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

# Check that there are no other running instances
REYNS_PS_GREP_INSTANCE=$(reyns/ps | grep instance)
if [[ "x$REYNS_PS_GREP_INSTANCE" == "x" ]] ; then
    :
else
    echo ""
    echo "Error: some services already running for this project, cannot start test instances."
    echo ""
    exit 1
fi

# Build, clean if running, and run test instances
reyns/build all
reyns/clean all,conf=test,force=True,strict=True
reyns/run all,conf=test

# Run tests
reyns/ssh webapp,command="/opt/webapp/run_integration_test.sh"

TESTS_EXIT_CODE=$?

if [[ "x$TESTS_EXIT_CODE" == "x0" ]] ; then
    echo "Tests passed, cleaning and giving green light (exit code 0)"
    reyns/clean all,conf=test,force=True,strict=True
    exit 0
else
    echo "Tests *not* passed, cleaning and giving red light (exit code $TESTS_EXIT_CODE)"
    reyns/clean all,conf=test,force=True,strict=True
    exit $TESTS_EXIT_CODE 
fi

