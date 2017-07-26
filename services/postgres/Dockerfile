FROM reyns/reyns-base-ubuntu14.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

#------------------------
# Install Postgres 9.3
#------------------------

RUN apt-get update # nocache 20170704
RUN apt-get install -y postgresql-9.3

# Copy conf 
RUN mv /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf.or
COPY pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
COPY postgresql.conf /etc/postgresql/9.3/main/postgresql.conf

# Create pythings user/db script
COPY create_eDjango_user.sql /
RUN chown postgres:postgres /create_eDjango_user.sql

# Prestartup
COPY prestartup_postgres.sh /prestartup/

#------------------------
# Postgres on Supervisor
#------------------------

COPY run_postgres.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_postgres.sh
COPY supervisord_postgres.conf /etc/supervisor/conf.d/



