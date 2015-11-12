# WD My Cloud [Specifications](http://mybookworld.wikidot.com/my-cloud)

  * Capacities
    * 2TB (WDBCTL0020HWT)
    * 3TB (WDBCTL0030HWT)
    * 4TB (WDBCTL0040HWT)
  * Connectors
    * USB 3.0
    * Gigabit Ethernet
  * Physical Dimensions
    * Height: 6.70 Inches
    * Depth: 5.50 Inches
    * Width: 1.90 Inches
    * Weight 2.12 Pounds
  * Temperatures
    * Operating: 41° F to 95° F or 5° C tot 35° C
    * Non-operating: -4° F to 149° F or -20° C tot 65° C
  * Processor
    * Mindspeed Comcerto 2000 (M86261G-12) dual-core ARM Cortex-A9 @650 MHz
  * Memory
    * 256 MB of Samsung K4B2G1646E DDR3 RAM
  * Voltage
    * AC Input Voltage: 100-240 VAC
    * AC Input Frequency: 47-63 Hz

```
    WDMyCloud:~# cat /proc/meminfo
    MemTotal: 232448 kB
    MemFree: 48128 kB
    Buffers: 3840 kB
    Cached: 57856 kB
    SwapCached: 18304 kB

    WDMyCloud:~# cat /proc/scsi/scsi
    Attached devices:
    Host: scsi0 Channel: 00 Id: 00 Lun: 00
    Vendor: ATA Model: WDC WD30EFRX-68E Rev: 82.0
    Type: Direct-Access ANSI SCSI revision: 05

    WDMyCloud:~# cat /proc/cpuinfo
    Processor : ARMv7 Processor rev 1 (v7l)
    processor : 0
    BogoMIPS : 1292.69

    processor : 1
    BogoMIPS : 1299.25

    Features : swp half thumb fastmult vfp edsp neon vfpv3 tls
    CPU implementer : 0x41
    CPU architecture: 7
    CPU variant : 0x2
    CPU part : 0xc09
    CPU revision : 1

    Hardware : Comcerto 2000 EVM
    Revision : 0001
    Serial : 0000000000000000
 ```

## UART

![Pins](https://lh6.googleusercontent.com/mMq8Ek3fgsBwV7KRuI7jRG-CG1Iq4OzE1aY5vAI0sqTUpRNHTSLkkFW0IWFo6ANe-IF-bg=s190)

# Partition Topology

```
Disk /home/work/mycloud/usb-8g.img: 8036MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
```

| partition | usage  | Start  | End       | Size   | File system | Name    | Flags    |
| -----     | ---    | ----   | ----      | ----   | ----        | ---     | ---      |
| 1         | rootfs | 528MB  | 2576MB    | 2048MB | ext3        | primary | raid     |
| 2         | rootfs | 2576MB | 4624MB    | 2048MB | ext3        | primary | raid     |
| 3         |        | 16MB   | 528MB     | 513MB  | swap        | primary | msftdata |
| 4         | data   | 4828MB | 8035MB(*) | 3208MB | ext4        | primary | msftdata |
| 5         | kernel | 4624MB | 4724MB    | 99.6MB |             | primary | msftdata |
| 6         | kernel | 4724MB | 4824MB    | 101MB  |             | primary | msftdata |
| 7         | config | 4824MB | 4826MB    | 1049kB |             | primary | msftdata |
| 8         | config | 4826MB | 4828MB    | 2097kB |             | primary | msftdata |

  Note:
   * size(4) = [4828MB, TotalSize - 1MB]
   * Replace original hard disk with arbitary size hard disk according to the above topology

# Recovery/Setup
## Install with Fox_exe's [script](script/install.sh)
[HowTo](https://drive.google.com/folderview?id=0B_6OlQ_H0PxVUENWT2UwQTIyb2s&usp=drive_web&tid=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE):
```
    Eng:
    1. Download Autoinstall.zip
    2. Download dump of any firmware (Backup, OMV, CleanDebian)
    3. Unpack and copy all to one folder in NAS (For example - to "Public" share)
    4. Go to web-gui, enable SSH. Connect to WD via SSH (Use PuTTY for this)
    5. Run:
    cd /DataVolume/shares/Public
    chmod +x install.sh
    ./install.sh
    6. After ~10min device reboots. All done. Try you new firmware!
    * Optional: Run "/run_me_after_reboot.sh" for few tweaks and cleanup.
```

Software:

  * [Firmware Release 4.04.01-112 (10/21/2015)](http://download.wdc.com/nas/sq-040401-112-20151013.deb.zip)

  `wget -c http://download.wdc.com/nas/sq-040401-112-20151013.deb.zip`

  * CacheVolume/upgrade/rootfs.img extracted from Firmware

```
  $ unzip sq-040401-112-20151013.deb.zip
  $ ar xf sq-040401-112-20151013.deb
  $ unxz data.tar.lzma
  $ cp CacheVolume/upgrade/rootfs.img /tmp/rootfs.img
```

  * boot/uImage extracted from rootfs.img

```
  $ mout rootfs.img /mnt/img
  $ cp boot/uImage /tmp/kernel.img
```

  * config_md[0,1].img extracetd from

```
  $ cp /mnt/img/usr/local/share/k1m0.env /tmp/config_md0.img
  $ cp /mnt/img/usr/local/share/k1m1.env /tmp/config_md1.img

```

Reference:

  var/lib/dpkg/info/kernel-mindspeed-sequoia.postinst

## Debrick with Fox_exe's [guide](https://drive.google.com/folderview?id=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE&usp=drive_web)

```
Source: https://drive.google.com/folderview?id=0B_6OlQ_H0PxVRXF4aFpYS2dzMEE&usp=sharing
Mirror: http://anionix.ddns.net/WDMyCloud/

=======================================================================================

Howto replace or restore original firmware:

* You can use any of *nix system. I use Debian (Ubuntu similar).
* All command runing from root user. Or use Sudo.
* First thing after boot in liveCD - install software: apt-get update && apt-get install mdadm parted

!! For install new HDD - go from p.1. If you repare exist HDD - go to p.8-2

1. Use fdisk -l (or parted -l) for see what name have you WD's HDD.
* For me - its /dev/sdb. Replace it to your hdd name!
2. Run parted utility:
parted /dev/sdb

3. Type "print" for see what partitions exist on disk
4. Remove all: Type "remove 1" (where 1 - number of partition)
5. Crete new table:
mklabel gpt
mkpart primary 528M 2576M
mkpart primary 2576M 4624M
mkpart primary 16M 528M
mkpart primary 4828M -1M
mkpart primary 4624M 4724M
mkpart primary 4724M 4824M
mkpart primary 4824M 4826M
mkpart primary 4826M 4828M
set 1 raid on
set 2 raid on

6. Ok, type "quit"

7. Format data partition:
mkfs -t ext4 /dev/sdb4

8-1. Prepare main RAID partition (For rootfs): mdadm --create /dev/md0 --level=1 --metadata=0.9 --raid-devices=2 /dev/sdb1 /dev/sdb2
* Type "watch cat /proc/mdstat" and wait 100%. Then - [ctrl] + [c] for close.

8-2. Stop auto-loaded raid: mdadm --stop /dev/md127 (Sometimes you can see another numbers - see in: ls /dev | grep md)
8-3. Start normal raid (/dev/md0 is important!): mdadm -A /dev/md0 /dev/sdb1 /dev/sdb2

9. Use data partition as download folder:
mount -t ext4 /dev/sdb4 /mnt
cd /mnt

10. Download one of arhive's to /mnt folder:
v3.04.01-230: https://drive.google.com/file/d/0B_6OlQ_H0PxVQ2l5MTNvQk1xSUU
v4.01.02-417: https://drive.google.com/file/d/0B_6OlQ_H0PxVcENERjVxVHFzZzg

11. Extract by console:
tar xvfz original_v3.04.01-230.tar.gz

12. Ok. Upload backup images to WD's hdd:
dd if=kernel.img of=/dev/sdb5
dd if=kernel.img of=/dev/sdb6
dd if=config.img of=/dev/sdb7
dd if=config.img of=/dev/sdb8
dd if=rootfs.img of=/dev/md0

13. Shutdown PC. (Or use "Logout" in menu)
shutdown -p -H 0

14. Connect HDD to WD's plate and turn on WDMyCloud. Wait ~5-10 min.
```

# Customize

## basic

There are guides on how to build the software from source code:

  * [GUIDE: Building packages for the new firmware](http://community.wd.com/t5/My-Cloud/GUIDE-Building-packages-for-the-new-firmware-someone-tried-it/td-p/768007)
  * [APP: NZBGet v15.0 for firmware V4+ (06/2015)](http://community.wd.com/t5/My-Cloud/APP-NZBGet-v15-0-for-firmware-V4-06-2015/td-p/881356)


## kernel
## rootfs
## software
### samba


#### reference
 * [Chapter 45. Samba Performance Tuning](https://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/speed.html)
 * [Make Samba Go Faster](https://wiki.amahi.org/index.php/Make_Samba_Go_Faster)
 * [only-around-50mb-sec-max-network-transfer-had-70-100mb-s-on-windows](http://askubuntu.com/questions/329933/only-around-50mb-sec-max-network-transfer-had-70-100mb-s-on-windows-ubuntu-rep)
 * [Which to use NFS or Samba?](http://askubuntu.com/questions/7117/which-to-use-nfs-or-samba/7124#7124)
 * [Samba Optimizations](https://calomel.org/samba_optimize.html)
 * [tuning](http://arstechnica.com/civis/viewtopic.php?f=16&t=1203625)

### git
### nfs
  My Cloud's default setting:
 
```
# Use nobody user (uid 65534) for nfs guest.  This is restricted from private
# shares by ACLs.
#
/nfs *(rw,all_squash,sync,no_subtree_check,insecure,crossmnt,anonuid=65534,anongid=1000)
```
###vsftp
```
#vsftpd.conf

ftpd_banner=Welcome to WD My Cloud
listen=yes
listen_port=21
accept_timeout=60
connect_timeout=60
data_connection_timeout=300
max_clients=0
max_per_ip=20
xferlog_enable=YES
hide_ids=YES
dirlist_enable=YES
download_enable=YES
use_localtime=YES
write_enable=YES
file_open_mode=0755
local_enable=YES
local_umask=02
local_max_rate=0
anon_root=/nfs
local_root=/nfs
check_shell=NO
chroot_local_user=YES
userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/user_list
vsftpd_log_file=/var/log/vsftpd.log
anonymous_enable=NO
anon_mkdir_write_enable=NO
anon_upload_enable=NO
anon_world_readable_only=YES
anon_other_write_enable=NO
no_anon_password=YES
anon_max_rate=0
anon_umask=077
#share_acl_enable=YES
pasv_enable=YES
pasv_promiscuous=YES
pasv_min_port=5000
pasv_max_port=5099
```

### sshfs
### nginx
### OpenMediaVault
### btsync
BTSync may have protential security issue, so hold on.

# Servers

# Daily Usage

## Disable some impractical service
[Ralphael's suggesion:](https://community.wd.com/t/before-you-pack-up-your-wd-and-return-it-lets-talk-about-copying-speeds/91887)

```
  /etc/init.d/wdmcserverd stop
  /etc/init.d/wdphotodbmergerd stop
  update-rc.d wdphotodbmergerd disable
  update-rc.d wdmcserverd disable
```

Otherwise will scan media file and generate the thumbnails like following, which makes CPU busy.

`convert -define jpeg:size=192x192 /shares/Public/Shared Pictures/test/IMG_0499.JPG -auto-orient -strip -background #000000 -quality 80 -filter box -resize x192 /shares/.wdmc/Public/Shared Pictures/test/transcoded_files/IMG_0499.cb62bbdd389b48898f2e5244977cb2c5.jpg`

## remove .wdmc

  `find /DataVolume/shares -name "*.wdmc" -exec rm -rf {} \;`

## rsync

 ` rsync -avhPSe "ssh -T -c arcfour -o Compression=no" usename@server.ip:"location/of/files" "destination/of/files/"`

  `rsync -avh --no-compress --progress -e "ssh -T -c arcfour -o Compression=no -x" usename@server.ip:"location/of/files" "destination/of/files/"`

Note: The bottle neck is CPU. AVG speed is 10MB/s via Arcfour or 8MB/s with default cipher algorithm

Ref: `man sshd`

```
protocol 2, forward security is provided through a Diffie-Hellman key agreement.  This key agreement results in a shared session key.  The rest of the session is encrypted using a symmetric cipher, currently 128-bit AES, Blowfish, 3DES, CAST128, Arcfour, 192-bit AES, or 256-bit AES.  The client selects the encryption algorithm to use from those offered by the server.  Additionally, session integrity is provided through a cryptographic message authentication code (hmac-md5, hmac-sha1, umac-64, hmac-ripemd160, hmac-sha2-256 or hmac-sha2-512).
```
