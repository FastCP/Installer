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

echo "Please enter your Hostname of desire:" 

read HOSTNAME

if [ "$HOSTNAME" == "" ]; 
	then
		HOSTNAME=`uname -n`
fi

# Changing your Hostname to desired one
hostnamectl set-hostname $HOSTNAME

echo "Your Hostname of desire is now set to `uname -n`"

# Getting first variable from the operation system
OS=`lsb_release -d | awk -F"\t" '{print $2}' | awk -F" " '{print $1}'`

if [[ $OS == "Ubuntu" || $OS == "Debian" ]]; then
    # Update and Upgrade the system
    apt update && apt upgrade -y

    # Install vital packages
    apt install software-properties-common ca-certificates wget git openssl python3-pip python3-distro -y

    # Create directory
    mkdir -p /opt/fastcpplus

    # Change to the newly created directory
    cd /opt/fastcpplus

    # Settings debian config for unattended installations
    debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
    debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

    # Downloading core installer
    CORE_INSTALLER_FILE=install-core.sh
    WGET_CORE_INSTALL=https://github.com/FastCP/Installer/blob/master/install-core.sh
    if [ -f $CORE_INSTALLER_FILE ]; 
        then
            echo "######################################"
            echo "### Core installer is already here ###"
            echo "######################################"
        else
            echo "##################################"
            echo "### Downloading core installer ###"
            echo "##################################"
            loading
            wget https://github.com/FastCP/Installer/blob/master/install-core.sh
    fi

    # Give executable permissions
    echo "### Changing permissions install-core.sh"
    chmod +x install-core.sh

    # Run the bash script
    ./install-core
else
    echo "################################## FastCP+ ###################################"
    echo "### Unable to start installation, your system do not meet the requirements ###"
    echo "##############################################################################"
    exit
fi
