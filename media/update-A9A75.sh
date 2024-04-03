#!/bin/sh

export GLOBAL_TAR=`ls /kobo/mnt/onboard/onboard/.inkbox/inkbox-*.tar.xz 2> /dev/null`
export CAN_REALLY_UPDATE=`cat /kobo/mnt/onboard/onboard/.inkbox/can_really_update 2> /dev/null`
export TAR=`ls /kobo/mnt/onboard/onboard/.inkbox/*.tar.xz 2> /dev/null`

if [ "$GLOBAL_TAR" != "" ]; then
	export CAN_UPDATE="true"
	echo "true" > /kobo/mnt/onboard/onboard/.inkbox/can_update
else
	export CAN_UPDATE="false"
	echo "false" > /kobo/mnt/onboard/onboard/.inkbox/can_update
fi

if [ "$CAN_UPDATE" = "true" ]; then
	if [ "$CAN_REALLY_UPDATE" == "true" ]; then
		cd /tmp
		tar -xvf "$TAR"
		export TAR_UPDATE=`ls /tmp/*.tar.xz`
		openssl dgst -sha256 -verify /opt/key/public.pem -signature dgst "$TAR_UPDATE"
		if [ $? == 0 ]; then
			cd /kobo/mnt/onboard/onboard/.inkbox/
			rm *.tar.xz
			tar -xf "$TAR_UPDATE"
			sync
			rm "$TAR_UPDATE"
			rm "$TAR"
			mv /kobo/mnt/onboard/onboard/.inkbox/update.isa /opt/update
			sync
			rm /kobo/mnt/onboard/onboard/.inkbox/can_update
			rm /kobo/mnt/onboard/onboard/.inkbox/can_really_update
			rm /opt/update/will_update
			echo "true" > /opt/update/inkbox_updated
			echo "false" > /boot/flags/WILL_UPDATE
			echo "false" > /opt/update/will_update
			killall update-splash
			sync
		else
			echo "Invalid signature! Aborting update..."
			echo "true" > /boot/flags/ALERT
			echo "true" > /boot/flags/ALERT_SIGN
			echo "false" > /opt/update/inkbox_updated
			echo "false" > /boot/flags/WILL_UPDATE
			echo "false" > /opt/update/will_update
			rm "$TAR"
			rm "$TAR_UPDATE"
			rm /kobo/mnt/onboard/onboard/.inkbox/can_*
			killall update-splash
			sync
		fi
	else
		echo "Update skipped or no update available."
		echo "false" > /opt/update/inkbox_updated
	fi
fi
