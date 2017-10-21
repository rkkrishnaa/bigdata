#!/bin/bash
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname)
echo $HOSTNAME
hostname $HOSTNAME
echo $HOSTNAME
USERNAME='username'
PASSWORD='password'
CLUSTER_NAME='cloudlabns'
AMBARI_HOST='ip-172-166-11-52.ap-south-1.compute.internal'
AMBARI_PORT='64000'


/etc/init.d/ambari-agent start
setenforce 0
sleep 30
curl --user $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X POST http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME
sleep 30
curl --user $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X POST http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER
sleep 30
curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo":{"context":"Install"},"Body":{"HostRoles":{"state":"INSTALLED"}}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER
sleep 30
curl -u $USERNAME:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"HostRoles": {"state": "STARTED"}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/hosts/$HOSTNAME/host_components/NODEMANAGER

sudo -u yarn yarn rmadmin -refreshNodes
