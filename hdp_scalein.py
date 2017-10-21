import urllib2
import json
import sys
import boto3
import os
import requests
from subprocess import call

os.environ["AWS_ACCESS_KEY_ID"] = "accesskey"
os.environ["AWS_SECRET_ACCESS_KEY"] = "secretkey"
os.environ["AWS_DEFAULT_REGION"] = "ap-south-1"

url = 'http://169.254.169.254/latest/meta-data/instance-id'
r = requests.get(url)
instanceid =  r.text
#print instanceid

autoscaling = boto3.client('autoscaling')
lifecycle = autoscaling.describe_auto_scaling_instances(InstanceIds=[ instanceid,])
#print lifecycle

for lifecycles in lifecycle["AutoScalingInstances"]:
    status = lifecycles['LifecycleState']
    #status = 'Terminating:Wait'
    print status
    if status == 'Terminating:Wait':
        call(['bash', '/root/scalein/node_del.sh'])
    else:
        print 'no action'
