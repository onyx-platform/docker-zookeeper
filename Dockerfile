FROM java:openjdk-8-jre-alpine

MAINTAINER Gardner Vickers <gardner.vickers@onyxplatform.org>

RUN apk add --no-cache curl bash

RUN mkdir -p /workdir && \
    mkdir -p /opt && \
    wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.5.1-alpha/zookeeper-3.5.1-alpha.tar.gz | tar -xzf - -C /opt && \
    mv /opt/zookeeper-3.5.1-alpha /opt/zookeeper

ADD on-start.sh /workdir/on-start.sh
ADD install.sh /workdir/install.sh
ADD log4j.properties /tmp/log4j.properties
ADD zoo.cfg /tmp/zoo.cfg
ADD https://storage.googleapis.com/kubernetes-release/pets/peer-finder /workdir/peer-finder

RUN chmod -c 755 /workdir/on-start.sh /workdir/peer-finder

EXPOSE 2181 2888 3888
