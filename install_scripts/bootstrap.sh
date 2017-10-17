#!/bin/bash
echo "---- Bootstrapping ------------------------------------------------"

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

# USERS
#########################################################
#create admin group
groupadd admin

# Create combine user
useradd -m -s /bin/bash combine
echo combine:combine | chpasswd

# update some groups
usermod -a -G combine vagrant
usermod -a -G admin combine

# TOOLS
#########################################

# fix interactivity issue
export DEBIAN_FRONTEND=noninteractive

# Update
apt-get -y update && apt-get -y upgrade

# SSH
apt-get -y install openssh-server

# Build tools
apt-get -y install build-essential

# unzip
apt-get -y install unzip

# Python essentials
apt-get -y install libxml2-dev libxslt1-dev python-dev python-setuptools

# Install pip
sudo easy_install pip

# Install zlib
sudo apt-get -y install zlib1g-dev

# Remove python-six in order to allow pip to install the most up-to-date version of six
sudo apt-get -y purge python-six

# jupyter notebook
pip install jupyter

# Git vim
apt-get -y install git vim

# Wget and curl
apt-get -y install wget curl

# visualization tools
apt-get -y install htop tree ncdu

# setup tailing
apt-get -y install multitail
echo "multitail /var/log/apache2/$VM_NAME-access.log /var/log/apache2/$VM_NAME-error.log" > /usr/bin/alltails
chmod +x /usr/bin/alltails

# upgrade setuptools so that Livy will install
sudo -H pip install setuptools --upgrade

# install miniconda
cd /tmp/
wget https://repo.continuum.io/miniconda/Miniconda2-4.3.21-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/miniconda
export PATH="/opt/miniconda/bin:$PATH"
conda config --set always_yes yes
conda config --add channels conda-forge
# put in combine's path
echo "export PATH=/opt/miniconda/bin:$PATH" >> /home/combine/.bashrc

# create combine conda environment for first time
conda create -n combine python=3.5
source activate combine

# DB install

# Set MySQL password
debconf-set-selections <<< "mysql-server mysql-server/root_password password $SQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $SQL_PASSWORD"

# Install MySQL
apt-get -y install mysql-server libmysqlclient-dev

# UPDATE NETWORKING ON NON-VAGRANT INSTALLS
#########################################################
if [ -z ${NON_VAGRANT+x} ]; then 
  echo "not editing /etc/hosts as this is a vagrant install";
else
  vim /etc/hosts;
fi
