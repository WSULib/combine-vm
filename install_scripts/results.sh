#!/bin/bash

echo "---- Running Tests ------------------------------------------------"

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

printf "\n\n---------------------- Installation Results -----------------------\n\n\n"

# Verify Elasticsearch is running
curl -XGET "$ES_host:$ES_port/?pretty"

status=$(curl -s -o /dev/null -I -w "%{http_code}" "${ES_host}:${ES_port}")

if [ "$status" == "200" ]; then 
	printf "\n\nElasticsearch \xe2\x9c\x85 \n\n\n"
else
	printf "\n\n Elasticsearch \xe2\x9d\x8c \n\n\n"
fi