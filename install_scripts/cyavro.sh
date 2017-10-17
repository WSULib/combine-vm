#!/bin/bash

echo "---- Installing Cyavro ------------------------------------------------"

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

# install cyavro
source activate combine
conda install cyavro
source deactivate
chown -R combine:combine /opt/miniconda
rm /tmp/miniconda.sh
