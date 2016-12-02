#!/bin/sh

echo stop tomcat7 stop 2>&1 | tee -a ../uninstall.log
sudo systemctl stop tomcat7.service 2>&1 | tee -a ../uninstall.log

echo sudo rm -fr /usr/share/tomcat7 2>&1 | tee -a ../uninstall.log
sudo rm -fr /usr/share/tomcat7 2>&1 | tee -a ../uninstall.log

echo remove the tomcat7 service daemon 2>&1 | tee -a ../uninstall.log
sudo chkconfig tomcat7 off 2>&1 | tee -a ../uninstall.log

