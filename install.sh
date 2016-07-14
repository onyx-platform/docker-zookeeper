#! /bin/bash

## Shared configuration directory for all bootstrapping

touch /opt/zookeeper/conf/zoo.cfg
echo "tickTime=2000" >> /opt/zookeeper/conf/zoo.cfg
echo "initLimit=10" >> /opt/zookeeper/conf/zoo.cfg
echo "syncLimit=5" >> /opt/zookeeper/conf/zoo.cfg
echo "dataDir=/tmp/zookeeper" >> /opt/zookeeper/conf/zoo.cfg
echo "dataLogDir=/zookeeper-transactions" >> /opt/zookeeper/conf/zoo.cfg
echo "autopurge.snapRetainCount=5" >> /opt/zookeeper/conf/zoo.cfg
echo "autopurge.purgeInterval=24" >> /opt/zookeeper/conf/zoo.cfg

echo "standaloneEnabled=false" >> /opt/zookeeper/conf/zoo.cfg
echo "dynamicConfigFile=/opt/zookeeper/conf/zoo.cfg.dynamic" >> /opt/zookeeper/conf/zoo.cfg

mv /tmp/log4j.properties /opt/zookeeper/conf/log4j.properties
