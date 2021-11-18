#!/bin/bash

# this script do the installation of rsyslog for clients

# #################################
#                                 #
#       Adam d Autheville         #
#  B2 Informatique Ynov Bordeaux  #
#      18/11/2021                 #
# #################################

# Instalation of Rsyslog
dnf install -y rsyslog

# read the valeu of IP
echo "Please enter the IP of server"
read IPserver

# for give the logs to the server
echo '*.*                       @'$IPserver':514' >> /etc/rsyslog.conf

# restart the service rsyslog
systemctl restart rsyslog
systemctl enable rsyslog

# Firewall rules
firewall-cmd --add-port=514/udp
firewall-cmd --add-port=514/udp

# message
echo "script complete !"
