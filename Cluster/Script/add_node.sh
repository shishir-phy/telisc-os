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
ip_search=10.100.163.0

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
	if grep -q "node$i X" "hosts"; then
		i=`expr $i + 1` #Increament for loop
		#echo "Found!!"  #Uncomment for debug
	else
		#echo "Not Found!!" #Uncomment for debug
		break
	fi
done


node="node$i"

################################################################



if [ ! "$mac" ] && [ ! "$ip" ]; then
	echo "No device or node found!"
elif [ ! "$mac" ]; then
	echo "$ip master" >> /etc/hosts
	read -p "Master Found! Add master to node.conf?[y/n]: " master
	if [ "$master" == "y" ]; then
		echo "master" >> ~/node.conf
	fi
else
	#suggest default node name
	echo "Found: IP = $ip ; MAC = $mac"
	read -p "Enter the node number[Available: $node]: " node
	echo "$ip $node X" >> hosts
	#/etc/dnsmasq.conf
	echo "$node X" >> node.conf  ## Adding node in the machine file
fi




