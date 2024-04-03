#!/bin/sh

export GLOBAL_TAR=`ls /kobo/mnt/onboard/onboard/.inkbox/inkbox-*.tar.xz 2>/dev/null`
export CAN_REALLY_UPDATE=`cat /kobo/mnt/onboard/onboard/.inkbox/can_really_update 2>/dev/null`
export TAR=`ls /kobo/mnt/onboard/onboard/.inkbox/*.tar.xz 2>/dev/null`
export ROOT=`cat /opt/root/rooted 2>/dev/null`
export ALLOW_DOWNGRADE=`cat /boot/flags/ALLOW_DOWNGRADE 2>/dev/null`

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
			rm "$TAR_UPDATE" 2>/dev/null
			rm "$TAR" 2>/dev/null

			mkdir -p /tmp/origin
			UP_DATE=`date +%s` mkdir -p /tmp/update-$UP_DATE

			mount /opt/update/update.isa /tmp/origin
			mount /kobo/mnt/onboard/onboard/.inkbox/update.isa /tmp/update-$UP_DATE
			VERSION=`cat /tmp/origin/version`
			UPDATE_VERSION=`cat /tmp/update-$UP_DATE/version`

			umount -l -f /tmp/origin
			umount -l -f /tmp/update-$UP_DATE

			ILLEGAL_DOWNGRADE=`echo $UPDATE_VERSION'<'$VERSION | bc -l`

			if [ "$ILLEGAL_DOWNGRADE" == "1" ]; then
				if [ "$ROOT" == "true" ]; then
					if [ "$ALLOW_DOWNGRADE" == "true" ]; then
						echo "Downgrading from InkBox $VERSION to InkBox $UPDATE_VERSION ..."
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
						exit 0
					else
						echo "true" > /boot/flags/ALERT
						echo "true" > /boot/flags/ALERT_DOWNGRADE
						sync
						echo "Attempted to downgrade InkBox! Aborting update ..."
						rm -rf /kobo/mnt/onboard/onboard/.inkbox
						mkdir -p /kobo/mnt/onboard/onboard/.inkbox
						killall update-splash
						sync
						exit 0
					fi
				else
					echo "true" > /boot/flags/ALERT
					echo "true" > /boot/flags/ALERT_DOWNGRADE
					sync
					echo "Attempted to downgrade InkBox! Aborting update ..."
					rm -rf /kobo/mnt/onboard/onboard/.inkbox
					mkdir -p /kobo/mnt/onboard/onboard/.inkbox
					killall update-splash
					sync
					exit 0
				fi
			else
				echo "Upgrading InkBox $VERSION to InkBox $UPDATE_VERSION ..."
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
				exit 0
			fi
		else
			echo "Invalid signature! Aborting update ..."
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
			exit 0
		fi
	else
		echo "Update skipped or no update available."
		echo "false" > /opt/update/inkbox_updated
		exit 0
	fi
fi
