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

# fix interactivity issue
export DEBIAN_FRONTEND=noninteractive

# Update
apt-get -y update && apt-get -y upgrade

# SSH
apt-get -y install openssh-server

# create combine group
groupadd combine

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

# Install virtualenv and wrappers
pip install virtualenv virtualenvwrapper
mkdir /usr/local/lib/venvs
chown :combine /usr/local/lib/venvs
echo "WORKON_HOME=/usr/local/lib/venvs" >> /etc/environment
echo "# Added for virtualenvwrapper" >> /etc/bash.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /etc/bash.bashrc

# Set virtualenv variables and source file to work in current session
WORKON_HOME=/usr/local/lib/venvs
source /usr/local/bin/virtualenvwrapper.sh

# Make and start combine virtual environment
mkvirtualenv -p python3 combine
workon combine

chown -R :combine /usr/local/lib/venvs

# stop virtualenv
deactivate
echo "deactivating virtualenv"

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

# DB install

# Set MySQL password
debconf-set-selections <<< "mysql-server mysql-server/root_password password $SQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $SQL_PASSWORD"

# Install MySQL
apt-get -y install mysql-server

# UPDATE NETWORKING ON NON-VAGRANT INSTALLS
#########################################################
if [ -z ${NON_VAGRANT+x} ]; then 
  echo "not editing /etc/hosts as this is a vagrant install";
else
  vim /etc/hosts;
fi


# USERS
#########################################################

#combine-ify vagrant
usermod -a -G combine vagrant

# Create combine user
useradd -m -s /bin/bash combine
usermod -g combine combine
echo combine:combine | chpasswd
