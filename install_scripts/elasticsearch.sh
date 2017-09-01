#!/bin/bash

echo "---- Installing Elasticsearch ------------------------------------------------"

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

cd /tmp/
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.deb.sha1

generated=$(sha1sum elasticsearch-5.5.2.deb | awk '{print $1}')
provided=`cat elasticsearch-5.5.2.deb.sha1`

if [ "$generated" == "$provided" ]; then
	printf "SHA matches"

else
	printf "SHA comparison doesn't match. Check to see if you're downloading the correct Elasticsearch"
	exit 1
fi

# Install Elasticsearch
dpkg -i elasticsearch-5.5.2.deb

# firewall exception
ufw allow 9200

# Enable Elasticsearch upon boot
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service