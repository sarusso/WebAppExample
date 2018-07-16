# Nothing here..

if [ -d /shared ]; then

    # Check if no one initialized the shared folder for metauser
    if [[ -d /shared/reyns || -L /shared/metauser  ]]; then
        :
    else
        mkdir /shared/reyns
        chown reyns:reyns /shared/reyns
    fi

    # Check if there is no dir with data in shared di
    if [ ! -e /shared/reyns/etc_apache2_sites_enabled ]; then
        cp -a /etc/apache2/sites-enabled /shared/reyns/etc_apache2_sites_enabled
        chown reyns:reyns /shared/reyns/etc_apache2_sites_enabled
    fi
    
    # Check if there is no link to conf in shared dir
    if [ -d /etc/apache2/sites-enabled ]; then
        mv /etc/apache2/sites-enabled /etc/apache2/sites-enabled_or
        ln -s /shared/reyns/etc_apache2_sites_enabled /etc/apache2/sites-enabled
    fi


else
    # Do nothing
    :

fi

