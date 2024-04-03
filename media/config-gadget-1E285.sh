#!/bin/sh
rmmod g_ether
set -e
cd /sys/kernel/config/usb_gadget
mkdir etherinst || true
cd etherinst
cd functions
mkdir ecm.0
mkdir mass_storage.0
echo 0 >mass_storage.0/stall
echo 1 >mass_storage.0/lun.0/ro
echo /home/andi/debian-11.2.0-amd64-netinst.iso >mass_storage.0/lun.0/file
cd ../configs
mkdir c.1
cd c.1
for name in ../../functions/*
do
  ln -s $name .
done
cd ../..
(cd /sys/class/udc ; echo * ) >UDC
