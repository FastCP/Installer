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

echo "### Welcome to the FastCP+ install ###"
echo "Please enter your Hostname of desire:" 

read HOSTNAME

if [ "$HOSTNAME" == "" ]; 
	then
		HOSTNAME=`uname -n`
fi

echo "Your Hostname of desire is now set to $HOSTNAME"

# Getting first variable from the operation system
OS=`lsb_release -d | awk -F"\t" '{print $2}' | awk -F" " '{print $1}'`

# Check if the script is executed as root
if [ "$EUID" -ne 0 ]; 
	then 
    	echo "################ FastCP+ ##################"
    	echo "### You need to run this script as root ###"
    	echo "###########################################"
    exit
else
    echo "######################### FastCP+ #############################"
    echo "### We are going to prepare the installation on your system ###"
    echo "###############################################################"
fi

if [[ $OS == "Ubuntu" || $OS == "Debian" ]]; then
    # Update and Upgrade the system
    apt update && apt upgrade -y

    # Install vital packages
    apt install software-properties-common ca-certificates wget git openssl-server python3-pip python3-distro -y

    # Create directory
    mkdir -p /opt/fastcpplus

    # Change to the newly created directory
    cd /opt/fastcpplus

    # Settings debian config for unattended installations
    debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
    debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

    # Downloading core installer
    wget https://github.com/FastCP/Installer/blob/master/install-core.sh
    
    # Give executable permissions
    chmod +x install-core.sh

    # Run the bash script
    ./install-core
else
    echo "################################## FastCP+ ###################################"
    echo "### Unable to start installation, your system do not meet the requirements ###"
    echo "##############################################################################"
    exit
fi
