#!/bin/sh

DARK_MODE=`cat /kobo/mnt/onboard/.adds/inkbox/.config/10-dark_mode/config`
LOCKSCREEN=`cat /kobo/mnt/onboard/.adds/inkbox/.config/12-lockscreen/config`
DEVICE=`cat /opt/inkbox_device`

rc-service sleep_standby stop
# Race condition
sleep 10
echo "1" > /sys/power/state-extended
echo "mem" > /sys/power/state
echo "false" > /tmp/sleep_mode

cinematic_brightness() {
	sleep 0.5
	SAVED_BRIGHTNESS=`cat /tmp/savedBrightness`
	/opt/bin/cinematic-brightness.sh "$SAVED_BRIGHTNESS" 0
}

if [ "$DARK_MODE" == "true" ]; then
	if [ "$LOCKSCREEN" == "true" ]; then
		chroot /kobo /mnt/onboard/.adds/inkbox/inkbox.sh lockscreen
	else
		/opt/bin/fbink/fbink -k -f -h
		/opt/bin/fbink/fbink -g file=/tmp/dump.png -h
		kill -CONT `pidof inkbox-bin`
		kill -CONT `pidof oobe-inkbox-bin`
		kill -CONT `pidof calculator-bin`
		kill -CONT `pidof scribble`
		kill -CONT `pidof lightmaps`
		cinematic_brightness
	fi
else
        if [ "$LOCKSCREEN" == "true" ]; then
                chroot /kobo /mnt/onboard/.adds/inkbox/inkbox.sh lockscreen
        else
		/opt/bin/fbink/fbink -k -f
		/opt/bin/fbink/fbink -g file=/tmp/dump.png
		kill -CONT `pidof inkbox-bin`
		kill -CONT `pidof oobe-inkbox-bin`
		kill -CONT `pidof calculator-bin`
		kill -CONT `pidof scribble`
		kill -CONT `pidof lightmaps`
		cinematic_brightness
	fi
fi

if [ "${DEVICE}" == "n873" ] || [ "${DEVICE}" == "n236" ] || [ "${DEVICE}" == "n306" ]; then
	WIFI_MODULE="/modules/wifi/8189fs.ko"
	SDIO_WIFI_PWR_MODULE="/modules/drivers/mmc/card/sdio_wifi_pwr.ko"
	WIFI_DEV="eth0"
elif [ "${DEVICE}" == "n705" ] || [ "${DEVICE}" == "n905b" ] || [ "${DEVICE}" == "n905c" ] || [ "${DEVICE}" == "n613" ]; then
	WIFI_MODULE="/modules/dhd.ko"
	SDIO_WIFI_PWR_MODULE="/modules/sdio_wifi_pwr.ko"
	WIFI_DEV="eth0"
elif [ "${DEVICE}" == "n437" ]; then
	WIFI_MODULE="/modules/wifi/bcmdhd.ko"
	SDIO_WIFI_PWR_MODULE="/modules/drivers/mmc/card/sdio_wifi_pwr.ko"
	WIFI_DEV="wlan0"
else
	WIFI_MODULE="/modules/dhd.ko"
	SDIO_WIFI_PWR_MODULE="/modules/sdio_wifi_pwr.ko"
	WIFI_DEV="eth0"
fi

if [ "$(cat /tmp/was_connected_to_wifi)" == "true" ]; then
	insmod "${SDIO_WIFI_PWR_MODULE}"
	insmod "${WIFI_MODULE}"
	# Race condition
	sleep 1.5
	ifconfig "${WIFI_DEV}" up
	if [ "${DEVICE}" == "n705" ] || [ "${DEVICE}" == "n905b" ] || [ "${DEVICE}" == "n905c" ] || [ "${DEVICE}" == "n613" ] || [ "${DEVICE}" == "n437" ]; then
		wlarm_le up
	fi
	ESSID=`cat /data/config/17-wifi_connection_information/essid`
	PASSPHRASE=`cat /data/config/17-wifi_connection_information/passphrase`
	/usr/local/bin/wifi/connect_to_network.sh "${ESSID}"  "${PASSPHRASE}" 
	rm -f /tmp/was_connected_to_wifi
fi

sleep 1
rc-service sleep_standby start
