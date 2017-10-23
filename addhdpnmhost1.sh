#!/bin/bash
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname)
echo $HOSTNAME
hostname $HOSTNAME
echo $HOSTNAME
USERNAME='autoscaling'
PASSWORD='ghItQ1I9h6nZJDgsYk6bbnVbm83MW6xgLh578E1sWNk'
CLUSTER_NAME='cloudlab'
AMBARI_HOST='172.31.58.216'
AMBARI_PORT='8080'

/etc/init.d/ambari-agent start
sleep 60
curl --user $USERNAME:$PASSWORD -i -X POST http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME
sleep 30
curl --user $USERNAME:$PASSWORD -i -X POST http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER
sleep 30
curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Install"},"Body":{"HostRoles":{"state":"INSTALLED"}}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER
sleep 30
curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"HostRoles": {"state": "STARTED"}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER
sleep 10
#refresh hdp client configuration
curl -u$USERNAME:$PASSWORD -H 'X-Requested-By: ambari' -X POST -d '
{
   "RequestInfo":{
      "command":"RESTART",
      "context":"Restart all clients on '$HOSTNAME'",
      "operation_level":{
         "level":"HOST",
         "cluster_name":"'$CLUSTER_NAME'"
      }
   },
   "Requests/resource_filters":[
      {
         "service_name":"ZOOKEEPER",
         "component_name":"ZOOKEEPER_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"SQOOP",
         "component_name":"SQOOP",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"OOZIE",
         "component_name":"OOZIE_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"MAHOUT",
         "component_name":"MAHOUT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"HIVE",
         "component_name":"HCAT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"HIVE",
         "component_name":"HIVE_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"HBASE",
         "component_name":"HBASE_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"FALCON",
         "component_name":"FALCON_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"SPARK",
         "component_name":"SPARK_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"MAPREDUCE2",
         "component_name":"MAPREDUCE2_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"YARN",
         "component_name":"YARN_CLIENT",
         "hosts":"'$HOSTNAME'"
      },
      {
         "service_name":"HDFS",
         "component_name":"HDFS_CLIENT",
         "hosts":"'$HOSTNAME'"
      }
   ]
}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/requests
