#!/bin/bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export PATH=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/:$PATH

KERNELDIR=$HOME/odroid-6.6.y
PLATFORM_FAMILY=${PWD}

echo ""
echo "Kernel sources  :  ${KERNELDIR}"
echo "Platform family :  ${PLATFORM_FAMILY}"
echo ""

cd ${KERNELDIR}

echo "Cleaning and preparing .config"
cp ${PLATFORM_FAMILY}/odroid-6.6.y_defconfig arch/arm64/configs/
make clean
make odroid-6.6.y_defconfig
make menuconfig
echo "Saving current odroid-6.6.y_defconfig from .config"
cp .config ${PLATFORM_FAMILY}/odroid-6.6.y_defconfig
echo "Done..."



