# Hardware Spec
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
## kernel
## rootfs
## software
### samba
### git
### nfs
### sshfs
### nginx
### OpenMediaVault
### btsync
BTSync may have protential security issue, so hold on.

# Servers

# Daily Usage

## rsync

 ` rsync `

Note: The bottle neck is CPU. AVG speed is 10MB/s via Arcfour or 8MB/s with default cipher algorithm

Ref: `man sshd`

```
protocol 2, forward security is provided through a Diffie-Hellman key agreement.  This key agreement results in a shared session key.  The rest of the session is encrypted using a symmetric cipher, currently 128-bit AES, Blowfish, 3DES, CAST128, Arcfour, 192-bit AES, or 256-bit AES.  The client selects the encryption algorithm to use from those offered by the server.  Additionally, session integrity is provided through a cryptographic message authentication code (hmac-md5, hmac-sha1, umac-64, hmac-ripemd160, hmac-sha2-256 or hmac-sha2-512).
```
