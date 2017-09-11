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

wget https://github.com/cloudera/livy/archive/v$livy_version.tar.gz

tar -xvf v$livy_version.tar.gz

mv livy-$livy_version/* /opt/livy

cd /opt/livy

mvn package -DskipTests

mkdir logs

chown -R combine:combine /opt/livy

echo "export SPARK_HOME=/opt/spark" >> /etc/environment

cat <<EOT >> /opt/livy/conf/livy.conf
livy.spark.master = yarn
livy.spark.deployMode = cluster
livy.impersonation.enabled = true
livy.file.local-dir-whitelist = /opt/ingestion3/target/scala-$scala_version/
livy.server.recovery.mode = recovery
livy.server.recovery.state-store = filesystem
livy.server.recovery.state-store.url = hdfs://localhost/livy_sessions
EOT


# make a symlink from ingestion3 jar file to a spot in livy application directory
ln -s /opt/ingestion3/target/scala-$scala_version/ingestion3_$scala_version-0.0.1.jar /opt/livy/rsc/target/jars/ingestion3.jar