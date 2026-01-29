#!/bin/bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export PATH=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/:$PATH

KERNELDIR=$HOME/odroid-6.6.y
CONFIGURE_KERNEL="yes"
PLATFORM_FAMILY=${PWD}

echo ""
echo "Kernel sources  :  ${KERNELDIR}"
echo "Configure kernel:  ${CONFIGURE_KERNEL}"
echo "Platform family :  ${PLATFORM_FAMILY}"
echo ""

cd ${KERNELDIR}

echo "Cleaning and preparing .config"
cp ${PLATFORM_FAMILY}/odroid-6.6.y_defconfig arch/arm64/configs/
make clean
make odroid-6.6.y_defconfig
if [ "${CONFIGURE_KERNEL}" == "yes" ]; then
  make menuconfig
  cp .config ${PLATFORM_FAMILY}/odroid-6.6.y_defconfig
fi
echo "Compiling dts, image and modules"
touch .scmversion
make -j12 Image.gz dtbs modules
echo "Done ..."

cd ${PLATFORM_FAMILY}
./mkplatform.sh






