#!/bin/sh

sa_passwd=$1
if [ -z "$sa_passwd" ]; then
    read -p "Enter the System Admin's password: " sa_passwd
fi

au_passwd=$2
if [ -z "$au_passwd" ]; then
    read -p "Enter the Admin's password: " au_passwd
fi

cu_passwd=$3
if [ -z "$cu_passwd" ]; then
    read -p "Enter the Core User's password: " cu_passwd
fi


echo Download Openfire 3.7.1 ...
echo wget http://www.igniterealtime.org/downloads/download-landing.jsp?file=openfire/openfire-3.7.1-1.i386.rpm

echo INSTALL:  Openfire 2>&1 | tee -a ../install.log
echo sudo yum install -y ./openfire-3.7.1-1.i386.rpm
sudo yum install -y ./openfire-3.7.1-1.i386.rpm
echo sudo yum install -y glibc.i686
sudo yum install -y glibc.i686
echo sudo chkconfig openfire on
sudo chkconfig openfire on
echo sudo firewall-cmd --permanent --zone=public --add-port=9090/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9090/tcp
echo sudo firewall-cmd --permanent --zone=public --add-port=9091/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9091/tcp
echo sudo firewall-cmd --permanent --zone=public --add-port=5222/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5222/tcp
echo sudo firewall-cmd --permanent --zone=public --add-port=5223/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5223/tcp
echo sudo firewall-cmd --reload
sudo firewall-cmd --reload

read -p "Enter the XMPP's FQDN: " fqdn

echo create user openfire@localhost and tables for OpenFire 2>&1 | tee -a ../install.log
echo cp conf/openfire_mysql.sql.orig conf/openfire_mysql.sql 2>&1 | tee -a ../install.log
cp conf/openfire_mysql.sql.orig conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

rpl "%SYSADMINPASS%" "$sa_passwd" conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

rpl "%OPENFIRE_ADMIN_PASS%" "$sa_passwd" conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

rpl "%ADMINPASS%" "$au_passwd" conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

rpl "%FQDN%" "$fqdn" conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

echo "mysql -u root -p < conf/openfire_mysql.sql" 2>&1 | tee -a ../install.log
mysql -u root -p < conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

echo rm conf/openfire_mysql.sql 2>&1 | tee -a ../install.log
rm conf/openfire_mysql.sql 2>&1 | tee -a ../install.log

echo configure the conf/openfire.xml 2>&1 | tee -a ../install.log
echo cp conf/openfire.xml.orig conf/openfire.xml 2>&1 | tee -a ../install.log
cp conf/openfire.xml.orig conf/openfire.xml 2>&1 | tee -a ../install.log

rpl "%SYSADMINPASS%" $sa_passwd conf/openfire.xml 2>&1 | tee -a ../install.log

echo sudo cp /opt/openfire/openfire.xml /opt/openfire/openfire.xml.orig 2>&1 | tee -a ../install.log
sudo cp /opt/openfire/conf/openfire.xml /opt/openfire/conf/openfire.xml.orig 2>&1 | tee -a ../install.log

echo sudo cp conf/openfire.xml /opt/openfire/conf 2>&1 | tee -a ../install.log
sudo cp conf/openfire.xml /opt/openfire/conf 2>&1 | tee -a ../install.log

echo rm conf/openfire.xml 2>&1 | tee -a ../install.log
rm conf/openfire.xml 2>&1 | tee -a ../install.log

echo Generating self-signed keys for Openfire 2>&1 | tee -a ../install.log
echo cp /opt/openfire/resources/security/keystore security 2>&1 ../install.log
cp /opt/openfire/resources/security/keystore security 2>&1 ../install.log

echo cp installKeystore.orig installKeystore 2>&1 | tee -a ../install.log
cp installKeystore.orig installKeystore 2>&1 | tee -a ../install.log

rpl "%HOSTNAME%" "$fqdn" installKeystore 2>&1 | tee -a ../install.log

rpl "%KEYSTORE_PASS%" "$sa_passwd" installKeystore 2>&1 | tee -a ../install.log

echo Generate the keystore and keystore.jks 2>&1 | tee -a ../install.log
./installKeystore 2>&1 | tee -a ../install.log

echo sudo cp /opt/openfire/resources/security/keystore /opt/openfire/resources/security/keystore.orig 2>&1 | tee -a ../install.log
sudo cp /opt/openfire/resources/security/keystore /opt/openfire/resources/security/keystore.orig 2>&1 | tee -a ../install.log

echo sudo cp security/keystore /opt/openfire/resources/security 2>&1 | tee -a ../install.log
sudo cp security/keystore /opt/openfire/resources/security 2>&1 | tee -a ../install.log

echo sudo rm security/keystore 2>&1 | tee -a ../install.log
sudo rm security/keystore 2>&1 | tee -a ../install.log

echo sudo chown -R daemon:daemon /opt/openfire 2>&1 | tee -a ../install.log
sudo chown -R daemon:daemon /opt/openfire 2>&1 | tee -a ../install.log

echo rm installKeystore 2>&1 | tee -a ../install.log
rm installKeystore 2>&1 | tee -a ../install.log

echo Starting the OpenFire
sudo systemctl stop openfire.service
sudo systemctl start openfire.service

echo sudo cp security/keystore.jks /opt/openfire/security 2>&1 | tee -a ../install.log
sudo cp security/keystore.jks /usr/share/tomcat7/conf 2>&1 | tee -a ../install.log

echo sudo rm security/keystore.jks 2>&1 | tee -a ../install.log
sudo rm security/keystore.jks 2>&1 | tee -a ../install.log

sudo rpl "%KEYSTORE_PASS%" "$sa_passwd" /usr/share/tomcat7/conf/server.xml 2>&1 | tee -a ../install.log

echo replace FQDN in xchangecore/core.properties
rpl "%FQDN%" "$fqdn" ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log

echo sudo mv ../xchangecore/xchangecore /usr/share/tomcat7/webapps 2>&1 | tee -a ../install.log
sudo mv ../xchangecore/xchangecore /usr/share/tomcat7/webapps 2>&1 | tee -a ../install.log

echo sudo mv ../xchangecore/opendj-connector /usr/share/tomcat7/webapps 2>&1 | tee -a ../install.log
sudo mv ../xchangecore/opendj-connector /usr/share/tomcat7/webapps 2>&1 | tee -a ../install.log

echo Starting the Tomcat 2>&1 | tee -a ../install.log
sudo systemctl stop tomcat7 2>&1 | tee -a ../install.log
sudo systemctl start tomcat7 2>&1 | tee -a ../install.log

echo ... done ...
