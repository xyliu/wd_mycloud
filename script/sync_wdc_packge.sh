#!/bin/bash
#
# in WDCcould, should modify the source list in /etc/apt/sources.list as
# 
# deb file:/shares/Public/pkgs ./
#
# and install the pkg as usual:
#  apt-get update
#  apt-get install aria2
#
# XYL@2015

PKG_TMP_DIR=/tmp/pkgs
PKG_DST_DIR=root@wdcloud:/shares/Public/pkgs/
PKG_GEN_DIR=/wdc/src/packages/build_tools/debian/build/root

function sync_wdc_pkg() {
  mkdir -p ${PKG_TMP_DIR} 
  rsync -v ${PKG_GEN_DIR}/*.deb ${PKG_TMP_DIR} 
  cd ${PKG_TMP_DIR} && dpkg-scanpackages . | gzip -9c > ${PKG_TMP_DIR}/Packages.gz
  rsync -vz ${PKG_TMP_DIR}/* ${PKG_DST_DIR}/ 
}

sync_wdc_pkg



