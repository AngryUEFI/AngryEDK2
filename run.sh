#!/bin/bash

set -ex

# High level overview
#
# 1. Run qemu-system with network, BIOS and disk image

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=$OUTPUT_DIR/OVMF_CODE-pure-efi.fd \
  -drive if=pflash,format=raw,file=$OUTPUT_DIR/OVMF_VARS-pure-efi.fd \
  -drive if=none,id=stick,format=raw,file=$OUTPUT_DIR/$OUTPUT_IMAGE \
  -device nec-usb-xhci,id=xhci \
  -device usb-storage,bus=xhci.0,drive=stick \
  -netdev user,id=net0,hostfwd=tcp::3239-:3239 \
  -device e1000,netdev=net0 \
  -d guest_errors -serial stdio
