#!/bin/sh

echo ... uninstall the xChangeCore installation ... >> uninstall.log

echo uninstall -- tomcat --
cd tomcat && ./uninstall.sh && cd -

echo uninstall -- xchangecore --
cd xchangecore && ./uninstall.sh && cd -

echo unstall -- openfire --
cd openfire && ./uninstall.sh && cd -

echo uninstall -- opendj --
cd opendj && ./uninstall.sh && cd -
