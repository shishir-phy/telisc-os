#!/bin/bash

dup_autolock=$(ps -u $USER | grep "autolock.sh" | wc -l)

[[ $dup_autolock -gt 2 ]] && echo "Process already running." && exit 1

while :
do
    stt=$(cat /proc/asound/card*/pcm*/sub*/status | grep RUNNING | awk '{print $2;}')

    echo "$stt"
    if [ ! -z "$stt" ]; then
        date >> /tmp/autolock_log.txt
        echo "RUNNING" >> /tmp/autolock_log.txt
        pkill xautolock
    else
        date >> /tmp/autolock_log.txt
        echo "CLOSED" >> /tmp/autolock_log.txt
        if [ ! $(pidof xautolock) ]; then
            xautolock -time $1 -locker lock &
        fi
    fi
    sleep 3

done
