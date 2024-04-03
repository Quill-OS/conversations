#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/bin/fbink

trap '' INT TSTP

DATE=$(cat /proc/version | grep -o '...........................$' | cut -c 1-9)
YEAR=$(cat /proc/version | grep -o '...........................$' | cut -c24-)
BUILDTIME="$DATE $YEAR"
HEADERMESSAGE1="*** InkBox system diagnostics ***"
HEADERMESSAGE2="Version 1.0, built $BUILDTIME"

SELECT1=0
SELECT2=0
SELECT3=0
SELECT4=0
SELECT5=0
SELECT6=0
SELECT7=0
SELECT8=0

USELECT1=0
USELECT2=0
USELECT3=0

STR1="1 - System Info"
STR2="2 - Battery Info"
STR3="3 - Graphics test"
STR4="4 - Sleep mode test"
STR5="5 - Utilities"
STR6="6 - Reboot"
STR7="7 - Power off"
STR8="8 - Exit to shell"

USTR1="1 - Flash kernel to MMC"
USTR2="2 - Flash U-Boot to MMC"
USTR3="3 - Erase MMC"

print_menu_fbink() {
	X=2
	Y1=7
	Y2=10
	Y3=13
	Y4=16
	Y5=19
	Y6=22
	Y7=25
	Y8=28
	if [ $SELECT1 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $Y1 -x $X -S 0 "$STR1"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y1 -x $X -S 0 -h "$STR1"
	fi

	if [ $SELECT2 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $Y2 -x $X -S 0 "$STR2"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y2 -x $X -S 0 -h "$STR2"
	fi

	if [ $SELECT3 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $Y3 -x $X -S 0 "$STR3"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y3 -x $X -S 0 -h "$STR3"
	fi

	if [ $SELECT4 != 1 ]; then
                /opt/bin/fbink/fbink -q -F THIN -y $Y4 -x $X -S 0 "$STR4"
        else
                /opt/bin/fbink/fbink -q -F THIN -y $Y4 -x $X -S 0 -h "$STR4"
        fi

	if [ $SELECT5 != 1 ]; then
                /opt/bin/fbink/fbink -q -F THIN -y $Y5 -x $X -S 0 "$STR5"
        else
                /opt/bin/fbink/fbink -q -F THIN -y $Y5 -x $X -S 0 -h "$STR5"
        fi

	if [ $SELECT6 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $Y6 -x $X -S 0 "$STR6"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y6 -x $X -S 0 -h "$STR6"
	fi

	if [ $SELECT7 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $Y7 -x $X -S 0 "$STR7"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y7 -x $X -S 0 -h "$STR7"
	fi

	if [ $SELECT8 != 1 ];then
		/opt/bin/fbink/fbink -q -F THIN -y $Y8 -x $X -S 0 "$STR8"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $Y8 -x $X -S 0 -h "$STR8"
	fi
}
print_utilities_header_fbink() {
	/opt/bin/fbink/fbink -k -f -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m	-y 2 -h "*** Utilities ***"
}
print_utilities_menu_fbink() {
	UX=2
	UY1=5
	UY2=8
	UY3=11
	if [ $USELECT1 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $UY1 -x $UX -S 0 "$USTR1"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $UY1 -x $UX -S 0 "$USTR1"
	fi

	if [ $USELECT2 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $UY2 -x $UX -S 0 "$USTR2"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $UY2 -x $UX -S 0 "$USTR2"
	fi

	if [ $USELECT3 != 1 ]; then
		/opt/bin/fbink/fbink -q -F THIN -y $UY3 -x $UX -S 0 "$USTR3"
	else
		/opt/bin/fbink/fbink -q -F THIN -y $UY3 -x $UX -S 0 "$USTR3"
	fi
}
print_menu() {
	echo
	echo "Available options:"
	echo "$STR1"
	echo "$STR2"
	echo "$STR3"
	echo "$STR4"
	echo "$STR5"
	echo "$STR6"
	echo "$STR7"
	echo "$STR8"
	echo
}
select_print_menu_fbink() {
	print_menu_fbink
	sleep 0.25
}
select_print_utilities_menu_fbink() {
	print_utilities_menu_fbink
	sleep 0.256
}
get_system_info() {
	KERNEL=$(uname -r)
	DEVICE=$(cat /opt/device)
	DEVICESTATUS=$(dd if=/dev/mmcblk0 bs=512 skip=79872 count=1 status=none | head -c6)
	FWVERSION=$(cat /opt/inkbox-version)
	DATE=$(date)
	TOTALRAM=$(cat /proc/meminfo | sed -n '1p')
	FREERAM=$(cat /proc/meminfo | sed -n '2p')
	ARCH=$(uname -m)

	if [ "$DEVICESTATUS" == "rooted" ]; then
		DEVICESTATUS="Rooted"
	else
		DEVICESTATUS="Locked down"
	fi
}
get_battery() {
	BATLEVEL=$(cat /sys/devices/platform/pmic_battery.1/power_supply/mc13892_bat/capacity)
	BATSTATUS=$(cat /sys/devices/platform/pmic_battery.1/power_supply/mc13892_bat/status)
}
graphics_test() {
	if [ "$1" == "grayscale" ]; then
		/opt/bin/fbink/fbink -k -f -q
		/opt/bin/fbink/fbink -q -g file=/opt/images/grayscale.png
	fi
}
STR1_CMD() {
	get_system_info
	echo "---- General info ----"
	echo "Kernel version: $KERNEL"
	echo "Device: $DEVICE"
	echo "Status: $DEVICESTATUS"
	echo "F/W version: $FWVERSION"
	echo "Time: $DATE"
	echo "---- Memory info ----"
	echo "$TOTALRAM"
	echo "$FREERAM"
	echo "---- Processor info ----"
	echo "Architecture: $ARCH"
	option_page "$STR1" "sysinfo"
	wait_cmd
}
STR2_CMD() {
	get_battery
	echo "Battery status: $BATSTATUS"
	echo "Battery level: $BATLEVEL%"
	option_page "$STR2" "battery"
	wait_cmd
}
STR3_CMD() {
	GRAPHICS_TEST1=0
	GRAPHICS_TEST2=0
	graphics_test grayscale
	while true; do
		echo -n "Is the gray scale displayed properly? (Y/N) "; read GTEST1Y
		if [ "$GTEST1Y" == "Y" ]; then
			GRAPHICS_TEST1=1
			break
		elif [ "$GTEST1Y" == "N" ]; then
			GRAPHICS_TEST1=0
			break
		else
			echo "Please enter 'Y' or 'N'."
		fi
	done

	if [ $GRAPHICS_TEST1 == 1 ]; then
		GRAPHICS_TEST1="PASS"
	else
		GRAPHICS_TEST1="FAIL"
	fi

	echo "Test summary:"
	echo "Gray scale: $GRAPHICS_TEST1"
	option_page "$STR3" "graphics"
	wait_cmd
}
STR5_CMD() {
	echo "Entering Utilities subsystem ..."
	utilities
}
STR6_CMD() {
	echo "Rebooting ..."
	/opt/bin/fbink/fbink -k -f -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m -M "Rebooting"
	busybox reboot
	exit 0
}
STR7_CMD() {
	echo "Shutting down ..."
	/opt/bin/fbink/fbink -k -f -h -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m -M -h "Powered off"
	busybox poweroff
	exit 0
}
STR8_CMD() {
	echo "---- Exited to shell ----"
	option_page "$STR6" "shell"
	wait_cmd from_shell
}
USTR1_CMD() {
	echo "An XMODEM receiver is now listening on the serial port. Please send the file now, and strike CTRL+D when finished."
	uoption_page "$USTR1" "download_kernel"
}
option_page() {
	/opt/bin/fbink/fbink -k -f -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 3 -h "$(echo $1 | cut -c5-)"
	if [ "$2" == "sysinfo" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 7 "———— General info ————"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 10 "Kernel version: $KERNEL"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 13 "Device: $DEVICE"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 16 "Status: $DEVICESTATUS"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 19 "F/W version: $FWVERSION"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 22 "Time: $DATE"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 25 "———— Memory info ————"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 28 "$TOTALRAM"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 31 "$FREERAM"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 34 "———— Processor info ————"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 37 "Architecture: $ARCH"
	elif [ "$2" == "battery" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 7 "Battery status: $BATSTATUS"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 10 "Battery level: $BATLEVEL%"
	elif [ "$2" == "graphics" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 7 "Test summary:"
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 10 "Gray scale: $GRAPHICS_TEST1"
	elif [ "$2" == "shell" ]; then
		/opt/bin/fbink/fbink -k -f -h -q
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -M -h "———— Exited to shell ————"
		/bin/sh
	fi
}
uoption_page() {
	/opt/bin/fbink/fbink -k -f -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 3 -h "$(echo $1 | cut -c5-)"
	if [ "$2" == "download_kernel" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 5 "XMODEM receiver listening on serial port ..."
	elif [ "$2" == "download_u-boot" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 5 "XMODEM receiver listening on serial port ..."
	elif [ "$2" == "erase_mmc" ]; then
		/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 5 "Are you sure?"
	fi
}
utilities() {
	USELECT1=0
	USELECT2=0
	USELECT3=0

	print_utilities_header_fbink
	print_utilities_menu_fbink
	while true; do
		echo -n "Utilities => "; read UCMD
		if [ "$UCMD" == "1" ]; then
			USELECT1=1
			select_print_utilities_menu_fbink
			USTR1_CMD
		elif [ "$UCMD" == "2" ]; then
			USELECT2=1
			select_print_utilities_menu_fbink
			USTR2_CMD
		elif [ "$UCMD" == "3" ]; then
			USELECT3=1
			select_print_utilities_menu_fbink
			USTR3_CMD
		fi
	done
}
wait_cmd() {
	SELECT1=0
	SELECT2=0
	SELECT3=0
	SELECT4=0
	SELECT5=0
	SELECT6=0
	SELECT7=0
	SELECT8=0
	if [ "$1" != "from_shell" ]; then
		echo -n "< OK > "; read -n 1
		/opt/bin/fbink/fbink -k -f -q
	else
		:
	fi
	print_header_fbink
	print_menu_fbink
}
print_header_fbink() {
	/opt/bin/fbink/fbink -k -f -q
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m	-y 2 -h "$HEADERMESSAGE1"
	/opt/bin/fbink/fbink -q -F THIN -S 0 -m -y 4 "$HEADERMESSAGE2"
}

print_header_fbink
print_menu_fbink

echo "$HEADERMESSAGE1"
echo "$HEADERMESSAGE2"

print_menu

while true; do
	SELECT1=0
	SELECT2=0
	SELECT3=0
	SELECT4=0
	SELECT5=0
	SELECT6=0
	SELECT7=0
	SELECT8=0

	echo -n "Diagnostics => "; read CMD
	if [ "$CMD" == "1" ]; then
		SELECT1=1
		select_print_menu_fbink
		STR1_CMD
	elif [ "$CMD" == "2" ]; then
		SELECT2=1
		select_print_menu_fbink
		STR2_CMD
	elif [ "$CMD" == "3" ]; then
		SELECT3=1
		select_print_menu_fbink
		STR3_CMD
	elif [ "$CMD" == "4" ]; then
		SELECT4=1
		select_print_menu_fbink
		STR4_CMD
	elif [ "$CMD" == "5" ]; then
		SELECT5=1
		select_print_menu_fbink
		STR5_CMD
	elif [ "$CMD" == "6" ]; then
		SELECT6=1
		select_print_menu_fbink
		STR6_CMD
	elif [ "$CMD" == "7" ]; then
		SELECT7=1
		select_print_menu_fbink
		STR7_CMD
	elif [ "$CMD" == "8" ]; then
		SELECT8=1
		select_print_menu_fbink
		STR8_CMD
	elif [ "$CMD" == "?" ] || [ "$CMD" == "help" ]; then
		print_header_fbink
		print_menu_fbink
		print_menu
	elif [ "$CMD" == "" ]; then
		:
	else
		echo "Error: command not found: $CMD"
	fi
done