FROM reyns/reyns-base-ubuntu18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

# Install Apache
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install apache2-utils

# Copy conf
COPY supervisord_apache.conf /etc/supervisor/conf.d/
COPY run_Apache.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_Apache.sh

# Enable mod_proxy and SSL
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN sudo a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod proxy_wstunnel
RUN a2enmod substitute
RUN a2enmod proxy_html
 
# Copy and enable conf for proxy
COPY 001-proxy.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-proxy.conf /etc/apache2/sites-enabled/001-proxy.conf

# We overwrite default Apache conf as we force https
COPY 000-default.conf /etc/apache2/sites-available/
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Copy and enable conf for ssl. Not enabling ssl default site causes the first ssl
# site in sites-avaialbe to be used as default. "Check with apachectl -t -D DUMP_VHOSTS".
# A custom conf is not really necessary as defaults are ok (it is the original file)
# Note: not naming this file with "000" causes to load other sites-available before, same problem.
COPY default-ssl.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/000-default-ssl.conf

# Copy certificates (snakeoil or real)
RUN mkdir /certificates
COPY certificates/webapp.crt /root/certificates/webapp/webapp.crt
COPY certificates/webapp.key /root/certificates/webapp/webapp.key
COPY certificates/webapp.ca-bundle /root/certificates/webapp/webapp.ca-bundle

# Copy index and norobots.txt
COPY index.html /var/www/html/
COPY norobots.txt /var/www/html/

# Prestartup
COPY prestartup_proxy.sh /prestartup/

# reyns: expose 80/tcp
# reyns: expose 443/tcp

#------------------------
# Security
#------------------------

# Disable SSH
RUN rm /etc/supervisor/conf.d/supervisord_sshd.conf
