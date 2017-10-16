#!/bin/bash

echo "---- Installing Ingestion3 ------------------------------------------------"

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

mkdir /opt/ingestion3
git clone https://github.com/WSULIb/ingestion3.git /opt/ingestion3

cd /opt/ingestion3
sbt package
chown -R combine:combine /opt/ingestion3