#!/bin/bash

#copy from https://drive.google.com/folderview?id=0B_6OlQ_H0PxVUENWT2UwQTIyb2s&usp=drive_web&tid=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE
#Kudos to Fox_exe

echo "# ===================="
echo "# Preinstall init..."
echo yellow > /sys/class/leds/system_led/color
echo blink > /sys/class/leds/system_led/blink

Disk="/dev/sda1"
currentRootDevice=`cat /proc/cmdline | awk -F= 'BEGIN{RS=" "}{ if ($1=="root") print $2 }'`
if [ "${currentRootDevice}" == "/dev/md0" ]; then
	oldDevice="/dev/md1"
else
	oldDevice="/dev/md0"
fi

echo "# Install necessary software..."
apt-get update
apt-get upgrade -y
apt-get install -y mdadm dialog fake-hwclock

echo "# Deleting old raid partition (${oldDevice})..."
if [ -e ${oldDevice} ]; then
	mdadm ${oldDevice} --remove ${Disk} > /dev/null 2>&1
	mdadm --wait ${oldDevice} 2>/dev/null
	mdadm --stop ${oldDevice} 2>/dev/null
	mdadm --wait ${oldDevice} 2>/dev/null
	rm -rf ${oldDevice}
	sleep 1
	mdadm --zero-superblock --force --verbose ${Disk} > /dev/null 2>&1
	mdadm ${currentRootDevice} --add ${Disk} > /dev/null 2>&1
	mdadm --wait ${oldDevice} 2>/dev/null
	sync
fi

echo "# Reconfigure some software..."

echo "\033[1;33m => \033[0m Do you want change system language [y/n]?"
read userAnswer
if [ "$userAnswer" == "y" ]
then
	apt-get install -y locales 
	dpkg-reconfigure locales
fi

echo "\033[1;33m => \033[0m Do you want change system timezone [y/n]?"
read userAnswer
if [ "$userAnswer" == "y" ]
then
	dpkg-reconfigure tzdata
fi

echo "# Fixing swap ..."
swapon -f /dev/sda3 2>/dev/null

echo "# Cleaningup..."
rm -f /run_me_after_reboot.sh

echo green > /sys/class/leds/system_led/color
echo off > /sys/class/leds/system_led/blink

echo "# ===================="
echo "# Done!"
