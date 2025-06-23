#!/bin/bash

# USB stick boots GRUB
# GRUB chainloads EFI shell
# EFI shell auto launches via startup.nsh AngryUEFI

set -ex

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

USB_DIRECTORY=./usb

pushd $OUTPUT_DIR

rm -f $OUTPUT_IMAGE_USB

# create a new 100MB device image

dd if=/dev/zero of=$OUTPUT_IMAGE_USB bs=1M count=100

# partition as GPT, one FAT32 EFI partition

parted "$OUTPUT_IMAGE_USB" --script mklabel gpt \
  mkpart ESP fat32 1MiB 100% \
  set 1 boot on

# figure out where partition #1 starts (in bytes)
START=$(parted "$OUTPUT_IMAGE_USB" --script unit B print |
        awk '/^ 1/ {print $2}' | sed 's/B//')

# paths to binaries
SHELL_EFI="$EDK2_DIR/Build/OvmfX64/RELEASE_GCC5/X64/Shell.efi"
ANGRY_UEFI="$EDK2_DIR/Build/AngryUEFI/AngryUEFI.efi"

# build a standalone GRUB EFI binary locally

GRUBEFI=$(mktemp)
grub-mkimage -O x86_64-efi \
  -o "$GRUBEFI" \
  -p /boot/grub \
  all_video chain configfile exfat fat normal search search_label part_gpt

# create autostart file

AUTOSTART=$(mktemp)
cat > "$AUTOSTART" << 'EOF'
AngryUEFI.efi
EOF

# create GRUB config

GRUBCFG=$(mktemp)
cat > "$GRUBCFG" << 'EOF'
insmod part_gpt
insmod fat
insmod exfat
insmod all_video
insmod chain
insmod configfile
insmod search
search --no-floppy --label AngryUEFI --set=root
chainloader /Shellx64.efi
boot
EOF

# format and populate the FAT partition entirely in userspace
#    (offset syntax: file@@bytes)
IMGOFFSET="${OUTPUT_IMAGE_USB}@@${START}"

# label & format FAT32
mformat -i "$IMGOFFSET" -F -n AngryUEFI ::

# make directories
for d in EFI EFI/boot boot boot/grub; do
  mmd -i "$IMGOFFSET" ::/"$d"
done

# copy EFI binaries & grub
mcopy -i "$IMGOFFSET" "$SHELL_EFI"      ::/Shellx64.efi
mcopy -i "$IMGOFFSET" "$ANGRY_UEFI"      ::/AngryUEFI.efi
mcopy -i "$IMGOFFSET" "$GRUBEFI"        ::/EFI/boot/bootx64.efi
mcopy -i "$IMGOFFSET" "$GRUBCFG"        ::/boot/grub/grub.cfg
mcopy -i "$IMGOFFSET" "$AUTOSTART"      ::/startup.nsh


# clean up
rm -f "$GRUBEFI" "$GRUBCFG" "$AUTOSTART"

# compress the image
tar czf ${OUTPUT_IMAGE_USB}.tar.bz2 ${OUTPUT_IMAGE_USB}

popd
