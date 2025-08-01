#!/bin/bash

# network-info.sh
# Displays useful networking details for the local system

# Author: abg1122

echo "=== Hostname and IP Info ==="
hostname
hostname -I

echo -e "\n=== Default Gateway ==="
ip route | grep default

echo -e "\n=== DNS Servers ==="
grep "nameserver" /etc/resolv.conf

echo -e "\n=== Active Network Interfaces ==="
ip -brief address show up

echo -e "\n=== Open TCP/UDP Ports (Listening) ==="
ss -tuln | grep LISTEN

echo -e "\n=== Active TCP Connections ==="
ss -tuna | grep ESTAB

echo -e "\n=== External IP Address ==="
curl -s ifconfig.me || wget -qO- ifconfig.me

echo -e "\n=== MAC Addresses ==="
ip link show | awk '/link\/ether/ {print $2}'
