#!/bin/bash

# check for root
[[ ${EUID} -ne 0 ]] && echo "::This script must be run as root::" && exit 1


read -p "Enter the node name: " node

if ! grep -q "$node " "/etc/hosts"; then
    echo "Node not found. Please try again!!"
    exit 1
fi

ip=$(cat /etc/hosts | grep "$node "  | awk '{print $1;}')
nod=$(cat /etc/hosts | grep "$node " | awk '{print $2;}')



echo "Warning!! Following node will be deleted!!"

echo "Node: $nod ; IP: $ip"
read -p "Want to proceed? [y/n]: " confirm


if [ "$confirm" == "y" ]; then
    sed -i "/$nod /d" /etc/hosts
    sed -i "/$ip /d" /etc/dnsmasq.conf
    sed -i "/$nod /d" /home/nlocluster/node.conf
    echo "$nod deleted successfully!!"
else
    echo "Node not deleted. Please try again!!"
fi

