#!/bin/bash

# Check we are in the right place
if [ ! -d ./services ]; then
    echo "You must run this script from the project's root folder."
    exit 1
fi

# Support vars
JUSTSTARTED=true
RECURSIVE=$1
REYNS_COMMIT=717db5886c64dde870eb20cab0b4f5d08c3103ac

# Log that we started the daemon
echo "Starting daemon..."

# Run setup
./setup.sh

# Start daemon
echo "Started daemon @ $(date)"

# Check if this is the first run or a recursive run
if [[ "x$(echo $RECURSIVE | grep recursive | cut -d'=' -f2)" == "xtrue" ]] ; then
    echo "Recursive run, not starting the services."
else
    echo "First run, starting the services..."

    # Check on which branch we are
    BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>&1)
    if [ ! $? -eq 0 ]; then
        echo $BRANCH
        echo "Error: could not obtain local branch at startup time. See output above."
        echo "Current time: $(date)"
    fi

    # Build "just in case", in particular for first run ever
    echo "Now building..."
    .Reyns/reyns build:all

    if [[ "x$BRANCH" == "xmaster" ]] ; then
        RUN_CMD=".Reyns/reyns run:all,conf=production"
    else
        RUN_CMD=".Reyns/reyns run:all"
    fi

    # Clean before running
    .Reyns/reyns clean:all,force=True

    # Run
    $RUN_CMD
    if [ ! $? -eq 0 ]; then
        echo "Error: reyns run failed at startup time. See output above."
        echo "Current time: $(date)"
        echo "Current branch: $BRANCH"
        echo ""
        echo "I will now mark the forthcoming update process as \"unfinished\", which will"
        echo "trigger a new build and re-run as soon as the update check loop will start."
        touch .update_in_progress_flag
    fi
fi


# Start update loop
while true
do

    # Get date TODO: directly use $(date) in the code
    DATE=$(date)

    # Sleep before next iteration (if not just started)
    if [ "$JUSTSTARTED" = true ]; then

        JUSTSTARTED=false

        # Log that we started the update loop
        echo ""
        echo "Started updated check loop @ $DATE"

    else
        sleep 60
    fi

    # Check on which branch we are
    BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>&1)
    if [ ! $? -eq 0 ]; then
        echo $BRANCH
        echo "Error: could not obtain local branch. See output above."
        echo "Current time: $DATE"
        continue
    fi

    # Update from remote
    GIT_REMOTE=$(git remote -v update 2>&1)

    if [ ! $? -eq 0 ]; then
        echo $GIT_REMOTE
        echo "Error: could not check remote status. See output above."
        echo "Current time: $DATE"
        echo "Current branch: $BRANCH"
        continue
    fi

    # Check log diff within local and origin (remote)
    GIT_LOG=$(git log $BRANCH..origin/$BRANCH --oneline)

    # If an update was started and not completed, just force it
    if [ -f .update_in_progress_flag ]; then
        GIT_LOG="FORCED"
        echo "Detected unfinished update process, resuming it..."
    fi


    if [[ "x$GIT_LOG" == "x" ]] ; then

        # Remote has not changed. Do nothing
        :

    else

        # Remote has changed. Start update process
        echo "Remote changes detected"
        echo "Current time: $DATE"
        echo "Current branch: $BRANCH"
        echo "Starting the update process..."

        # Set update in progress flag
        touch .update_in_progress_flag

        # Pull changes from origin (remote)
        GIT_PULL=$(git pull 2>&1)

        # If pull failed abort
        if [ ! $? -eq 0 ]; then
            echo $GIT_PULL
            echo "Error: pull failed. See output above."
            continue
        fi

        # Check if we have to update Reyns
	    echo "Checking Reyns version..."
	    cd Reyns
	    THIS_COMMIT=$(git log -n1 | head -n1 | cut -d ' ' -f2)
	    if [ "x$THIS_COMMIT" != "x$REYNS_COMMIT" ]; then
	        echo "This codebase version requires a different Reyns version. Updating Reyns..."
	        git pull
	        git checkout $REYNS_COMMIT
	        echo ""
	        echo "Done. In case of error try rebuilding everything without cache (metabox/build all,cache=False)"
	    else
	        echo "Reyns is already the required version."
	    fi
	    cd ..

        # Re-build
        echo "Now building..."
        .Reyns/reyns build:all

        # If the above failed, try with no cached
        if [ ! $? -eq 0 ]; then
            echo "Error in rebuilding services, now trying without cache..."
            .Reyns/reyns build:all,cache=False
            if [ ! $? -eq 0 ]; then
                echo "Error: failed rebuilding services even without cache."
                continue
            fi
        fi

        # All good if we are here. Restart everything
        .Reyns/reyns clean:all,force=True

        if [[ "x$BRANCH" == "xmaster" ]] ; then
            RUN_CMD=".Reyns/reyns run:all,conf=production"
        else
            RUN_CMD=".Reyns/reyns run:all"
        fi

        $RUN_CMD
        if [ ! $? -eq 0 ]; then
            echo "Error: reyns run failed. See output above."
            continue
        fi

        # Remove update in progress flag
        rm .update_in_progress_flag

        # Load new daemon
        echo "Now loading new daemon..."
        exec ./daemon.sh recursive=true
    fi

done
