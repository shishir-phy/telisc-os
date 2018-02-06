#!/bin/bash

# check for root
[[ ${EUID} -ne 0 ]] && echo "::This script must be run as root::" && exit 1


read -p "Enter the node name: " node

read -p "Warning!! Node: $node will be deleted! Want to proceed?[y/n]" confirm

if [ "$confirm" == "y" ]; then
		sed -i "/$node/d" /etc/hosts
	fi

