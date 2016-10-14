#!/bin/bash
#######################################################################################
#  Title      : chpassword.sh
#  Author     : Radhakrishnan Rk
#  Date       : 10/10/2016
#  Last Edited: 10/10/2016, Radhakrishnan Rk
#  Description: Bash script to set secured password for linux user 
#  Usage      : bash chpassword.sh --username krishnaa --minlength 16 --maxlength 16
########################################################################################


ARGS=$(getopt -o a:b:c -l "username:,minlength:,maxlength:" -- "$@");
eval set -- "$ARGS";
while true; do
case "$1" in

-a|--username)
shift;
if [ -n "$1" ]; then
username=$1;
shift;
fi
;;

-b|--minlength)
shift;
if [ -n "$1" ]; then
minlength=$1;
shift;
fi
;;

-b|--maxlength)
shift;
if [ -n "$1" ]; then
maxlength=$1;
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
	apt-get install apg
    a=$(apg -a 1 -n 1 -M sncl -m $minlength -x $maxlength)
	echo $a
	echo ''$username':'$a'' | chpasswd
else
	cd /tmp
	yum install epel-release -y
	yum install wget -y
	wget ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/csbuild/CentOS_CentOS-6/x86_64/apg-2.3.0b-5.1.x86_64.rpm
	rpm -i /tmp/apg-2.3.0b-5.1.x86_64.rpm
	a=$(apg -a 1 -n 1 -M sncl -m 16 -x 16)
	echo $a
	echo ''$username':'$a'' | chpasswd
fi
