#!/bin/bash
i="y"
a=0
while [ $i = "y" ]
do
echo "Enter the snapshot id of the snapshot to be deleted"
read snapshot
snapshot=$snapshot
hadoop fs -deleteSnapshot /user $snapshot
if [ ! $? == $a ] ; then
	echo "Snapshot not Deleted"
else
	echo "Snapshot Deleted"
fi
echo "Do u want to continue ?[y/n]"
read i
if [ $i != "y" ]
then
    exit
fi
done
