#!/bin/bash
echo "---- Install Apache ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "found your local envvars file. Using it."

else
  . $SHARED_DIR/config/envvars.default
  printf "found your template file. Using its default values."

fi
#################################################################


# Install Apache Web Server
apt-get -y install apache2 libapache2-mod-wsgi libapache2-mod-jk

# Set servername
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
a2enconf servername
service apache2 restart

# Install modules
a2enmod cache cgi cache_disk expires headers proxy proxy_ajp proxy_connect proxy_http reqtimeout rewrite ssl
service apache2 restart

# set firewall rules
ufw  allow in 'Apache Full'

a2dissite 000-default.conf
service apache2 restart


# PLACEHOLDER for ports.conf configuration

# PLACEHOLDER for /etc/hosts file

# PLACEHOLDER for SSL certs

# PLACEHOLDER for /etc/hostname file

# Restart networking for hostname
# sudo service hostname restart

# enable all sites
a2ensite 000-default.conf
a2ensite 000-default-ssl.conf
service apache2 restart