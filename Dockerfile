FROM java:openjdk-8-jre-alpine
# Sourced from Franck Cuny <franck.cuny@gmail.com> 
# https://github.com/franckcuny/docker-distributedlog

MAINTAINER Gardner Vickers <gardner.vickers@onyxplatform.org>

RUN apk add --no-cache curl bash \
    && mkdir -p /opt \
    && cd /opt \
    && curl -fL http://archive.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz | tar xzf - -C /opt && \
    mv /opt/zookeeper-3.4.8 /opt/zookeeper

ENV LOG_DIR "/var/log/zookeeper"
ENV ZK_DATA_DIR "/var/lib/zookeeper"

ADD zk-docker.sh /usr/local/bin/

RUN ["mkdir", "-p", "/var/log/zookeeper", "/var/lib/zookeeper"]
RUN ["chmod", "+x", "/usr/local/bin/zk-docker.sh"]

VOLUME ["/var/log/zookeeper", "/var/lib/zookeeper"]

EXPOSE 2181 2888 3888

ENTRYPOINT ["/usr/local/bin/zk-docker.sh"]

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]