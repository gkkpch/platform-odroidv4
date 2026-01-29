This is the content of HK's sd-fusing utility.
It shows where and how to copy the u-boot.bin to the volumio image bed.

Note you need something else to place u-boot on SPI (see HK's wiki for details).

=================================================================================



#!/bin/sh
#
# Copyright (C) 2018 Hardkernel Co,. Ltd
# Dongjin Kim <tobetter@gmail.com>
#
# SPDX-License-Identifier:      GPL-2.0+
#

abort() {
	echo $1
	exit 1
}

[ -z $1 ] && abort "usage: $0 <your/memory/card/device>"
[ -z ${UBOOT} ] && UBOOT=${PWD}/u-boot.bin
[ ! -f ${UBOOT} ] && abort "error: ${UBOOT} does not exist"

sudo dd if=$UBOOT of=$1 conv=fsync,notrunc bs=512 seek=1

sync

sudo eject $1
echo Finished.
