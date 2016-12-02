#!/bin/sh

sa_passwd=$1
au_passwd=$2
cu_passwd=$3
lat=$4
lon=$5

if [ -z "$lat" ] || [ -z "$lon" ]; then
    lat=38.8838180
    lon=-77.108078
fi

echo Install OpenDJ
echo sudo unzip -d /opt OpenDJ-2.7.0-20131023.zip 2>&1 | tee -a ../install.log
sudo unzip -d /opt OpenDJ-2.7.0-20131023.zip 2>&1 | tee -a ../install.log

echo Setup OpenDJ
echo sudo /opt/opendj/setup --cli --no-prompt --doNotStart -Z 636 -q --generateSelfSignedCertificate -N XCHANGECORE --adminConnectorPort 4444 -D "cn=Directory Manager" -w $sa_passwd -b dc=xchangecore,dc=us -a 2>&1 | tee -a ../install.log
sudo /opt/opendj/setup --cli --no-prompt --doNotStart -Z 636 -q --generateSelfSignedCertificate -N XCHANGECORE --adminConnectorPort 4444 -D "cn=Directory Manager" -w $sa_passwd -b dc=xchangecore,dc=us -a 2>&1 | tee -a ../install.log

echo Starting OpenDJ
echo sudo /opt/opendj/bin/start-ds 2>&1 | tee -a ../install.log
sudo /opt/opendj/bin/start-ds 2>&1 | tee -a ../install.log

echo Creating Admin and User Groups
echo cp conf/setup.ldif.orig conf/setup.ldif 2>&1 | tee -a ../install.log
cp conf/setup.ldif.orig conf/setup.ldif 2>&1 | tee -a ../install.log

echo Replace all the replacements
echo rpl "%ADMINUSER%" admin conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%ADMINUSER%" admin conf/setup.ldif 2>&1 | tee -a ../install.log
echo rpl "%ADMINPASS%" $au_passwd conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%ADMINPASS%" $au_passwd conf/setup.ldif 2>&1 | tee -a ../install.log
echo rpl "%COREUSER%" xchangecore conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%COREUSER%" xchangecore conf/setup.ldif 2>&1 | tee -a ../install.log
echo rpl "%COREPASS%" $cu_passwd conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%COREPASS%" $cu_passwd conf/setup.ldif 2>&1 | tee -a ../install.log
echo rpl "%LATITUDE%" -- "$lat" conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%LATITUDE%" -- "$lat" conf/setup.ldif 2>&1 | tee -a ../install.log
echo rpl "%LONGITUDE%" -- "$lon" conf/setup.ldif 2>&1 | tee -a ../install.log
rpl "%LONGITUDE%" -- "$lon" conf/setup.ldif 2>&1 | tee -a ../install.log

echo modify the ldap using setup.ldif
echo sudo /opt/opendj/bin/ldapmodify -p 636 -D "cn=Directory Manager" -w $sa_passwd -X -Z --noPropertiesFile -a -f conf/setup.ldif 2>&1 | tee -a ../install.log
sudo /opt/opendj/bin/ldapmodify -p 636 -D "cn=Directory Manager" -w $sa_passwd -X -Z --noPropertiesFile -a -f conf/setup.ldif 2>&1 | tee -a ../install.log

echo removed the setup.ldif
echo rm conf/setup.ldif 2>&1 | tee -a ../install.log
rm conf/setup.ldif 2>&1 | tee -a ../install.log

echo replace SYSADMINPASS, COREUSER, COREPASS, FQDN in xchangecore/core.properties
echo rpl "%SYSADMINPASS%" $sa_passwd ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
rpl "%SYSADMINPASS%" $sa_passwd ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
echo rpl "%COREUSER%" xchangecore ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
rpl "%COREUSER%" xchangecore ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
echo rpl "%COREPASS%" $cu_passwd ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
rpl "%COREPASS%" $cu_passwd ../xchangecore/xchangecore/core.properties 2>&1 | tee -a ../install.log
