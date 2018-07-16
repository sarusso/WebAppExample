#!/bin/bash
set -e

if [[ "x$(mount | grep /opt/webapp/webapp_app/migrations)" == "x" ]] ; then

    # If the migrations folder is not mounted, use the /data directory via links to use Reyns data persistency

    if [ -d "/data/webapp_app_migrations" ] ; then

        # If persisted migrations exist, use them
        mv /opt/webapp/webapp_app/migrations /opt/webapp/webapp_app/migrations_pre
        ln -s /data/webapp_app_migrations /opt/webapp/webapp_app/migrations

    else

        # Otherwise, copy over the vanilla (initilaized) ones and use them
        cp -a /opt/webapp/webapp_app/migrations_vanilla /data/webapp_app_migrations
        mv /opt/webapp/webapp_app/migrations /tmp/migrations_pre
        ln -s /data/webapp_app_migrations /opt/webapp/webapp_app/migrations
        mv /tmp/migrations_pre /opt/webapp/webapp_app/migrations_pre

    fi

else

    # If the migrations folder is mounted, use it directly

    if [ -f "/opt/webapp/webapp_app/migrations/__init__.py" ] ; then

      # If migrations were already initialized, do nothing
      :

    else

      # Otherwise, initialize them
      cp -a /opt/webapp/webapp_app/migrations_vanilla/* /opt/webapp/webapp_app/migrations/

   fi

fi
