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

HADOOP_PREFIX=/opt/hadoop

# set configurations in livy-env.sh
cat <<EOT >> /opt/livy/conf/livy-env.sh
SPARK_HOME=/opt/spark
HADOOP_PREFIX=/opt/hadoop
HADOOP_HOME=$HADOOP_PREFIX
HADOOP_COMMON_HOME=$HADOOP_PREFIX
HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
HADOOP_HDFS_HOME=$HADOOP_PREFIX
HADOOP_MAPRED_HOME=$HADOOP_PREFIX
HADOOP_YARN_HOME=$HADOOP_PREFIX
PYSPARK_PYTHON=/opt/miniconda/envs/combine/bin/python
EOT

# set configurations in livy-conf.sh
cat <<EOT >> /opt/livy/conf/livy.conf
livy.spark.master = yarn
livy.spark.deployMode = cluster
livy.impersonation.enabled = true
livy.file.local-dir-whitelist = /opt/ingestion3/target/scala-$scala_version/
livy.server.recovery.mode = recovery
livy.server.recovery.state-store = filesystem
livy.server.recovery.state-store.url = hdfs://localhost/livy_sessions
livy.server.session.timeout = 24h
EOT

# make a symlink from ingestion3 jar file to a spot in livy application directory
ln -s /opt/ingestion3/target/scala-$scala_version/ingestion3_$scala_version-0.0.1.jar /opt/livy/rsc/target/jars/ingestion3.jar
