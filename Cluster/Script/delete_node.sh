#!/bin/bash

# check for root
[[ ${EUID} -ne 0 ]] && echo "::This script must be run as root::" && exit 1


read -p "Enter the node name: " node

ip=$(cat ./hosts | grep "$node "  | awk '{print $1;}')
nod=$(cat ./hosts | grep "$node " | awk '{print $2;}')



echo "Warning!! Following node will be deleted!!"

echo -n
echo "Node: $nod ; IP: $ip"
read -p "Want to proceed? [y/n]: " confirm


if [ "$confirm" == "y" ]; then
		sed -i "/$nod /d" hosts
		sed -i "/$nod /d" node.conf
	fi

echo "$nod deleted successfully!!"
