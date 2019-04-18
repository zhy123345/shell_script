#!/bin/bash

#free -h
sh /usr1/tools/apache-tomcat-7.0.73/bin/shutdown.sh
sleep 5
sync
echo 1 > /proc/sys/vm/drop_caches;echo 2 > /proc/sys/vm/drop_caches;echo 3 > /proc/sys/vm/drop_caches
sh /usr1/tools/apache-tomcat-7.0.73/bin/start.sh
