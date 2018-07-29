#!/bin/bash

stat2=$(sinfo | grep 'drain\* ')

while :
do
	stat1=$(sinfo | grep 'drain\* ' )
	#echo "State one: $stat1"
	
	if [ ! -z "$stat1" ]; then 
		if [ "$stat1" == "$stat2" ]; then
			sleep 5
			continue
		fi
		#echo "Down!!!"
		echo "Mail sent: $stat1"
		#python /home/shishir/send_email.py sakib0202@gmail.com,mjonyh@gmail.com,shafayetrahat@gmail.com "Do not Reply: Node Down" "$stat1"
	else
		if [ ! -z $stat2 ]; then
			echo "Mail sent: $stat2"
			#python /home/shishir/send_email.py sakib0202@gmail.com,mjonyh@gmail.com,shafayetrahat@gmail.com "Do not Reply: Node Down Solved" "Solved State: $stat2"
		fi
		#echo "Not Down!!!"
	fi
	stat2="$stat1"
	sleep 5
done


# grep status
# if not down sleep 5 recheck
# if down check change in grep
# if check positive mail
# else sleep 5 recheck
