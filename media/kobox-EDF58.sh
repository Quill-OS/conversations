#!/bin/sh

# KoBox launcher
# Nicolas Mailloux, 2021.
#
# Set of commands to launch X.org with OpenBox WM and Mate-Panel.

# Bringing the lo interface up for various programs that need it (e.g. Python3-IDLE)
ifconfig lo up

# Launching X
export HOME=/root
X -dpi 200 &
cd /root/.utils/fbink-xdamage
sleep 3
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.utils/fbink-xdamage/FBInk/Release/; env DISPLAY=:0 ./fbink_xdamage &
sleep 3
cd /root/.utils

DISPLAY=:0 python3 /root/.utils/xorg-kobo-touch.py &

cd /root

# Apps
DISPLAY=:0 xterm -e "/root/.utils/dpi.sh"
sleep 3
DISPLAY=:0 openbox &
DISPLAY=:0 mate-panel &
DISPLAY=:0 onboard -s 1440x460 &
