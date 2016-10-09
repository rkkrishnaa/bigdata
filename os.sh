#!/bin/bash
##############################################################
#  Title      : os.sh
#  Author     : Radhakrishnan Rk
#  Date       : 10/10/2016
#  Last Edited: 10/10/2016, Radhakrishnan Rk
#  Description: Bash script to determine os distribution
#               and release version
#  Usage      : bash os.sh
##############################################################
if [ -f /etc/redhat-release ]; then
DISTRO=$(awk '{print $1}' /etc/redhat-release)
VERSION=$(awk '{print $3}' /etc/redhat-release)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
    VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//' | sed 's/[.]0/./')
fi
echo  $DISTRO
echo  $VERSION
