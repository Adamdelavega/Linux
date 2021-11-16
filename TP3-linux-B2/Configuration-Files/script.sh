#!/bin/bash

# #################################
#                                 #
#       Adam d Autheville         #
#  B2 Informatique Ynov Bordeaux  #
#                                 #
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
