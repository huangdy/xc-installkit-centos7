#!/bin/sh

echo "mysql -u root -p < conf/xchangecore_cleanup.sql" 2>&1 | tee -a ../uninstall.log
mysql -u root -p < conf/xchangecore_cleanup.sql 2>&1 | tee -a ../uninstall.log
