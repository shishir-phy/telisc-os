#!/bin/bash

stat2=$(sinfo | grep down)

while :
do
	stat1=$(sinfo | grep down )
	
	if [ ! -z "$stat1" ]; then 
		if [ "$stat1" == "$stat2" ]; then
			sleep 5
			continue
		fi
		echo "Down!!!"
		echo "$stat1"
		python /home/shishir/send_email.py sakib0202@gmail.com,mjonyh@gmail.com,shafayetrahat@gmail.com "Do not Reply: Node Down" "$stat1"
		sleep 1800
	else
		if [ ! -z "$stat2" ]; then
			python /home/shishir/send_email.py sakib0202@gmail.com,mjonyh@gmail.com,shafayetrahat@gmail.com "Do not Reply: Node Down Solved" "Solved State: $stat2"
		fi
		echo "Not Down!!!"
	fi
	stat2="$stat1"
	sleep 5
done


# grep status
# if not down sleep 5 recheck
# if down check change in grep
# if check positive mail
# else sleep 5 recheck
