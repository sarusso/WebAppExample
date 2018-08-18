#!/bin/bash
set -e

if [[ "x$(mount | grep /opt/web/web_app/migrations)" == "x" ]] ; then

    # If the migrations folder is not mounted, use the /data directory via links to use Reyns data persistency

    if [ -d "/data/web_app_migrations" ] ; then

        # If persisted migrations exist, use them
        mv /opt/web/web_app/migrations /opt/web/web_app/migrations_pre
        ln -s /data/web_app_migrations /opt/web/web_app/migrations

    else

        # Otherwise, copy over the vanilla (initilaized) ones and use them
        cp -a /opt/web/web_app/migrations_vanilla /data/web_app_migrations
        mv /opt/web/web_app/migrations /tmp/migrations_pre
        ln -s /data/web_app_migrations /opt/web/web_app/migrations
        mv /tmp/migrations_pre /opt/web/web_app/migrations_pre

    fi

else

    # If the migrations folder is mounted, use it directly

    if [ -f "/opt/web/web_app/migrations/__init__.py" ] ; then

      # If migrations were already initialized, do nothing
      :

    else

      # Otherwise, initialize them
      cp -a /opt/web/web_app/migrations_vanilla/* /opt/web/web_app/migrations/

   fi

fi
