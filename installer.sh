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

if [[ $OS == "Ubuntu" || $OS == "Debian" ]]; then
	sudo apt-get update
	sudo apt-get -y install software-properties-common python3-pip python3-distro ca-certificates wget

	pip3 install pyOpenSSL --upgrade

	mkdir -p /opt/fastcp
	cd /opt/fastcp

	sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
	sudo debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
	sudo wget -nv -O /usr/bin/fastcp-updater https://raw.githubusercontent.com/FastCP/Installer/master/fastcp-updater.py
	sudo chmod +x /usr/bin/fastcp-updater
	sudo wget -nv -O fastcp-installer https://raw.githubusercontent.com/FastCP/Installer/master/fastcp-installer.py
	sudo chmod +x fastcp-installer
	sudo ./fastcp-installer
else
	echo "FastCP is currently only usable with Debian or Ubuntu. The installer will now exit"
	exit
fi
