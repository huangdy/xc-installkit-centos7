#!/bin/sh

echo sudo systemctrl stop openfire.service 2>&1 | tee -a ../uninstall.log
sudo systemctrl stop openfire.service 2>&1 | tee -a ../uninstall.log

echo sudo chkconfig openfire off
sudo chkconfig openfire off

echo sudo yum remove -y openfire 2>&1 | tee -a ../uninstall.log
sudo yum remove -y openfire 2>&1 | tee -a ../uninstall.log

echo "mysql -u root -p < conf/openfire_cleanup.sql" 2>&1 | tee -a ../uninstall.log
mysql -u root -p < conf/openfire_cleanup.sql 2>&1 | tee -a ../uninstall.log
