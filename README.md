# Example Web App using eDjango and Reyns 


An example about how to build a Web App with eDjango and Reyns in minutes.


## Quickstart


Requirements:
    
    Bash, Python, Git and Docker

Setup

	$ reyns/setup

Build

    $ reyns/build all


Run

	$ reyns/run all

Play

	Open http://localhost (or https://localhost)
    Login with testuser@web.app / testpass

Clean

	$ reyns/clean all



## More commands


Update cycle:

    $ git pull
    $ reyns/setup
    $ reyns/build all
    $ reyns clean/all
    $ reyns run/all

Daemon (monitors for git changes every minute and applies the update cycle)

    $ reyns/daemon


## Development

Django development server is running on port 8080 of the "haykle" service.

To enable live code changes, run in development mode (which mounts the code from services/haykle/code as as a volume inside the haykle service container):

    $ reyns/run all,conf=devel


To run unit tests in a running "webapp" service:

    $ ./unit_test.sh [apis|common|etc.]


To run the integration tests (which builds and run the entire project): 

	$ ./integration_test.sh


When you edit the ORM model, you need to rerun the cloud to migrate the DB:

    $ reyns/rerun cloud

You can also enter the cloud service container and manually migrate:

    $ reyns/shell cloud
    $ source /env.sh
    $ source /opt/haykle/db_conf.sh
    $ cd /opt/haykle/eDjango
    $ fab makemigrations
    $ fab migrate   



# Database operations

To dump & load data, for example to update the Postgres database version:

    $ reyns/shell web
    $ source /opt/web/db_conf.sh
    $ cd /opt/web/eDjango
    $ python manage.py dumpdata --indent=4 > /data/database.json
    $ python manage.py dumpdata web_app --indent=4 > /data/database.json # Only web_app
    $ python manage.py loaddata /data/database.json










