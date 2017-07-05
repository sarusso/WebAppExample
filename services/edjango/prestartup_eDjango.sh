#!/bin/bash

# Make migrations persistent
mv /opt/eDjango_sample_app/sample_app/migrations /opt/eDjango_sample_app/sample_app/migrations_vanilla

if [ -d "/data/pythings_app_migrations" ] ; then
  # If migrations exist, use them
  ln -s /data/sample_app_migrations /opt/eDjango_sample_app/sample_app/migrations
else
  # If they do not exist, use the vanilla ones
  mv /opt/eDjango_sample_app/sample_app/migrations_vanilla /data/sample_app_migrations
  ln -s /data/sample_app_migrations /opt/eDjango_sample_app/sample_app/migrations
fi

