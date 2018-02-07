#!/bin/sh


################################## TO-DO LIST #################################################
#   1. Sort /etc/hosts file after ADD/DELETE node
#
#
###############################################################################################


# check for root
[[ ${EUID} -ne 0 ]] && echo "::This script must be run as root::" && exit 1

#ask for ip address

#read -p "Enter Network Getaway: " ip_search  ##Problem ask every time you add node##

#add a variable in nmap
ip_search=192.168.0.0

########### Generate ip_match ###############################

A="$(cut -d'.' -f1 <<<"$ip_search")"
B="$(cut -d'.' -f2 <<<"$ip_search")"

ip_match="$A.$B"

################################################################

#################### Grab IP & MAC Adress ######################

ip=$(nmap -sP $ip_search/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " "$3;}' | sort | grep $ip_match | head -1 | awk '{print $1;}')


mac=$(nmap -sP $ip_search/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " "$3;}' | sort | grep $ip_match | head -1 | awk '{print $2;}')

###############################################################

######### Check for Available Node #############################

i=1

while :
do
	if grep -q "node$i " "/etc/hosts"; then
		i=`expr $i + 1` #Increament for loop
		#echo "Found!!"  #Uncomment for debug
	else
		#echo "Not Found!!" #Uncomment for debug
		break
	fi
done


node_avail="node$i"

################################################################



if [ ! "$mac" ] && [ ! "$ip" ]; then
	echo "No device or node found!"
elif [ ! "$mac" ]; then
	echo "$ip master" >> /etc/hosts
	read -p "Master Found! Add master to node.conf?[y/n]: " master
	if [ "$master" == "y" ]; then
		echo "master" >> /home/nlocluster/node.conf
	fi
else
	#suggest default node name
	echo "Found: IP = $ip ; MAC = $mac"
	read -p "Enter the node name[Default: $node_avail]: " node
	if [ ! "$node" ]; then
		node="$node_avail"
	elif grep -q "$node " "/etc/hosts"; then
		echo "Node name not available. Please try again!!"
		exit 1
	fi
	echo "$ip $node " >> /etc/hosts
	echo "dhcp-host=$mac,$ip " >> /etc/dnsmasq.conf
	echo "$node " >> /home/nlocluster/node.conf  ## Adding node in the machine file
fi




