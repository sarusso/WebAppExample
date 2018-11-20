# Example Web App using eDjango and Reyns 


An example about how to build a Web App with eDjango and Reyns in minutes. Code will be built as Docker images and run as Docker containers.


## Quickstart


Requirements:
    
    Bash, Python, Git and Docker

Setup

	$ reyns/setup

Build

    $ reyns/build all


Run

	$ reyns/run all
	
Status 	

    $ reyns/status

Play

	Open http://localhost (or https://localhost)
    Login with user "testuser@web.app" and password "testpass"
    
Admin

	Open http://localhost/admin (or https://localhost/admin)
    Login with user "admin" and password "admin"

Stop (clean)

	$ reyns/clean all



## Development mode

Code of the Django Web App is stored in "services/web/code" and is injected into the image for the "web" service at build time. To enable live code changes, run in development mode which creates a bridge between the code in the container and the "services/web/code" folder:

    $ reyns/run all,conf=devel

Django development server is running on port 8080 of the "web" service and consequelntially reachable on https://localhost. If you need to test with multiple instances or projects, just comment out the proxy service in the conf file (default.conf or devel.conf). Advanced tip: if you are on Linux, you can also add a "publish_ports=False" to the proxy service and connect directly to the container IP address. You can also refer to Reyns documentation for advanced usage: https://github.com/sarusso/Reyns.


## Settings

The most important settings are in services/web/run_web.sh and in services/web/db_conf.sh, but you can also add custom settings in services/web/code/settings.py and some parameters in default.conf (or devel.conf), like the DJANGO_DEBUG switch.

In particualr, in run_web.sh, you might want to enable support for sending email (i.e. for the built-in password recovery and login link feature) by editing the following lines:

    # eDjango Project conf
    export EDJANGO_EMAIL_SERVICE="Sendgrid"
    export EDJANGO_EMAIL_FROM="WebApp <info@web.app>"
    export EDJANGO_EMAIL_APIKEY=""
    export EDJANGO_PROJECT_NAME="WebApp"
    export EDJANGO_PUBLIC_HTTP_HOST="https://localhost"
    
And most importantly, you might want to change the secret key (just change a few letters or numbers, keep the same length):

    export DJANGO_SECRET_KEY='#k%899hw@w%1((_&=640-4w#p)fret$m4%#(9x^+it5(h1b6zy'



## Logs and Debugging

You can view the web service *startup* log by using the following command:

    $ ./view_web_startup_log.sh

You can view the web service *server* log by using the following command:

    $ ./view_web_server_log.sh

You can also change django and edjango log levels in services/web/run_web.sh (the EDJANGO_LOG_LEVEL is the loglevel of your Web App, while the DJANGO_LOG_LEVEL is the Django framweork log level). Changing parameters here requires a rebuild.


## Email 

You can view the web service *startup* log by using the following command:

    $ ./view_web_startup_log.sh

You can view the web service *server* log by using the following command:

    $ ./view_web_server_log.sh


## Database operations


### Migrations
When you edit the ORM model (i.e. in models.py), you need to rerun the web service to migrate the DB:

    $ reyns/rerun cloud

You can also enter the cloud service container and manually migrate:

    $ reyns/shell cloud
    $ source /env.sh
    $ source /opt/haykle/db_conf.sh
    $ cd /opt/haykle/eDjango
    $ fab makemigrations
    $ fab migrate   


### Dump & load
To dump & load data, for example to update the Postgres database version:

    $ reyns/shell web
    $ source /opt/web/db_conf.sh
    $ cd /opt/web/eDjango
    
Dump entire database (including Django internals, cannot recover from this)

    $ python manage.py dumpdata > /data/database.json # Entire databas

Dump entire database (excluding Django internals, can recover from this) 

    $ python manage.py dumpdata --exclude auth.permission --exclude contenttypes > db.json

Dump the web_app only (potential problems with keys)

    $ python manage.py dumpdata web_app > /data/database.json # Only web_app

Dump the web_app only with natural keys  (potential problems with keys)

    $ python manage.py dumpdata web_app --natural-primary --natural-foreign > /data/database.json # Only web_app
    
Add a "--indent=4" if you need to dive manually in the dump.

    
Load a data dump

    $ python manage.py loaddata /data/dump.json


## Update cycle and daemon mode



Update cycle:

    $ git pull
    $ reyns/setup
    $ reyns/build all
    $ reyns/clean all
    $ reyns/run all

Daemon (monitors for new commits in git every minute and applies the update cycle if any detected)

    reyns/daemon


## Testing

There are basic unit and integration tests that you can run and extend.

### Unit tests

To run unit tests in a running "web" service:

    $ ./unit_test.sh [apis|common|etc.]

### Integration tests

To run the integration tests (which builds and run the entire project): 

	$ ./integration_test.sh








