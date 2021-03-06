#!/bin/bash

useradd -G wheel j

##Setting IP
echo "IPADDR=172.16.150.7" >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "PREFIX=29" >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "GATEWAY=172.16.150.2" >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "DNS1=172.16.150.2" >> /etc/sysconfig/network-scripts/ifcfg-ens192
systemctl restart network.service

## Adding Firewall port 514 for syslog
firewall-cmd --add-port 514/udp --permanent
firewall-cmd --reload

## Setting up logging


wget -c -P /etc/rsyslog.d/ http://10.0.17.100/sec350-SP19/03-sec350.conf
systemctl restart rsyslog

echo "Remember to set a password for j"
