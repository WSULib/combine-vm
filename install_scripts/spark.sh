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
wget https://d3kbcqa49mib13.cloudfront.net/spark-$spark_version-bin-hadoop2.7.tgz

tar -xvf spark-$spark_version-bin-hadoop2.7.tgz

mkdir /opt/spark
mv spark-$spark_version-bin-hadoop2.7/* /opt/spark/

# copy pre-made config file, sed config settings, and copy to SPARK_HOME
cp $SHARED_DIR/config/files/spark-defaults.conf /tmp/spark-defaults.conf
sed -i "s/SCALA_VERSION_PLACEHOLDER/$scala_version/g" /tmp/spark-defaults.conf
cp /tmp/spark-defaults.conf /opt/spark/conf/spark-defaults.conf
rm /tmp/spark-defaults.conf

# add SPARK_HOME to bash profile
cat <<EOT >> /home/combine/.bashrc
export SPARK_HOME=/opt/spark
EOT

sudo chown -R combine:combine /opt/spark