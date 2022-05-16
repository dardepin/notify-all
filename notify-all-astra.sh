#!/bin/bash

PATH=/usr/bin:/bin
USERS=($(who|grep -E ":[0-9](\.[0-9])* "|awk '{print $1$2}'|sort -u))

for USER in "${USERS[@]}"; do
    #echo $USER
    NAME="$(cut -d':' -f1 <<< $USER)"
    DISP="$(cut -d':' -f2 <<< $USER)"
    #echo "username: $NAME, dsplay:$DISP"
    SESSIONS=$(sudo find /home/$NAME*/.dbus/session-bus/ -name '*' -type f)
    for SESSION in "${SESSIONS[@]}"; do
        #echo $SESSION
        BUS_ADDRESS=$(sudo egrep "BUS_SESSION_BUS_ADDRESS=" $SESSION | cut -d"'" -f 2 | cut -d"," -f 1)
        #echo $BUS_ADDRESS
        sudo -u ${NAME} DISPLAY=:${DISP} DBUS_SESSION_BUS_ADDRESS=${BUS_ADDRESS} PATH=${PATH} notify-send "$@"
    done
done