#!/bin/bash

echo "---- Installing Hadoop ------------------------------------------------"

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

mkdir /opt/hadoop

cd /opt/hadoop

wget http://apache.spinellicreations.com/hadoop/common/hadoop-$hadoop_version/hadoop-$hadoop_version.tar.gz

tar --strip-components=1 -xvf hadoop-$hadoop_version.tar.gz

rm /opt/hadoop/hadoop-$hadoop_version.tar.gz

HADOOP_PREFIX=/opt/hadoop

cat <<EOT >> /home/combine/.bashrc
export HADOOP_PREFIX=/opt/hadoop
export HADOOP_HOME=$HADOOP_PREFIX
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
export HADOOP_HDFS_HOME=$HADOOP_PREFIX
export HADOOP_MAPRED_HOME=$HADOOP_PREFIX
export HADOOP_YARN_HOME=$HADOOP_PREFIX
EOT

source /home/combine/.bashrc

# Set JAVA_HOME for hadoop-env.sh, as Ubuntu-installs don't seem to pick env var up automatically
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Copy configuration files for hadoop and yarn from /config/files
cp $SHARED_DIR/config/files/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
cp $SHARED_DIR/config/files/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
cp $SHARED_DIR/config/files/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

## Start HDFS daemons
# Format the namenode directory (DO THIS ONLY ONCE, THE FIRST TIME)
$HADOOP_PREFIX/bin/hdfs namenode -format

# Re-establish permissions
sudo chown -R combine:combine /opt/hadoop