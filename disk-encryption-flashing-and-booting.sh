#!/bin/bash
# See "How to Create an Encrypted Rootfs on the Host" at
# https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3261/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/bootloader_disk_encryption.html
cd `dirname $0`
cd Linux_for_Tegra
sudo ./flash.sh -i "../ekb.key" jetson-agx-xavier-devkit mmcblk0p1
