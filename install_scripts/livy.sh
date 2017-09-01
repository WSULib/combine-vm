#!/bin/bash

echo "---- Installing Livy ------------------------------------------------"

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

mkdir /opt/livy

git clone https://github.com/cloudera/livy/releases/tag/v$livy_version /opt/livy

cd /opt/livy

mvn package -DskipTtests

chown -R livy:livy /opt/livy

echo "export SPARK_HOME=/opt/spark/$spark_version" >> /etc/environment

echo "livy.file.local-dir-whitelist = /opt/ingestion3/target/scala-2.11/" >> /opt/livy/conf/livy.conf