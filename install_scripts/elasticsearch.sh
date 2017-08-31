#!/bin/bash

echo "---- Installing Elasticsearch ------------------------------------------------"

#### GET ENVARS #################################################
SHARED_DIR=$1

if [ -f "$SHARED_DIR/config/envvars" ]; then
  . $SHARED_DIR/config/envvars
  printf "Found your local envvars file. Using it."

else
  printf "Could not find envvars - remember to copy /config/envvars.* (e.g. envvars.public) to /config/envvars.  Aborting."
  exit 1
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


# Enable Elasticsearch upon boot
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service

# Verify it running
curl -XGET "$ES_host:$ES_port/?pretty"

status=$(curl -s -o /dev/null -I -w "%{http_code}" "${ES_host}:${ES_port}")