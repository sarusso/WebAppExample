FROM reyns/reyns-base-ubuntu18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

# Always start with an apt-get update when extending Reyns images,
# otherwise apt repositories might get outdated (404 not found)
# and building without cache does not re-build Reyns services.
RUN apt-get update

#------------------------
# Install Postgres 10
#------------------------

# Add repo
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

RUN apt-get update
RUN apt-get install -y postgresql-10

# Copy conf 
RUN mv /etc/postgresql/10/main/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf.or
COPY pg_hba.conf /etc/postgresql/10/main/pg_hba.conf
COPY postgresql.conf /etc/postgresql/10/main/postgresql.conf

# Chown conf
RUN chown -R postgres:postgres /etc/postgresql

# Create user/db script
COPY create_web_user.sql /
RUN chown postgres:postgres /create_web_user.sql

# Prestartup
COPY prestartup_postgres.sh /prestartup/

#------------------------
# Postgres on Supervisor
#------------------------

COPY run_postgres.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_postgres.sh
COPY supervisord_postgres.conf /etc/supervisor/conf.d/

#------------------------
# Security
#------------------------

# Disable SSH
RUN rm /etc/supervisor/conf.d/supervisord_sshd.conf
