#!/bin/bash

cat ./BootShim/AARCH64/BootShim.bin "./Build/r8sPkg-AARCH64/${_TARGET_BUILD_MODE}_CLANG38/FV/R8S_UEFI.fd" > "./ImageResources/bootpayload.bin"||exit 1

python3 ./ImageResources/mkbootimg.py \
  --kernel ./ImageResources/bootpayload.bin \
  --ramdisk ./ImageResources/ramdisk \
  --dtb "./ImageResources/DTBs/r8s.dtb" \
  --tags_offset 0x00000100 \
  --ramdisk_offset 0x01000000 \
  --pagesize 2048 \
  --os_version "13.0.0" \
  --os_patch_level "2023-08" \
  --kernel_offset 0x00008000 \
  --header_version 2  \
  --cmdline "buildvariant=userdebug" \
  --board "" \
  --base 0x10000000 \
  -o "boot.img" \
  ||_error "\nFailed to create Android Boot Image!\n"

# Compress Boot Image in a tar File for Odin/heimdall Flash
tar -c boot.img -f Mu-r8s.tar||exit 1
mv boot.img Mu-r8s.img||exit 1
