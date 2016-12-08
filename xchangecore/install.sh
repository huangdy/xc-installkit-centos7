#!/bin/sh

sa_passwd=$1
au_passwd=$2
cu_passwd=$3
lat=$4
lon=$5
lat_lon=" "

if [ -z "$lat" ] || [ -z "$lon" ]; then
    lat=38.8838180
    lon=-77.108078
fi

if [ -n "$lat" ] && [ -n "$lon" ]; then
	lat_lon=$lat/$lon
fi

basedir=`pwd`

echo mkdir xchangecore && cd xchangecore && jar xvf $basedir/xchangecore-2.0.0.war 2>&1 | tee -a $basedir/install.log
mkdir xchangecore
cd $basedir/xchangecore && jar xvf $basedir/xchangecore-2.0.0.war 2>&1 | tee -a $basedir/install.log

cd $basedir
rpl "%LOCATION%" "$lat_lon" xchangecore/core.properties 2>&1 | tee -a $basedir/install.log

echo cp conf/xchangecore_creation.sql.orig conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log
cp conf/xchangecore_creation.sql.orig conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log

rpl "%SYSADMINPASS%" "$sa_passwd" conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log

echo "mysql -u root -p < conf/xchangecore_creation.sql" 2>&1 | tee -a $basedir/install.log
mysql -u root -p < conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log

echo rm conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log
rm conf/xchangecore_creation.sql 2>&1 | tee -a $basedir/install.log

echo tar xvf opendj-connector.war 2>&1 | tee -a $basedir/install.log
tar xvf opendj-connector.war 2>&1 | tee -a $basedir/install.log

rpl "%SYSADMINPASS%" "$sa_passwd" opendj-connector/opendj-rest2ldap-servlet.json 2>&1 | tee -a $basedir/install.log

