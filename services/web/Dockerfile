FROM reyns/reyns-base-ubuntu18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

# Always start with an apt-get update when extending Reyns images,
# otherwise apt repositories might get outdated (404 not found)
# and building without cache does not re-build Reyns services.
RUN apt-get update

#------------------------------
# Apt requirements
#------------------------------

# Install Curl
RUN apt-get install curl -y

# Download get-pip script
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
RUN mkdir /opt/web

# Install eDjango
RUN cd /opt/web && git clone https://github.com/sarusso/eDjango.git 
RUN cd /opt/web/eDjango && git pull && git checkout 5a950fbe8b7ceb7032e65fbb9216958c7e7c1209


#------------------------------
# Python requirements
#------------------------------

# Remove six
RUN apt-get remove python-six -y

# Install eDJango requirements..
RUN cd /opt/web && pip install -r eDjango/requirements.txt
RUN cd /opt/web && pip3 install -r eDjango/requirements.txt

# Install App requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt


#------------------------------
# Install App code
#------------------------------

# Add code
COPY code /opt/web/web_app

# Inject the App in eDjango
RUN ln -s /opt/web/web_app /opt/web/eDjango/edjango/web_app

# Copy db conf
COPY db_conf.sh /opt/web/db_conf.sh

# Fix permissions
RUN chown -R reyns:reyns /opt/web

# Prepare for logs
RUN mkdir /var/log/web/ && chown reyns:reyns /var/log/web/

# Copy run tests script
COPY run_unit_test.sh /opt/web/
COPY run_integration_test.sh /opt/web/
RUN chmod 755 /opt/web/run_unit_test.sh && chmod 755 /opt/web/run_integration_test.sh


#------------------------------
# Prestartup
#------------------------------

COPY run_web.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_web.sh
COPY supervisord_web.conf /etc/supervisor/conf.d/


#------------------------------
# Entrypoint
#------------------------------

# Copy, give right permissions & unique name to container prestartup
COPY prestartup_web.sh /prestartup/


#------------------------------
# Expose ports
#------------------------------

# reyns: expose 8080/tcp


#------------------------------
# Security
#------------------------------

# Disable SSH (will cause integration tests to fail if run without tty)
#RUN rm /etc/supervisor/conf.d/supervisord_sshd.conf






