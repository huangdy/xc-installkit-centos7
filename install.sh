#!/bin/sh

echo Install the xChagneCore environment 2>&1 | tee -a install.log
echo There are couple tools needed to be installed if they have not installed yet, such as Java, rpl, unzip, curl, mysql-server 2>&1 | tee -a install.log
echo The way to install are: 2>&1 | tee -a install.log
echo 	- sudo apt-get install rpl 2>&1 | tee -a install.log
echo 	- sudo apt-get install unzip 2>&1 | tee -a install.log
echo 	- sudo apt-get install curl 2>&1 | tee -a install.log
echo 	- sudo apt-get install mysql-server 2>&1 | tee -a install.log

read -p "Enter the System Administrator's Password: " sa_passwd
read -p "Enter the Administrator User's Password: " au_passwd
read -p "Enter the Core User's Password: " cu_passwd
read -p "Enter latitude for core's proximity: (Enter for skip) " lat
read -p "Enter longitude for core's proximity: (Enter for skip) " lon


echo Install the xchangecore and opendj-connector 2>&1 | tee -a install.log
cd xchangecore && ./install.sh $sa_passwd $au_passwd $cu_passwd $lat $lon && cd -

echo Install the OpenDJ 2>&1 | tee -a install.log
cd opendj && ./install.sh $sa_passwd $au_passwd $cu_passwd $lat $lon && cd -

echo Install the Tomcat 2>&1 | tee -a install.log
cd tomcat && ./install.sh $sa_passwd $au_passwd $cu_passwd && cd -

echo Install the OpenFire 2>&1 | tee -a install.log
cd openfire && ./install.sh $sa_passwd $au_passwd $cu_passwd && cd -
