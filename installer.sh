#!/bin/bash


##################################################################################################
#
#	FastCP Installer
#	License: MIT
#	Website: https://github.com/FastCP/Installer
#	Issues: https://github.com/FastCP/Installer/issues
#	Version: 0.0.1
# 
#
##################################################################################################

##################################################################################################
#
# Variables

HOSTNAME=$(uname -n)
OS=$(lsb_release -d | awk -F"\t" '{print $2}' | awk -F" " '{print $1}')

##################################################################################################

if [ "$EUID" -ne 0 ]
	then echo "This script must be run as root"
	exit
fi

if [[ $OS == "Ubuntu" || $OS == "Debian" ]]; then
	apt-get update
	apt-get -y install software-properties-common python3-pip python3-distro ca-certificates wget

	pip3 install pyOpenSSL --upgrade

	mkdir -p /opt/fastcp
	cd /opt/fastcp

	debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
	debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
	wget -nv -O /usr/bin/fastcp-updater https://raw.githubusercontent.com/FastCP/Installer/master/fastcp-updater.py
	chmod +x /usr/bin/fastcp-updater
	wget -nv -O fastcp-installer https://raw.githubusercontent.com/FastCP/Installer/master/fastcp-installer.py
	chmod +x fastcp-installer
	./fastcp-installer
else
	echo "FastCP is currently only usable with Debian or Ubuntu. The installer will now exit"
	exit
fi
