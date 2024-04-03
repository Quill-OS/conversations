#!/bin/bash 
# This file fixes suspend issues related with touch on the kobo nia

LOCKSCREEN=$(cat /opt/config/12-lockscreen/config 2>/dev/null)

kill -CONT $(pidof inkbox-bin 2>/dev/null) 2>/dev/null
kill -CONT $(pidof oobe-inkbox-bin 2>/dev/null) 2>/dev/null
kill -CONT $(pidof calculator-bin 2>/dev/null) 2>/dev/null
kill -CONT $(pidof scribble 2>/dev/null) 2>/dev/null
kill -CONT $(pidof lightmaps 2>/dev/null) 2>/dev/null
kill -CONT $(pidof qreversi-bin 2>/dev/null) 2>/dev/null
kill -CONT $(pidof 2048-bin 2>/dev/null) 2>/dev/null

sleep 2

if [ "${LOCKSCREEN}" == "true" ]; then
	killall -q inkbox-bin
	killall -q oobe-inkbox-bin
	killall -q lockscreen-bin
	killall -q calculator-bin
	killall -q qreversi-bin
	killall -q 2048-bin
	killall -q scribble
	killall -q lightmaps
else
	kill -STOP $(pidof inkbox-bin 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof oobe-inkbox-bin 2>/dev/null) 2>/dev/null
	kill -9 $(pidof lockscreen-bin 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof calculator-bin 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof scribble 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof lightmaps 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof qreversi-bin 2>/dev/null) 2>/dev/null
	kill -STOP $(pidof 2048-bin 2>/dev/null) 2>/dev/null
fi

sleep 1
