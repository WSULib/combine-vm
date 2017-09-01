#!/bin/bash

echo "---- Installing Spark ------------------------------------------------"

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

# Install Scala and Scala Build Tool (sbt)
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get -y update
sudo apt-get -y install sbt




# Install Spark
cd /tmp/
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz

tar -xvf spark-2.0.1-bin-hadoop2.7.tgz

mv spark-2.0.1-bin-hadoop2.7 /opt/spark/

SET /etc/environment

# Insert test that shows it's running