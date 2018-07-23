FROM reyns/reyns-base-ubuntu18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

#------------------------------
# Apt requirements
#------------------------------

# Update
RUN apt-get update

# Install Curl
RUN apt-get install curl -y

# Install get-pip script
RUN curl -O https://bootstrap.pypa.io/get-pip.py

# Install Python3 and Pip3 (python3-distutils required for pip3)
RUN apt-get install python3 python3-distutils -y 

# Install Python and pip in this order (first Python 3 and then Python 2), or 
# you will end ap with python defaulting to python2 and pip defaulting to pip3
# Otherwise, do somethign like "ln -s /usr/local/bin/pip3 /usr/local/bin/pip"

# Install Python3 and Pip3 (ython3-distutils required for pip3)
RUN apt-get install python3 python3-distutils -y 
RUN python3 get-pip.py 'pip==10.0.1'

# Install Python2 and Pip2
RUN apt-get install python -y
RUN python get-pip.py 'pip==10.0.1'

# Python 3 dev (for pycrypto)
RUN apt-get install python3-dev -y


#------------------------------
# Install eDjango
#------------------------------

# Prepare dir
RUN mkdir /opt/webapp

# Install eDjango
RUN cd /opt/webapp && git clone https://github.com/sarusso/eDjango.git 
RUN cd /opt/webapp/eDjango && git pull && git checkout c00494e7067fa481be0e23436fce713e0bd58728


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
# Python requirements
#------------------------------

# Remove six
RUN apt-get remove python-six -y

# Install eDJango requirements..
RUN cd /opt/webapp && pip install -r eDjango/requirements.txt
RUN cd /opt/webapp && pip3 install -r eDjango/requirements.txt

# Install App requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt


#------------------------------
# Prestartup
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







