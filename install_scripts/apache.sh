#!/bin/bash
echo "---- Install Apache ------------------------------------------------"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "found your local envvars file. Using it."

else
  . $SHARED_DIR/config/envvars.default
  printf "found your template file. Using its default values."

fi

# Set MySQL password
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $SQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $SQL_PASSWORD"

# Install LAMP
sudo apt-get -y install lamp-server^

apt-get -y install libapache2-mod-wsgi libapache2-mod-jk

# Set servername
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
a2enconf servername
service apache2 restart

# Install modules
a2enmod cache cgi cache_disk expires headers proxy proxy_ajp proxy_connect proxy_http reqtimeout rewrite ssl
service apache2 restart

# set firewall rules
# sudo iptables-restore < /vagrant/downloads/apache2/iptables.conf

# Copy ports.conf
cp $SHARED_DIR/downloads/apache2/ports.conf /etc/apache2

# Copy workers.properties
cp $SHARED_DIR/downloads/apache2/workers.properties /etc/apache2

a2dissite 000-default.conf
service apache2 restart

# Copy sites-available and find/replace env variables from envvars
rm /etc/apache2/sites-available/000-default.conf
cp -R $SHARED_DIR/downloads/apache2/sites-available/* /etc/apache2/sites-available
sed -i "s/VM_HOST_PLACEHOLDER/$VM_HOST/g" /etc/apache2/sites-available/*
sed -i "s/VM_NAME_PLACEHOLDER/$VM_NAME/g" /etc/apache2/sites-available/*

# Copy SSL certs
cp -R $SHARED_DIR/downloads/apache2/certs /root/cert

# Set IP addr and networking info
# cp /vagrant/downloads/apache2/interfaces /etc/network/interfaces

# Copy /etc/hosts file
# cp /vagrant/downloads/apache2/hosts /etc/hosts

# Copy /etc/hostname file
cp $SHARED_DIR/downloads/apache2/hostname /etc/hostname

# Restart networking for hostname
sudo service hostname restart

# Make wsuls directory
mkdir /var/www/wsuls

# Copy custom 404 page to root
cp $SHARED_DIR/downloads/apache2/404.html /var/www/wsuls

# enable all sites
a2ensite 000-default.conf
a2ensite 000-default-ssl.conf
service apache2 restart