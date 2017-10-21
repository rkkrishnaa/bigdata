#!/bin/bash
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname)
echo $HOSTNAME
#hostname $HOSTNAME
echo $HOSTNAME
USERNAME='username'
PASSWORD='password'
CLUSTER_NAME='cloudlabns'
AMBARI_HOST='ip-172-166-11-52.ap-south-1.compute.internal'
AMBARI_PORT='64000'

curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X POST -d '{
   "RequestInfo":{
      "context":"Decommission NodeManagers",
      "command":"DECOMMISSION",
      "parameters":{
         "slave_type":"NODEMANAGER",
         "excluded_hosts":"'$HOSTNAME'" 
      },
      "operation_level":{
         "level":"HOST_COMPONENT",
         "cluster_name":"'$CLUSTER_NAME'" 
      }
   },
   "Requests/resource_filters":[
      {
         "service_name":"YARN",
         "component_name":"RESOURCEMANAGER" 
      }
   ]
}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/requests

sleep 10

curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"HostRoles": {"state": "INSTALLED"}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER

sleep 10

curl -u $USERNAME:$PASSWORD -H "X-Requested-By: ambari" -X DELETE http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER

sleep 10

ambari-agent stop
sleep 10

curl -u $USERNAME:$PASSWORD -H "X-Requested-By: ambari" -X DELETE http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME

sudo -u yarn yarn rmadmin -refreshNodes
