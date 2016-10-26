#!/bin/bash
#######################################################################################
#  Title      : nrpe.sh
#  Author     : Radhakrishnan Rk
#  Date       : 27/10/2016
#  Last Edited: 27/10/2016, Radhakrishnan Rk
#  Description: Bash script to install nrpe on linux server
#  Usage      : bash nrpe.sh --nagiosserver 192.168.1.100
########################################################################################


ARGS=$(getopt -o a -l "nagiosserver:" -- "$@");
eval set -- "$ARGS";
while true; do
case "$1" in

-a|--nagiosserver)
shift;
if [ -n "$1" ]; then
nagiosserver=$1;
shift;
fi
;;

--)

shift;
break;
;;
esac
done

if [ -f /etc/redhat-release ]; then
DISTRO=$(awk '{print $1}' /etc/redhat-release)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
fi
if [ $DISTRO == "Ubuntu" ]
then
	apt-get install -y nagios-nrpe-server nagios-plugins
	sed -e 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $nagiosserver/' /etc/nagios/nrpe.cfg
	sed -e 's/dont_blame_nrpe=0/dont_blame_nrpe=1/' /etc/nagios/nrpe.cfg
	/etc/init.d/nagios-nrpe-server restart
else
	yum install epel-release -y
	yum --enablerepo=epel -y install nrpe nagios-plugins
	sed -e 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $nagiosserver/' /etc/nagios/nrpe.cfg
	sed -e 's/dont_blame_nrpe=0/dont_blame_nrpe=1/' /etc/nagios/nrpe.cfg
	service nrpe start
	chkconfig nrpe on
fi
