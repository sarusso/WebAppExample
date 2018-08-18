#!/bin/bash

#./unit_test.sh common to run test/common.py tests

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

# Check that we have a running instance where to run tests
REYNS_PS_GREP_INSTANCE=$(reyns/ps | grep web)
if [[ "x$REYNS_PS_GREP_INSTANCE" == "x" ]] ; then
    echo ""
    echo "Error: web service is not running, cannot run tests."
    echo ""
    exit 1
fi

# Do we have to run a specific test?
TEST=""
if [[ "x$1" != "x" ]] ; then
    TEST=".test_$1"
    #/opt/web/run_unit_test.sh edjango.web_app.tests.test_apis
fi 

# Run tests
reyns/ssh web,command="/opt/web/run_unit_test.sh edjango.web_app.tests$TEST"
TESTS_EXIT_CODE=$?

if [[ "x$TESTS_EXIT_CODE" == "x0" ]] ; then
    echo "Tests passed, cleaning and giving green light (exit code 0)"
    exit 0
else
    echo "Tests *not* passed, cleaning and giving red light (exit code $TESTS_EXIT_CODE)"
    exit $TESTS_EXIT_CODE 
fi

