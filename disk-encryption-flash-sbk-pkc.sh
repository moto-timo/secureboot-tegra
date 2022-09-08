#!/bin/bash
# See "How to Create an Encrypted Rootfs on the Host" at
# https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3261/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/bootloader_disk_encryption.html
cd `dirname $0`
cd Linux_for_Tegra
sudo ROOTFS_ENC=1 ./flash.sh -i "../ekb.key" -u ../rsa_priv.pem -v ../sbk_hex_file jetson-agx-xavier-devkit mmcblk0p1

# NOTE: without the ROOTFS_ENC=1 you will not see
# Using UUID b3539605-b3c1-4fe4-b2f6-ed576272826a for mounting root APP partition.
# Using UUID 76c0edf3-548e-45be-bd26-159b49bf9408 for mounting root APP_enc partition.
# Using UUID 5ad88ee8-4c22-443b-880e-6717eace7b19 for mounting boot APP partition.
# ...
# Writing partition APP with system_boot.img
# Writing partition APP_ENC with system_root_encrypted.img

# https://forums.developer.nvidia.com/t/enabling-disk-encryption-doesnt-boot-the-device-jetson-xavier-nx-p3668-0001/208615
