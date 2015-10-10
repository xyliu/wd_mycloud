#!/bin/bash

#copy from https://drive.google.com/folderview?id=0B_6OlQ_H0PxVUENWT2UwQTIyb2s&usp=drive_web&tid=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE
#Kudos to Fox_exe

echo "============================================="
echo "Ok, lets go..."
echo yellow > /sys/class/leds/system_led/color
echo off > /sys/class/leds/system_led/blink

image_rootfs="rootfs.img"
image_kernel="kernel.img"
Disk="/dev/sda"
currentRootDevice=`cat /proc/cmdline | awk -F= 'BEGIN{RS=" "}{ if ($1=="root") print $2 }'`
if [ "${currentRootDevice}" == "/dev/md0" ]; then
	volumeNumber="1"
else
	volumeNumber="0"
fi

upgradePart="${Disk}$((volumeNumber + 1))"
upgradeDevice="/dev/md${volumeNumber}"
image_config="config_md${volumeNumber}.img"

if [ ! -r $image_rootfs ] && [ ! -r $image_kernel ] && [ ! -r $image_config ]; then
	echo "Backup images not found. Please download it and place in same folder."
	exit 0
fi

echo "Stop all processes..."

killall -9 forked-daapd
[ -e /etc/init.d/cron ]               && /etc/init.d/cron stop 2>/dev/null
[ -e /etc/init.d/monitorio ]          && /etc/init.d/monitorio stop 2>/dev/null
[ -e /etc/init.d/monitorTemperature ] && /etc/init.d/monitorTemperature stop 2>/dev/null
[ -e /etc/init.d/twonky ]             && /etc/init.d/twonky stop 2>/dev/null
[ -e /etc/init.d/access ]             && /etc/init.d/access stop 2>/dev/null
[ -e /etc/init.d/itunes ]             && /etc/init.d/itunes stop 2>/dev/null
[ -e /etc/init.d/orion ]              && /etc/init.d/orion stop 2>/dev/null
[ -e /etc/init.d/wdphotodbmergerd ]   && /etc/init.d/wdphotodbmergerd stop 2>/dev/null
[ -e /etc/init.d/wdmcserverd ]        && /etc/init.d/wdmcserverd stop 2>/dev/null
[ -e /etc/init.d/samba ]              && /etc/init.d/samba stop 2>/dev/null
[ -e /etc/init.d/netatalk ]           && /etc/init.d/netatalk stop 2>/dev/null
[ -e /etc/init.d/upnp_nas ]           && /etc/init.d/upnp_nas stop 2>/dev/null
[ -e /etc/init.d/wddispatcherd ]      && /etc/init.d/wddispatcherd stop 2>/dev/null
[ -e /etc/init.d/wdnotifierd ]        && /etc/init.d/wdnotifierd stop 2>/dev/null
wdAutoMountAdm.pm shutdownCleanup
[ -e /etc/init.d/wdAutoMount ]        && /etc/init.d/wdnotifierd stop 2>/dev/null
[ -e /etc/init.d/nfs-kernel-server ]  && /etc/init.d/nfs-kernel-server stop 2>/dev/null
[ -e /etc/init.d/nfs-common ]         && /etc/init.d/nfs-common stop 2>/dev/null
sync
sleep 2

echo "Recreate mdraid partitions:"
if [ -e ${upgradeDevice} ]; then
	echo "${upgradeDevice} exist! Deleting..."
	mdadm --stop ${upgradeDevice} 2>/dev/null
	mdadm --wait ${upgradeDevice} 2>/dev/null
	rm -rf ${upgradeDevice}
	sleep 1
fi

echo "Restoring raid..."
mdadm ${currentRootDevice} --remove ${Disk}1 > /dev/null 2>&1
mdadm --wait ${currentRootDevice} 2>/dev/null
mdadm ${currentRootDevice} --add ${Disk}1 > /dev/null 2>&1
mdadm --wait ${currentRootDevice} 2>/dev/null
mdadm ${currentRootDevice} --remove ${Disk}2 > /dev/null 2>&1
mdadm --wait ${currentRootDevice} 2>/dev/null
mdadm ${currentRootDevice} --add ${Disk}2 > /dev/null 2>&1
mdadm --wait ${currentRootDevice} 2>/dev/null

echo "============================================="
echo "Current device: ${currentRootDevice}"
echo "Upgrade device: ${upgradeDevice}"
echo "Upgrade part: ${upgradePart}"
echo "Current raid status:"
echo " "
cat /proc/mdstat
echo "============================================="

echo "Creating new mdraid volume..."
mdadm ${currentRootDevice} -f ${upgradePart}
mdadm --wait ${currentRootDevice}
sleep 1
mdadm ${currentRootDevice} -r ${upgradePart}
mdadm --wait ${currentRootDevice}
sleep 1
mdadm --zero-superblock --force --verbose ${upgradePart}
sync
sleep 1
mdadm --create ${upgradeDevice} --verbose --metadata=0.90 --raid-devices=2 --level=raid1 --run ${upgradePart} missing 2>/dev/null
mdadm --wait ${upgradeDevice}
sleep 1
sync

if [ ! -r ${upgradeDevice} ]; then
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!! Something wrong: ${upgradeDevice} not exist !!"
	echo "!! Exiting now.                                !!"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit 0
fi

echo "Installing new data..."
echo blink > /sys/class/leds/system_led/blink
dd if=${image_rootfs} of=${upgradeDevice} > /dev/null 2> /dev/null
dd if=${image_kernel} of=/dev/sda5 > /dev/null 2> /dev/null
dd if=${image_config} of=/dev/sda7 > /dev/null 2> /dev/null
sync

mkdir /tmp/hdd
mount -t ext3 ${upgradeDevice} /tmp/hdd
cp run_me_after_reboot.sh /tmp/hdd/
chmod a+x /tmp/hdd/run_me_after_reboot.sh
umount /tmp/hdd
sync

echo "Done! Cleanup..."
rm -f ${image_rootfs} > /dev/null 2> /dev/null
rm -f ${image_kernel} > /dev/null 2> /dev/null
rm -f config_md0.img > /dev/null 2> /dev/null
rm -f config_md1.img > /dev/null 2> /dev/null
rm -f install.sh > /dev/null 2> /dev/null
rm -f run_me_after_reboot.sh > /dev/null 2> /dev/null

echo green > /sys/class/leds/system_led/color
echo off > /sys/class/leds/system_led/blink
sync

echo "Reboot to take effect..."
reboot -f -h -i &
