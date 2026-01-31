#!/bin/bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export PATH=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/:$PATH
export INSTALL_MOD_STRIP=1

KERNELDIR=$HOME/odroid-6.6.y
PLATFORM_FAMILY=${PWD}
PLATFORM_DEVICE=${PLATFORM_FAMILY}/odroidv4

echo ""
echo "Kernel sources:   ${KERNELDIR}"
echo "Strip debug info: ${INSTALL_MOD_STRIP}"
echo "Platform family:  ${PLATFORM_FAMILY}"
echo "Platform device:  ${PLATFORM_DEVICE}"
echo ""

rm -r ${PLATFORM_DEVICE}
mkdir -p ${PLATFORM_DEVICE}
mkdir -p ${PLATFORM_DEVICE}/boot/amlogic/overlays/odroidc4
mkdir -p ${PLATFORM_DEVICE}/boot/amlogic/overlays/odroidn2
mkdir -p ${PLATFORM_DEVICE}/etc
mkdir -p ${PLATFORM_DEVICE}/lib/firmware
mkdir -p ${PLATFORM_DEVICE}/uboot
mkdir -p ${PLATFORM_DEVICE}/soundsettings

cd ${KERNELDIR}
if [ ! -f arch/arm64/boot/Image ]; then
  echo "No kernel found, please run 'build-kernel' first"
  echo ""
  exit
fi

cp arch/arm64/boot/Image ${PLATFORM_DEVICE}/boot
cp arch/arm64/boot/dts/amlogic/meson64_odroidc4.dtb ${PLATFORM_DEVICE}/boot/amlogic
cp arch/arm64/boot/dts/amlogic/overlays/odroidc4/*.dtbo ${PLATFORM_DEVICE}/boot/amlogic/overlays/odroidc4
cp arch/arm64/boot/dts/amlogic/meson64_odroidn2.dtb ${PLATFORM_DEVICE}/boot/amlogic
cp arch/arm64/boot/dts/amlogic/meson64_odroidn2_plus.dtb ${PLATFORM_DEVICE}/boot/amlogic
cp arch/arm64/boot/dts/amlogic/overlays/odroidn2/*.dtbo ${PLATFORM_DEVICE}/boot/amlogic/overlays/odroidn2

kver=`make kernelrelease`
cp ${PLATFORM_FAMILY}/odroid-6.6.y_defconfig ${PLATFORM_DEVICE}/boot/config-${kver}
make modules_install ARCH=arm64 INSTALL_MOD_PATH=${PLATFORM_DEVICE}

echo "Compiling and copying overlay(s) files"
for dts in "${PLATFORM_FAMILY}"/overlay_user/odroidn2/*.dts; do
  dts_file=${dts%%.*}
  if [ -s "${dts_file}.dts" ]
  then
    echo "Compiling ${dts_file}"
    dtc -O dtb -o "${dts_file}.dtbo" "${dts_file}.dts"
    cp "${dts_file}.dtbo" "${PLATFORM_DEVICE}/boot/amlogic/overlays/odroidn2"
  fi
done

echo "Creating platform tar files"
cd ${PLATFORM_FAMILY}
cp -pdR etc ${PLATFORM_DEVICE}
cp -pdR firmware ${PLATFORM_DEVICE}/lib
cp -pdR soundsettings ${PLATFORM_DEVICE}

echo "... odroidn2"
cp configs/odroidn2/* ${PLATFORM_DEVICE}/boot
cp uboot/odroidn2/*  ${PLATFORM_DEVICE}/uboot
tar cfJ odroidn2.tar.xz --transform='s/odroidv4/odroidn2/' ./odroidv4

echo "... odroidc4"
cp configs/odroidc4/* ${PLATFORM_DEVICE}/boot
cp uboot/odroidc4/*  ${PLATFORM_DEVICE}/uboot
tar cfJ odroidc4.tar.xz --transform='s/odroidv4/odroidc4/' ./odroidv4

rm -r ${PLATFORM_DEVICE}
echo "Done ..."
