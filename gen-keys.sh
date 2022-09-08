#!/bin/bash

## Generating the RSA Key Pair
#
# Secureboot requires an RSA key-pair whose length is 2048 bits (RSA 2K) or 3072‑bits (RSA 3K).
#
# The key file is used to burn fuse and sign boot files for Jetson devices.
# The security of your device depends on how securely you keep the key file.
#
# To ensure the security of the key file, restrict access permission to
# a minimum number of personnel.
#echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k Private key pem)"
# openssl genrsa -out rsa_priv.pem 2048
#echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k  Public key pem)"
# openssl rsa -in rsa_priv.pem -outform PEM -pubout -out rsa_pub.pem
echo "Generating PKC (Public Key Cryptogrpahy = RSA 3k Private key pem)"
 openssl genrsa -out rsa_priv.pem 3072
echo "Generating PKC (Public Key Cryptogrpahy = RSA 3k  Public key pem)"
 openssl rsa -in rsa_priv.pem -outform PEM -pubout -out rsa_pub.pem

# KEK keys are used for other security applications
# For instance, KEK2 can be used for LUKS disk encryption
#
#echo "Generating KEK0 (Key Encryption Key)"
# openssl rand -rand /dev/urandom -hex 16 > kek0_hex_file
#echo "Generating KEK1 (Key Encryption Key)"
# openssl rand -rand /dev/urandom -hex 16 > kek1_hex_file
echo "Generating KEK2 (Key Encryption Key)"
 openssl rand -rand /dev/urandom -hex 16 > kek2_hex_file

# KEK256 option uses 256 bits but is stored in KEK0 and KEK1
# For the strongest encryption, we will opt for the KEK256 option
echo "Generating KEK256 (Key Encryption Key)"
 openssl rand -rand /dev/urandom -hex 32 > kek256_hex_file

## Preparing the SBK Key
#
# If you want to encrypt Bootloader (and TOS), you must prepare the SBK fuse bits.
#
# Note:
#      You may only use the SBK key with the PKC key. The encryption mode
#      that uses these two keys together is called SBKPKC.
#
# The SBK key consists of four 32-bit words stored in a file in big-endian
# hexadecimal format. Here is an example of an SBK key file:
#
#   0x12345678 0x9abcdef0 0xfedcba98 0x76543210
echo "Generating SBK (Secure Boot Key)"
raw_hex=$(openssl rand -rand /dev/urandom -hex 16)
echo "0x${raw_hex:0:8} 0x${raw_hex:8:8} 0x${raw_hex:16:8} 0x${raw_hex:(-8)}" > sbk_hex_file

# If you want to encrypt kernel image (the kernel, kernel-dtb, initrd,
# and extlinux.conf files), you must prepare the user key. You need the
# user key as well as the SBK key and the PKC key.
#
# Two formats are needed, one is used with the flash.sh or similar commands the other is
# used in gen_ekb.py to generate eks.img
echo "Generating user_key"
raw_hex=$(openssl rand -rand /dev/urandom -hex 16)
echo "${raw_hex}" > user_key_for_eks_hex_file
echo "0x${raw_hex:0:8} 0x${raw_hex:8:8} 0x${raw_hex:16:8} 0x${raw_hex:(-8)}" > user_key_for_flash_hex_file

# For disk encryption
echo "Generating  ekb.key"
# 32.6.1 docs say
#echo "00000000000000000000000000000000" > ekb.key
# 32.7.1 docs say
#echo "96cdb5da247b37bb536e9f5506d37e52" > ekb.key
openssl rand -rand /dev/urandom -hex 16 > ekb.key

echo "Generating Fixed Vector (FV)"
# This is the default initial vector for EKB.
echo "bad66eb4484983684b992fe54a648bb8" > fv_ekb_hex_file
# Only if you are recompiling the hwkey-agent and luks-srv Trusted Applications (TA) and the Trusted Operating System (TOS)
# Otherwise you need to use the default
#openssl rand -rand /dev/urandom -hex 16 > fv_ekb_hex_file
# You can use multiple Fixed Vectors, for instance for the SSK
#openssl rand -rand /dev/urandom -hex 16 > fv_ssk_hex_file

# https://forums.developer.nvidia.com/t/enabling-disk-encryption-doesnt-boot-the-device-jetson-xavier-nx-p3668-0001/208615
# (which references https://forums.developer.nvidia.com/t/encrypted-filesystem-works-on-32-6-1-but-not-on-32-5-1/205243)
# python3 ${GEN_EKB_PATH}/gen_ekb.py -kek2_key ${XAVIER_KEYS}/kek2_hex_file -fv ${XAVIER_KEYS}/fv_hex_file -in_sym_key ${XAVIER_KEYS}/user_key_for_eks_hex_file -in_sym_key2 ${XAVIER_KEYS}/ekb.key -out eks.img
