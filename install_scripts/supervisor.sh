#!/bin/bash

echo "---- Installing Supervisor ------------------------------------------------"

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

# apt-get install 
apt-get -y install supervisor

# copy custom supervisor.conf file
cp $SHARED_DIR/config/files/supervisord.conf /etc/supervisor/

# chown supervisor directory for combine user
chown -R combine:combine /etc/supervisor

# make combine owner of supervisor logs
chown -R combine:combine /var/log/supervisor

# make a logs folder for hadoop/yarn programs to write to
mkdir /var/log/hadoop
chown -R combine:combine /var/log/hadoop

# make a logs folder for Livy program to write to
mkdir /var/log/livy
chown -R combine:combine /var/log/livy

# make logs folder for pyjxslt
mkdir /var/log/pyjxslt
chown -R combine:combine /var/log/pyjxslt

# restart
service supervisor stop
service supervisor start
