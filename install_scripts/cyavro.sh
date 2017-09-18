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

cd /tmp/
wget https://repo.continuum.io/miniconda/Miniconda2-4.3.21-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/miniconda
export PATH="/opt/miniconda/bin:$PATH"
conda config --set always_yes yes --set changeps1 no
conda config --add channels conda-forge
# put in combine's path
echo "export PATH=/opt/miniconda/bin:$PATH" >> /home/combine/.bashrc

conda create -n combine python=3.6
source activate combine
conda install cyavro
source deactivate
chown -R combine:combine /opt/miniconda
rm /tmp/miniconda.sh
