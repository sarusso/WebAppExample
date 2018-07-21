# eDjango-Reyns Example WebApp


An example about how to build a Web App with eDjango and Reyns in minutes.


Quickstart
----------

Requirements:
    
    Bash, Python, Git and Docker

Setup

	# reyns/setup

Build

    # reyns/build all


Run

	# reyns/run all

Play

	Open http://localhost (or https://localhost)
    Login with testuser@web.app / testpass

Clean

	# reyns/clean all



More commands
----------

Develop (use instead of the "run all", codebase changes becomes live)

    # reyns/run all,conf=devel

Test

	# /test.sh

Update cycle:

    git pull
    reyns/setup
    reyns/build all
    reyns clean/all
    reyns run/all

Daemon (moniotrs for git changes every minute and applies the update clyce)

    reyns/daemon



