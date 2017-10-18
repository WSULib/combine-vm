#!/bin/bash

echo "---- Installing Combine ------------------------------------------------"

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
# Install combine from github
git clone https://github.com/WSULib/combine /opt/combine

cd /opt/combine
git checkout dev
cp combine/localsettings.py.template combine/localsettings.py

# Turn on combine virtual environment
export PATH="/opt/miniconda/bin:$PATH"
source activate combine

# Install Livy client
apt-get -y install libkrb5-dev
cd /opt/livy/python-api
python setup.py install

# Install combine dependencies
apt-get -y install libmysql-java
cd /opt/combine
pip install -r requirements.txt

# Prepare MySQL db
mysql --user=root --password=$SQL_PASSWORD < $SHARED_DIR/config/files/combine.sql

python /opt/combine/manage.py makemigrations core
python /opt/combine/manage.py migrate core
python /opt/combine/manage.py migrate

# manually create additional tables from sql script, not managed by Django
mysql --user=root --password=$SQL_PASSWORD combine < core/inc/combine_tables.sql

# Create superuser
echo "from django.contrib.auth.models import User; User.objects.create_superuser('combine', 'libwebmaster@wayne.edu', '$SQL_PASSWORD')" | python /opt/combine/manage.py shell

# Make directory that will hold avro files
mkdir -p /home/combine/data/combine
chown -R combine:combine /home/combine/data

# Set permissions
chown -R combine:combine /opt/combine

# deactivate combine environment
source deactivate
