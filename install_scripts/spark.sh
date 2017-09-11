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
cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf

echo "spark.jars /opt/ingestion3/target/scala-$scala_version/ingestion3_$scala_version-0.0.1.jar" >> /opt/spark/conf/spark-defaults.conf
echo "spark.jars.packages org.apache.httpcomponents:fluent-hc:4.5.2,com.databricks:spark-avro_2.11:3.2.0" >> /opt/spark/conf/spark-defaults.conf

sudo chown -R combine:combine /opt/spark