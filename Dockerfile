FROM centos:7

MAINTAINER ksk124

USER root

########################################
# Downloading Configuration Files from Remote Server or S3
########################################

RUN mkdir -p /config \
  && yum install -y wget


# ADD CDH Repository
ADD cloudera-cdh6.repo /etc/yum.repos.d/

ADD /etc/flume.conf /config/
ADD /etc/flume-ng-agent /config/


########################################
# Dependency: Default
#             JAVA
########################################

ENV JAVA_VERSION 1.8.0

RUN yum update -y \
    && yum install -y \
    sudo \
    rsyslog \
    java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel


########################################
# Dependency: Impala
########################################

RUN rpm --import https://archive.cloudera.com/cdh6/6.3.2/redhat7/yum/RPM-GPG-KEY-cloudera \
    && yum install -y \
    flume-ng-agent \
    && yum clean all


####################
# Configuring
####################


RUN echo "Configuring Flume" \
 && ln -sf /config/flume.conf /etc/flume-ng/conf/flume.conf  \
 && ln -sf /config/flume-ng-agent /etc/default/flume-ng-agent  \
 && wget -O /usr/lib/flume-ng/lib/json-20160810.jar https://repo1.maven.org/maven2/org/json/json/20160810/json-20160810.jar \
 && wget -O /usr/lib/flume-ng/lib/kudu-flume-sink-1.9.0-cdh6.2.1.jar https://repository.cloudera.com/artifactory/cloudera-repos/org/apache/kudu/kudu-flume-sink/1.9.0-cdh6.2.1/kudu-flume-sink-1.9.0-cdh6.2.1.jar \
 && wget -O /usr/lib/flume-ng/lib/fastjson-1.2.46.jar https://soo-test-bucket.s3.ap-northeast-2.amazonaws.com/kafka-flume/fastjson-1.2.46.jar \
 && wget -O /usr/lib/flume-ng/lib/kudu-flume-sink-1.0-SNAPSHOT-jar-with-dependencies.jar https://soo-test-bucket.s3.ap-northeast-2.amazonaws.com/kafka-flume/kudu-flume-sink-1.0-SNAPSHOT-jar-with-dependencies.jar
 


#VOLUME /var/lib/flume-ng


####################
# PORTS
####################
# http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cdh_ig_ports_cdh5.html
# http://www.cloudera.com/content/www/en-us/documentation/enterprise/latest/topics/cm_ig_ports_impala.html
####################
#
#  7050 Kudu: TabletServer RPC Port
#  7051 Kudu: Master RPC Port
#  8020 or 9000 HDFS: NameNode IPC
#  8050 Kudu: TabletServer HTTP (Web UI)
#  8051 Kudu: Master HTTP (Web UI)
#  9083 Hive: Metastore
# 15000 Impala: Llama ApplicationMaster Thrift (internal)
# 15001 Impala: Llama ApplicationMaster HTTP (Web UI)
# 15002 Impala: Llama ApplicationMaster Admin Thrift (internal)
# 21000 Impala: Daemon Shell (RPC)
# 21050 Impala: Daemon ODBC/JDBC (RPC)
# 22000 Impala: Daemon Backend (internal)
# 23000 Impala: Daemon StateStoreSubscriber (internal)
# 23020 Impala: Catalog StateStoreSubscriber (internal)
# 24000 Impala: StateStore Thrift (internal)
# 25000 Impala: Daemon HTTP (Web UI)
# 25010 Impala: StateStore HTTP (Web UI)
# 25020 Impala: Catalog HTTP (Web UI)
# 26000 Impala: Catalog, push updates to daemons (internal)
# 28000 Impala: Llama Callback (internal)
# 50010 HDFS: DataNode Transfer
# 50020 HDFS: DataNode IPC
# 50070 HDFS: NameNode HTTP (Web UI)
# 50075 HDFS: DataNode HTTP (Web UI)

#EXPOSE 8020 9000 9083 15000 15001 15002 21000 21050 22000 23000 23020 24000 25000 25010 26000 28000 50010 25020 50070 50075

ADD docker-entrypoint.sh /
ADD wait-for-it.sh /

# Add the entrypoint.
# when file is excutable : chmod +x docker-entrypoint.sh
#ENTRYPOINT ["/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["help"]

LABEL name="Apache Flume-Cdh" \
      description="An image with the Flume based on CDH."
