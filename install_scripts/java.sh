#!/bin/bash

echo "---- Installing Java ------------------------------------------------"

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

if which java >/dev/null; then
  echo "skip java 8 installation"
else
  echo "java 8 installation"
  apt-get install --yes python-software-properties
  add-apt-repository ppa:webupd8team/java
  apt-get update -qq
  echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
  echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
  apt-get install --yes oracle-java8-installer
  apt-get install --yes oracle-java8-set-default
fi

# Maven
apt-get -y install maven