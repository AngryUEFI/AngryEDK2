#!/bin/bash

set -ex

# High level overview
#
# 1. Construct FAT32 image

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

pushd $OUTPUT_DIR

rm -f $OUTPUT_IMAGE
dd if=/dev/zero of=$OUTPUT_IMAGE bs=1k count=1440
mformat -i $OUTPUT_IMAGE -f 1440 ::
mmd -i $OUTPUT_IMAGE ::/EFI
mmd -i $OUTPUT_IMAGE ::/EFI/BOOT
#cp AngryUEFI.efi BOOTX64.EFI
#mcopy -i $OUTPUT_IMAGE BOOTX64.EFI ::/EFI/BOOT
mcopy -i $OUTPUT_IMAGE AngryUEFI.efi ::/
echo "AngryUEFI.efi" > startup.nsh
mcopy -i $OUTPUT_IMAGE startup.nsh ::/EFI/BOOT

popd
