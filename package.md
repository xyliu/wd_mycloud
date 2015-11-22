# packages

## preferred package list
 * aria2
   * libc-ares2
 * vim
   * libgpm2
 * git
   * libcurl3-gnutls
   * liberror-perl
   * git-man
 * htop
 * mc
   * suggested: links w3m lynx arj xpdf pdf-viewer dbview odt2txt gv catdvi djvulibre-bin imagemagick python-boto python-tz


## Generate package list
### method
  * Use `dpkg --get-selections` to get the packages installed in stock image and the rootfs.
  * Use `apt-get build-dep gcc` to get the dependencies.
  * To find the uniq packages should be added against the stock image, can use a [script](<script/uniq.go>) to generated the list

eg:

  `go run script/uniq.go rootfs.installed.packages.txt stock.installed.pkgs.txt`

  `go run script/uniq.go gcc.dependy.packages.txt stock.installed.pkgs.txt`

### difference in rootfs

  * debconf-i18n
  * libtext-wrapi18n-perl
  * manpages
  * tasksel
  * tasksel-data

reference files:

 * [rootfs.installed.packages.txt](rootfs.installed.packages.txt)
 * [stock.installed.pkgs.txt](stock.installed.pkgs.txt)

### gcc package dependency againt stock image's

  * cpp-4.6
  * diffstat
  * libptexenc1
  * libgraph4
  * libmpfr-dev
  * quilt
  * gcc-4.6
  * autotools-dev
  * g++
  * libbison-dev
  * graphviz
  * libice6
  * libkpathsea6
  * libxrender1
  * libxt6
  * bison
  * gcc
  * libopts25
  * libpaper-utils
  * libthai0
  * libxfont1
  * lsb-release
  * libstdc++6-4.6-dev
  * luatex
  * tex-common
  * autogen
  * libcgraph5
  * libdatrie1
  * libgvc5
  * gettext
  * html2text
  * libthai-data
  * libc6-dev
  * libcdt4
  * libgvpr1
  * libsm6
  * libxcb-shm0
  * locales
  * libelfg0-dev
  * libgomp1
  * liblcms1
  * build-essential
  * libgmp10
  * libgmpxx4ldbl
  * libpango1.0-0
  * autoconf2.64
  * binutils
  * ed
  * gperf
  * libelfg0
  * libgettextpo0
  * libppl9
  * libpwl5
  * sharutils
  * dejagnu
  * gawk
  * libgraphite3
  * dpkg-dev
  * gettext-base
  * libcloog-ppl0
  * libpaper1
  * libxmu6
  * libxaw7
  * poppler-data
  * flex
  * libcupsimage2
  * libgs9
  * libjbig2dec0
  * libxcb-render0
  * libppl-c4
  * libsigsegv2
  * texinfo
  * libtool
  * linux-libc-dev
  * debhelper
  * liblcms2-2
  * libpixman-1-0
  * expect
  * gcc-4.6-base
  * guile-1.8-libs
  * libpoppler19
  * libxdot4
  * m4
  * realpath
  * libcairo2
  * libgd2-noxpm
  * libmpfr4
  * libopenjpeg2
  * libtimedate-perl
  * libcups2
  * libjbig0
  * libpathplan4
  * po-debconf
  * libcloog-ppl-dev
  * libjasper1
  * libppl0.11-dev
  * g++-4.6
  * intltool-debian
  * libmpc2
  * chrpath
  * doxygen
  * libasprintf0c2
  * libdpkg-perl
  * libfontenc1
  * libgmp-dev
  * libtiff4
  * libxext6
  * patch
  * gsfonts-x11
  * libmpc-dev
  * tcl8.5
  * autoconf
  * automake
  * libopts25-dev
  * libxft2
  * fontconfig
  * gsfonts
  * libgs9-common
  * libijs-0.35
  * make
  * cpp
  * libcroco3
  * patchutils
  * texlive-base

