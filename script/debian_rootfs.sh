# copy from https://drive.google.com/folderview?id=0B_6OlQ_H0PxVUkJXRzk5ODlscmM&usp=drive_web&tid=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE
# Kudos to Fox_exe
# Notice for Jessie: udev package conflicts with hardware. Need old version - from wheezy.


mkdir debian
cd debian

apt-get install debootstrap

#!! Create base F
debootstrap --verbose --arch armhf --variant=minbase --no-check-gpg --foreign wheezy . http://ftp.debian.org/debian
LANG=C chroot . /debootstrap/debootstrap --second-stage

#!! Change /etc/fstab
# Default mounts for WDMyCloud
/dev/root       /       ext3    defaults        0       1
/dev/sda3       none    swap    sw              0       0
proc            /proc   proc    defaults        0       0
sysfs           /sys    sysfs   defaults        0       0
tmpfs           /tmp    tmpfs   rw,size=64M     0       0
#cgroup /sys/fs/cgroup  cgroup  memory,cpu      0       0
#/dev/sda4       /data   ext4    defaults        0       0

#!! /etc/inittab - Comment all respawn's, add one new:
#1:2345:respawn:/sbin/getty 38400 tty1
#2:23:respawn:/sbin/getty 38400 tty2
#3:23:respawn:/sbin/getty 38400 tty3
#4:23:respawn:/sbin/getty 38400 tty4
#5:23:respawn:/sbin/getty 38400 tty5
#6:23:respawn:/sbin/getty 38400 tty6
T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100

#!! Change /etc/hostname
mycloud

#!! Add this to /etc/hosts
127.0.1.1       MyCloud.localdomain MyCloud

#!! Create /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet dhcp

#!! Create /etc/apt/sources.list
deb http://ftp.ru.debian.org/debian wheezy main contrib non-free
deb http://ftp.ru.debian.org/debian wheezy-updates main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free

#!! Chroot inside
LANG=C chroot .

#!! Set root password
passwd
mycloud

#!! Tune Apt
cat <<END > /etc/apt/apt.conf
APT::Install-Recommends "0";
APT::Install-Suggests "0";
END

#!! Install all software
apt-get install apt-utils dialog locales
dpkg-reconfigure locales
dpkg-reconfigure tzdata
apt-get install dhcp3-client udev netbase ifupdown iproute openssh-server iputils-ping wget net-tools ntp module-init-tools less fake-hwclock hdparm nano

#!! Install ramlog: reduce HDD usage.
cd /tmp
wget http://www.tremende.com/ramlog/download/ramlog_2.0.0_all.deb
dpkg -i ramlog_2.0.0_all.deb
apt-get install -f
rm ramlog_2.0.0_all.deb
/etc/init.d/ramlog start


#!! Tuning:
echo HWCLOCKACCESS=no >> /etc/default/rcS
echo CONCURRENCY=shell >> /etc/default/rcS

apt-get install cron anacron bash-completion hdparm bzip2 usbutils psmisc strace info logrotate ethtool rsyslog

#!! Tune USB (Flash)
rm -f /etc/blkid.tab
ln -s /dev/null /etc/blkid.tab
rm -f /etc/mtab
ln -s /proc/mounts /etc/mtab

#!! Tune HDD: (Sleep after 2.5 min - 30x5)
hdparm -S 30 /dev/sda

#!! Add libs to image.
# download arhive Kernel and modules v3.tar.gz (In Googledrive "Other" directory)
# Extract libs
tar xvfz Kernel\ and\ modules\ v3.tar.gz lib/* -C /lib/
# Modify /etc/modules
echo "pfe lro_mode=1 tx_qos=1 alloc_on_init=1 disable_wifi_offload=1" > /etc/modules

#!! Add wd-leds.sh to /etc/init.d and install:
chmod +x /etc/init.d/wd-leds.sh
update-rc.d wd-leds.sh defaults

#!! Mount /dev/md0 and upload data to hem.
mount -t ext3 /dev/md0 /mnt/hdd
rm -r /mnt/hdd/*
cp * /mnt/hdd/
umount /mnt/hdd
