#!/usr/bin/env bash

JAVA_HOME=/usr/local/jdk
PYSPARK_PYTHON=python2.7
PYSPARK_DRIVER_PYTHON=$PYSPARK_PYTHON
SPARKR_DRIVER_R=R

HADOOP_HOME=/opt/cloudera/parcels/CDH-5.11.0-1.cdh5.11.0.p0.34/lib/hadoop
YARN_HOME=/opt/cloudera/parcels/CDH-5.11.0-1.cdh5.11.0.p0.34/lib/hadoop-yarn
HADOOP_CONF_DIR=/opt/cloudera/parcels/CDH-5.11.0-1.cdh5.11.0.p0.34/lib/hadoop/etc/hadoop
YARN_CONF_DIR=/opt/cloudera/parcels/CDH-5.11.0-1.cdh5.11.0.p0.34/lib/hadoop-yarn/etc/hadoop

SPARK_EXECUTOR_INSTANCES=1
SPARK_EXECUTOR_CORES=1
SPARK_EXECUTOR_MEMORY=1G
SPARK_DRIVER_MEMORY=1G

SPARK_HOME=/usr/local/spark
SPARK_CONF_DIR=/usr/local/spark/conf
SPARK_LOG_DIR=/usr/local/spark/logs
SPARK_PID_DIR=/usr/local/spark/pid
