#!/bin/bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export PATH=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/:$PATH

KERNELDIR=$HOME/odroid-6.6.y

echo ""
echo "Kernel sources  :  ${KERNELDIR}"
echo ""

cd ${KERNELDIR}

echo "Cleaning..."
make clean




