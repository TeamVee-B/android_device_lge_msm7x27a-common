#!/system/bin/sh
# Copyright (c) 2015, TeamHackLG. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# No path is set up at this point so we have to do it here.
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

# Set baseband based on modem
basebandcheck=`getprop gsm.version.baseband | grep -o -e "V10" -e "V20"`
case "$basebandcheck" in
	"" | "V10") setprop gsm.version.baseband `strings /dev/block/mmcblk0p12 | grep -e "-V10.-" -e "-V20.-" | head -1` ;;
esac

# Get device based on baseband
deviceset=`getprop gsm.version.baseband | grep -o -e "E610" -e "E612" -e "E617" -e "P700" -e "P705" | head -1`

# ReMount /system to Read-Write
mount -o rw,remount /system

# Set Variant in build.prop
case "$deviceset" in
	"E610") busybox sed -i '/ro.product.model=L5/c\ro.product.model=E610 (L5 Single NFC)' system/build.prop ;;
	"E612") busybox sed -i '/ro.product.model=L5/c\ro.product.model=E612 (L5 Single)' system/build.prop ;;
	"E617") busybox sed -i '/ro.product.model=L5/c\ro.product.model=E617 (L5 Single)' system/build.prop ;;
	"P700") busybox sed -i '/ro.product.model=L7/c\ro.product.model=P700 (L7 Single NFC)' system/build.prop ;;
	"P705") busybox sed -i '/ro.product.model=L7/c\ro.product.model=P705 (L7 Single)' system/build.prop ;;
esac

# ReMount /system to Read-Only
mount -o ro,remount /system

# Set essential configs
echo `getprop ro.serialno` > /sys/class/android_usb/android0/iSerial
echo `getprop ro.product.manufacturer` > /sys/class/android_usb/android0/iManufacturer
echo `getprop ro.product.manufacturer` > /sys/class/android_usb/android0/f_rndis/manufacturer
echo `getprop ro.product.model` > /sys/class/android_usb/android0/iProduct
