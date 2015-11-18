# [How to successfully build packages for WD My Cloud from source](https://community.wd.com/t/guide-building-packages-for-the-new-firmware-someone-tried-it/93382/22)
The WD My Cloud comes with a Debian wheezy system on it. However WD customized that in a way that it is hardly possible (if not impossible at all) to install new packages using the standard "apt-get install <package name>" way, especially when you update the device firmware to version 4.x or later. The latest firmware, in fact, uses a modified Debian system with 64K sized memory pages: if you install a package using "apt-get install <package name>" from the standard repositories, almost certainly it won't run and produce just a laconic "Killed" output.

So, to install new packages on the My Cloud you need to build them from source on another system, copy the obtained deb packages on the My Cloud and install.

WD provides a GPL source package of the latest firmware on their website, which contains a build environment to perform this operation. This is totally at the end-user own risk, since no support at all is provided by WD and installing 3rd party software may void warrany.

An additional problem is that the build environment provided by WD has a "minor" problem that causes the building process of most packages to fail because of a GCC compiler segmentation fault.

This guide shows how to deal with this problem and, in general, how to create a build environment to easily do the task.

Some Linux knowledge is needed.

NOTE 1: as of now, this procedure is surely needed to build packages for the 4.x firmware; however, by experience, I find out that it's a useful procedure even if you are sticking with the 3.x firmware; so the guide explains how to build packages for both firmware versions

NOTE 2: in principle, it should be possible to build packages directly on the My Cloud, instead of using an external system; however I don't think it's a good idea to try this, because of many reasons, including: the My Cloud system is surely slower than a regular PC to compile packages; you would need to install all the development tools on the My Cloud itself (and this may require in turn to build them on another system first...)

## Step 1: prepare the build system (required only once)


The build environment must be a Linux system, either Debian-based or Ubuntu-based. I personally suggest to create a virtual machine with such a system in it. This guide will take this route.

Download and install VirtualBox (https://www.virtualbox.org/) on your phisical system (either Linux, Windows or Mac). Start VirtualBox and create a new virtual machine for a Debian 64-bit. The default settings suggested by VirtualBox regarding memory, disk size and VM configuration should be ok to start.

After the VM is ready, download a Debian Wheezy 64-bit ISO image; I suggest the netinst image, which is the smaller one. Right now, Debian 7.0.6 is available and the direct links are:

    http://cdimage.debian.org/debian-cd/7.6.0/amd64/iso-cd/debian-7.6.0-amd64-netinst.iso (download via HTTP)

    http://cdimage.debian.org/debian-cd/7.6.0/amd64/bt-cd/debian-7.6.0-amd64-netinst.iso.torrent (download via BitTorrent)

Boot the VM with the downloaded ISO mounted in and install just the Debian base system (nothing else is required). Refer to VirtualBox and Debian websites for documentation on how to perform these operations.

Once the guest VM is installed, we need to make just a couple little tunings. First of all, Debian Wheezy comes with qemu-user-static package version 1.1.2. Qemu is an environment needed to emulate an actual ARM system on another platform, like the AMD64 platform our build system consists of. It's a good idea to update Qemu to version 2.x from the wheezy-backports repository. To do this, start the build system and login. Then:

```
# sudo su
# echo "deb http://ftp.debian.org/debian wheezy-backports main contrib non-free" >>/etc/apt/sources.list
# apt-get update
# apt-get -t wheezy-backports install qemu-user-static
```

This should also install binfmt-support, which is another packages needed by the build environment. If this is not the case, also type:

```
# apt-get install binfmt-support
```

Now, let's prepare the actual build environment. Let's create a folder in the /root directory of the build system and download the WD My Cloud 4.x firmware source package from WD website.

```
# cd /root
# mkdir wdmc-build
# cd wdmc-build
# wget http://download.wdc.com/gpl/gpl-source-sequoia-04.00.00-607.zip
```

In case the link changes, refer to WD My Cloud support page to find the new one: http://support.wdc.com/product/download.asp?groupid=904&lang=en1

 I then suggest to create different folders for different build scenarios. These are the possibilities:

  * the target system may be firmware 3.x (4k) or firmware 4.x (64k)
  * the source package base may be wheezy (Debian stable) or jessie (Debian testing); wheezy contains older packages, but that should run happily in My Cloud (which has a Wheezy in it!), while jessie contains newer packages that might also work and provide updated versions of many applications; I would personally recommend to build packages from wheezy, unless you absolutely need a newer version that is only in jessie

I don't recommend to mix things, so I would create different folders for any different combination. You're free to create just the one you are interested in, so among the following commands type fhe first ones, then only the block of commands of the combination(s) you're interested in, then the last command:

```
# cd /root/wdmc-build
# unzip gpl-source-sequoia-04.00.00-607.zip packages/build_tools/debian/*

# mkdir 64k-wheezy
# cp -R packages/build_tools/debian/* ./64k-wheezy
# echo '#!/bin/bash' >>64k-wheezy/build.sh
# echo './build-armhf-package.sh --pagesize=64k $1 wheezy' >>64k-wheezy/build.sh# chmod a+x ./64k-wheezy/build.sh

# mkdir 64k-jessie
# cp -R packages/build_tools/debian/* ./64k-jessie
# echo '#!/bin/bash' >>64k-jessie/build.sh
# echo './build-armhf-package.sh --pagesize=64k $1 jessie' >>64k-jessie/build.sh
# chmod a+x ./64k-jessie/build.sh
# mkdir 4k-wheezy
# cp -R packages/build_tools/debian/* ./4k-wheezy
# echo '#!/bin/bash' >>4k-wheezy/build.sh
# echo './build-armhf-package.sh --pagesize=4k $1 wheezy' >>4k-wheezy/build.sh
# chmod a+x ./4k-wheezy/build.sh
# mkdir 4k-jessie
# cp -R packages/build_tools/debian/* ./4k-jessie
# echo '#!/bin/bash' >>4k-jessie/build.sh
# echo './build-armhf-package.sh --pagesize=4k $1 jessie' >>4k-jessie/build.sh
# chmod a+x ./4k-jessie/build.sh
# rm -rf packages/
```

In this way, in every folder will be created a build.sh script that passes the right parameters to the WD provided script, requiring only the name of the package to build. This would work straight away if there weren't the problem with qemu I mentioned in the beginning, so another step is required to finish the prepare phase. Again, only type commands for the scenario(s) you're interested in:

 

64k-wheezy:

```
# cd /root/wdmc-build/64k-wheezy
# ./setup.sh bootstrap/wheezy-bootstrap_1.24.14_armhf.tar.gz build
# mv build/usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static_orig
# cp /usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static
```

64k-jessie:

```
# cd /root/wdmc-build/64k-jessie
# ./setup.sh bootstrap/jessie-bootstrap_5.14.14_armhf.tar.gz build
# cp /usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static
```

4k-wheezy:

```
# cd /root/wdmc-build/4k-wheezy
# ./setup.sh bootstrap/wheezy-bootstrap_1.24.14_armhf.tar.gz build
# mv build/usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static_orig
# cp /usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static
```

4k-jessie:

```
# cd /root/wdmc-build/4k-jessie
# ./setup.sh bootstrap/jessie-bootstrap_5.14.14_armhf.tar.gz build
# cp /usr/bin/qemu-arm-static build/usr/bin/qemu-arm-static
```

The meaning of the above is the following: prepare an emulated ARM system and replace the qemu-arm-static binary provided by the bootstrap with the recent one we've installed in our actual build system.

Ignore any errors produced by setup.sh: that script is really buggy and many things it tries to do seem to be useless, unless we apply the mentioned qemu fix.

 

As a final step, I would recommend to edit the sources file list within the armhf build subsystem in order to be able to build packages that are in any of the distribution repositories. To do this, type the following:


```
# cd /root/wdmc-build
# nano <scenario>/build/etc/apt/sources.list
```

by replacing <scenario> with the desired one (64k-wheezy, 64k-jessie, 4k-wheezy, 4k-jessie); the nano editor will open, then replace the contents of the existing file with the following:

For 64k-wheezy and 4k-wheezy:

```
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free
deb http://ftp.debian.org/debian wheezy-updates main contrib non-free
deb-src http://ftp.debian.org/debian wheezy-updates main contrib non-free
deb http://ftp.debian.org/debian wheezy main contrib non-free
deb-src http://ftp.debian.org/debian wheezy main contrib non-free

#deb http://ftp.debian.org/debian wheezy-backports main contrib non-free
#deb http://ftp.debian.org/debian wheezy-backports main contrib non-free
```

For 64k-jessie and 4k-jessie:

```
deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free
deb http://ftp.debian.org/debian jessie-updates main contrib non-free
deb-src http://ftp.debian.org/debian jessie-updates main contrib non-free
deb http://ftp.debian.org/debian jessie main contrib non-free
deb-src http://ftp.debian.org/debian jessie main contrib non-free
```

In case of wheezy, uncomment the last two lines if you want to build package versions from wheezy-backports. I don't know however if additional changes to the build.sh script (or better to the WD provided one) are needed to instruct apt to download and build the source from the backports repository. I don't have tried it yet. Anyway, I would recommend to leave those two lines commented unless you actually need something from the backports repository.

Save the file by hitting Ctrl+X, Y, Enter.

Now you're ready to build your first package!

Optional additional step (not strictly required) for wheezy scenarios

You may also want to use an updated C++ compiler to build packages in the wheezy scenarios. Debian Wheezy provides g++ package 4.6, but 4.7 is also available. With the following commands you can install the new version and then switch from one to the other using update-alternatives:

```
# cd /root/wdmc-build/<scenario>
# chroot build# apt-get update
# apt-get install g++ g++-4.7
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++.4.6 10
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.7 20
# update-alternatives --install /usr/bin/gcc g++ /usr/bin/gcc-4.6 10
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 20
# rm /usr/bin/cpp
# update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-4.6 10
# update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-4.7 20# exit
```

After these commands, the default C++ compiler will be version 4.7. You can then switch to the old version by typing:

```
# cd /root/wdmc-build/<scenario>
# chroot build
# update-alternatives --set cpp /usr/bin/cpp-4.6
# update-alternatives --set gcc /usr/bin/gcc-4.6
# update-alternatives --set g++ /usr/bin/g++-4.6
# exit
```

 Or use update-alternatives --config <command> to get an interactive prompt.

 
## Step 2: build your package

It's time to build your package. Let's build htop for instance, a nice replacement for top command. The example will build it for the scenario 64k-wheezy (i.e: packages suitable for 4.x firmware, built from the version of htop provided by Debian Wheezy). Start your build system, login, then:

```
# sudo su
# cd /root/wdmc-build/64k-wheezy
# ./build.sh htop
```

The built package will be placed into /root/wdmc-build/<scenario>/build/root and will consist of one or more .deb files (you'll also find other files and folder, just ignore them and consider only .deb files). Sometimes building a package will build other packages, too: it depends on how package sources are organized. For instance, if you build transmission-daemon, you'll also get the deb packages for the GUI packages (like transmission-gtk or transmission-qt): you can simply throw away those additional debs if you don't need them.

Once the deb files are ready, copy them from the build system to your My Cloud (to achieve this, if you built a VirtualBox VM you may use a shared folder to exchange data with the physical host system). Then, login via SSH to your My Cloud and type:

`# dpkg -i <path-to-build-deb-file>/htop_1.0.1-1_armhf.deb`

where <path-to-built-deb-file> is the path where you stored the deb file you just built; if you copied it to the standard Public shared folder, the path will be /shares/Public/.

If you're lucky, you're done. Otherwise, the /installation command may prompt you something like this:

dpkg: dependency problems prevent configuration of transmission-daemon:
 transmission-daemon depends on libcurl3-gnutls (>= 7.16.2); however:
  Package libcurl3-gnutls is not installed.

This simply means that the package you're trying to install depends on another package (in this case: transmission-daemon requires libcurl3-gnutls) which is not yet installed. You then need to build in turn this required package, with the same procedure, and install it before the package you originally intended to install. Repeat the steps for all the missing dependencies that dpkg reports. Sometimes, to fix circular dependencies (packages depend on each other), once you've built all the necessary packages you may install them all at once with: dpkg -i <path-to-built-debs>/*.deb, so that dpkg will resolve dependencies automatically.

Final notes:

    * building a package may require a LOT of time, just be patient...
    * you may periodically clean /root/wdmc-build/<scenario>/build/root folder after you've built your packages, to free up space; in fact, building may require a considerable amount of (temporary) disk space
    
    once installed with dpkg, packages contents are unpacked to the My Cloud system partitions. There should be enough disk space available to not worry about disk space, however almost certainly a firmware upgrade will delete all of your installed packages; I would suggest to create a shared folder using the web UI, named "System", protected by password and accessible only to admin users; inside it you may put your built deb files, organized as you like. In case of a firmware upgrade, you may simply re-install the packages from there using dpkg -i (one at a time, or all of them at once using wildcards, etc.); however please consider the following notes
   
   a firmware upgrade might change the architecture of the provided Debian system and might require to rebuild all packages... this is exactly what happened with the upgrade from 3.x to 4.x firmware, where WD decided to rebuild the whole system using 64k sized memory pages rather than the standard 4k sized ones... I don't think WD is so sadistic to do that again and again, but who knows? I suggest to read carefully the release notes of the new firmware, have a look to the updated GPL source package (if they make it available on their website) and try to install a few small packages after firmware upgrade just to check that everything is ok; installing all in a rush may have catastrophic effects, especially when a package you had built on your own requires to update one of the WD provided ones... if it won't work, it will almost certainly break something of the WD built-in features, causing a device failure in the worst case... again, you are on your own, you get no support for this
   
   to restore the whole functionality of third-party applications after a firmware upgrade, not only you may need to reinstall the deb packages, but you will also need to restore any custom application configuration; if you leave default settings, usually applications save their settings in /etc or in /root, which are both on the system partitions of WD and might be deleted and recreated by the firmware update process; you may choose to backup your application configurations or change things so that they are linked to a shared folder (for instance the aforementioned System shared folder) where they won't be deleted; in this way, after the firmware upgrade you may just need to restore your backups or your symlinks; howerver, the exact procedure may be different for each package and is above the scope of this guide

  From the above, two things should be quite clear: disable the automatic firmware upgrade in the web UI and use all of this at your own risk.

Feedback, improvements and corrections are welcome.

UPDATE ON 2015-01-10: I've published a new message where I'm providing patched scripts and an updated binutils package to make the build environment work better, especially when building packages from jessie repository and with 64k pagesize. Here is the direct link.


## (Nazar78) Updates, my bad, I already messed up the binutils:

So the vital point is the qemu like you mentioned.

To summarize your guide, these are the required parts to successfully build the packages on host Debian 7.6.0 64bit:

  1. Update the host once:

```
    sudo su
    echo "deb http://ftp.debian.org/debian wheezy-backports main contrib non-free" >>/etc/apt/sources.list
    apt-get update
    apt-get -t wheezy-backports install qemu-user-staticapt-get install binfmt-support
```

  2. Get the WD GPL source and extract to working dir if haven't done so:

```
wget http://download.wdc.com/gpl/gpl-source-sequoia-04.00.00-607.zip
unzip gpl-source-sequoia-04.00.00-607.zip packages/build_tools/debian/*
```

  3. Fix WD bootstrap once! cd to the package dir, replace qemu that was provided by WD:

```
cd packages/build_tools/debian/
cp -f /usr/bin/qemu-arm-static qemu/`dpkg --print-architecture`/
```

  4. Run the build command (watch out for timeout/gateway errors which will result in failure at the end, retry if some dependencies failed to download):

  `./build-armhf-package.sh --pagesize=64k transmission wheezy`

Results:

```
OUTPUT debs can be found here:       
build/root/transmission-cli_2.52-3+nmu2_armhf.deb
build/root/transmission-dbg_2.52-3+nmu2_armhf.deb
build/root/transmission-daemon_2.52-3+nmu2_armhf.deb
build/root/transmission-gtk_2.52-3+nmu2_armhf.deb
build/root/transmission_2.52-3+nmu2_all.deb
build/root/transmission-qt_2.52-3+nmu2_armhf.deb
build/root/transmission-common_2.52-3+nmu2_all.deb
```
