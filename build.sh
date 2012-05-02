#!/bin/bash

OUTDIR="/android/t1/out"
INITRAMFSDIR="/android/t1/ramdisk"
TOOLCHAIN="/android/gingerbread/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
MODULES=("crypto/pcbc.ko" "drivers/bluetooth/bthid/bthid.ko" "drivers/media/video/gspca/gspca_main.ko" "drivers/media/video/omapgfx/gfx_vout_mod.ko" "drivers/scsi/scsi_wait_scan.ko" "drivers/net/wireless/bcm4330/dhd.ko" "drivers/staging/ti-st/bt_drv.ko" "drivers/staging/omap_hsi/hsi_char.ko" "drivers/staging/ti-st/fm_drv.ko" "drivers/staging/ti-st/gps_drv.ko" "drivers/staging/ti-st/st_drv.ko" "samsung/fm_si4709/Si4709_driver.ko" "samsung/j4fs/j4fs.ko" "samsung/param/param.ko" "samsung/vibetonz/vibetonz.ko")

cd kernel
case "$1" in
	clean)
        make mrproper ARCH=arm CROSS_COMPILE=$TOOLCHAIN
		;;
	*)
        make t1_defconfig ARCH=arm CROSS_COMPILE=$TOOLCHAIN

        make -j8 ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE=$INITRAMFSDIR modules
        
        for module in "${MODULES[@]}" ; do
            cp "$module" $INITRAMFSDIR/lib/modules/
        done
        
        make -j8 ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE=$INITRAMFSDIR zImage
        cp arch/arm/boot/zImage ${OUTDIR}
	;;
esac
