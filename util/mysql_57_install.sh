#!/bin/bash
sudo yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
sudo yum install mysql-community-server
systemctl start mysqld.service ## use restart after update
systemctl enable mysqld.service
sudo grep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1
/usr/bin/mysql_secure_installation
