FROM reyns/reyns-base-ubuntu18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

#------------------------------
# Apt requirements
#------------------------------

RUN apt-get update
#RUN apt-get install -y python-dev libffi-dev libssl-dev

# Install curl
RUN apt-get install curl -y

# Install decent version of pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py 'pip==10.0.1'
RUN rm get-pip.py

# Docker
RUN apt-get install docker.io -y

#------------------------------
# Install eDjango
#------------------------------

# Prepare dir
RUN mkdir /opt/webapp

# Install eDjango
RUN cd /opt/webapp && git clone https://github.com/sarusso/eDjango.git 
RUN cd /opt/webapp/eDjango && git pull && git checkout d9fb752bbcdd42d7d68a9d63b3cb51058457a7a3


#------------------------------
# Install App code
#------------------------------

# Add code
COPY code /opt/webapp/webapp_app

# Inject the App in eDjango
RUN ln -s /opt/webapp/webapp_app /opt/webapp/eDjango/edjango/webapp_app

# Copy db conf
COPY db_conf.sh /opt/webapp/db_conf.sh

# Fix permissions
RUN chown -R reyns:reyns /opt/webapp

# Prepare for logs
RUN mkdir /var/log/webapp/ && chown reyns:reyns /var/log/webapp/

#------------------------------
# Install Python requirements
#------------------------------

# Remove six
RUN apt-get remove python-six -y

# Install eDJango requirements..
RUN cd /opt/webapp && pip install -r eDjango/requirements.txt

# Install App requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt


#------------------------------
# Supervisord
#------------------------------

COPY run_webapp.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_webapp.sh
COPY supervisord_webapp.conf /etc/supervisor/conf.d/


#------------------------------
# Entrypoint
#------------------------------

# Copy, give right permissions & unique name to container prestartup
COPY prestartup_webapp.sh /prestartup/


#------------------------------
# Expose ports
#------------------------------

# reyns: expose 8080/tcp


#------------------------------
# Security
#------------------------------

# Disable SSH
RUN rm /etc/supervisor/conf.d/supervisord_sshd.conf












