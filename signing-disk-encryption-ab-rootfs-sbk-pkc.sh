#!/bin/bash
# See "How to Create an Encrypted Rootfs on the Host" at
# https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3261/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/bootloader_disk_encryption.html
cd `dirname $0`
cd Linux_for_Tegra
sudo ROOTFS_ENC=1 ./flash.sh --no-flash -c ./bootloader/t186ref/cfg/flash_l4t_t186_enc_rootfs_ab.xml -i ../ekb.key -u ../rsa_priv.pem -v ../sbk_hex_file jetson-agx-xavier-devkit mmcblk0p1
