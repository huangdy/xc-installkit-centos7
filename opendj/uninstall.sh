#!/bin/sh

echo sudo /opt/opendj/bin/stop-ds >> ../uninstall.log
sudo /opt/opendj/bin/stop-ds 2>&1 | tee -a ../uninstall.log

echo sudo rm -fr /opt/opendj >> ../uninstall.log
sudo rm -fr /opt/opendj 2>&1 | tee -a ../uninstall.log
