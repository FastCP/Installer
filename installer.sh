#!/bin/bash

while [ ! -z "`ps -e | grep 'apt\|dpkg'`" ]; do echo "Waiting for apt or dpkg to exit."; sleep 6; done && \
sudo apt-get update && sudo apt-get -y install software-properties-common python3-pip python3-distro ca-certificates wget && \
pip3 install pyOpenSSL --upgrade && \
cd /home && \
HOSTNAME=$(uname -n) && \
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'" && \
sudo debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME" && \
sudo wget -nv -O /usr/bin/fastcp-updater https://fastcp.org/fastcp-updater.py && \
sudo chmod +x /usr/bin/fastcp-updater && \
sudo wget -nv -O fastcp-installer https://fastcp.org/installer.py && \
sudo chmod +x fastcp-installer && sudo bash fastcp-installer