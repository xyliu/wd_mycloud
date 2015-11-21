# build software

## build environment

 use the debootstap from WDC and just run the command. If anyting wrong, check the script by WDC and run the command line by line to fix.
 
 Note: make sure use the binutils* package from WD and by default, the scripts will not install them to chroot environment correctly.

## the defalt steps 

```bash
  aria2c http://download.wdc.com/gpl/gpl-source-wd_my_cloud-04.04.01-112.zip
  unzip gpl-source-wd_my_cloud-04.04.01-112.zip packages/build_tools/debian/*
  cd packages/build_tools/debian/
  ./build-armhf-package.sh -h
  ./build-armhf-package.sh --pagesize=64k htop wheezy
``` 

##  works in chroot 

here is the .bashrc in root

```
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C
export LANGUAGE=C
export LANG=C
export DEB_CFLAGS_APPEND='-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE'
export DEB_BUILD_OPTIONS=nocheck

mount -t proc none /proc
mount -t devtmpfs none /dev
mount -t devpts none /dev/pts

function build_pkg() {
 echo "apt-get -y build-dep $1 && apt-get -y source --compile $1"
 apt-get -y build-dep $* && apt-get -y source --compile  $*
}
```
  
so build the packge by run

 `build_pkg htop`

## put the package to wdcloud and install

 see to [sync_wdc_packge.sh](<script/sync_wdc_packge.sh>)

## Reference
 
* [How to successfully build packages for WD My Cloud from source](https://community.wd.com/t/guide-building-packages-for-the-new-firmware-someone-tried-it/93382/22)
