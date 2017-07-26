FROM reyns/reyns-base-ubuntu14.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

#------------------------
# Apt requirements
#------------------------
RUN apt-get update #nocache 20170704
RUN apt-get install python-pip -y


#------------------------
# Install requirements
#------------------------

RUN apt-get install libffi-dev libssl-dev -y
RUN apt-get install libpq-dev -y # Required for psycopg2

# Install postgres pip driver
RUN pip install psycopg2

# Install requiremntes "in advance": we still rely on repo's requiremnts but
# here we try to speed up the build process as the step below are pobably not
# going to be chanded so often and we can rely on Docker's caching system.
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt


#------------------------
# eDjango sample app
#------------------------

# Clone sample app repo
RUN cd /opt && git clone https://github.com/sarusso/eDjango_sample_app.git

# Pull and checkout wanted version
RUN cd /opt/eDjango_sample_app && git pull #&& git checkout 3543b7c

# Clone eDjango repo
RUN cd /opt/eDjango_sample_app && git clone https://github.com/sarusso/eDjango.git 
RUN cd /opt/eDjango_sample_app/eDjango && git pull && git checkout 9ac4242

# Install requirements
RUN pip install -r /opt/eDjango_sample_app/eDjango/requirements.txt
RUN pip install -r /opt/eDjango_sample_app/sample_app/requirements.txt

# Inject the Sample App in eDjango
RUN ln -s /opt/eDjango_sample_app/sample_app /opt/eDjango_sample_app/eDjango/edjango/sample_app

# Fix permissions
RUN chown -R reyns:reyns /opt/eDjango_sample_app


#------------------------
# Supervisord
#------------------------

COPY run_eDjango.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_eDjango.sh
COPY supervisord_eDjango.conf /etc/supervisor/conf.d/


#------------------------
# Entrypoint
#------------------------

# Copy, give right permissions & unique name to container prestartup
COPY prestartup_eDjango.sh /prestartup/

#------------------------
# Expose ports
#------------------------

#EXPOSE_AS 8080, 8082















