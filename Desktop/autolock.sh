#!/bin/bash

while :
do
    stt=$(cat /proc/asound/card*/pcm*/sub*/status | grep RUNNING | awk '{print $2;}')

    echo "$stt"
    if [ ! -z "$stt" ]; then
        echo "RUNNING"
        pkill xautolock
    else
        echo "CLOSED"
        if [ ! $(pidof xautolock) ]; then
            xautolock -time $1 -locker lock &
        fi
    fi
    sleep 3

done
