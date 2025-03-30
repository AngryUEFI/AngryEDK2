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

# create an UEFI partition

parted $OUTPUT_IMAGE_USB --script mklabel gpt
parted $OUTPUT_IMAGE_USB --script mkpart ESP fat32 1MiB 100%
parted $OUTPUT_IMAGE_USB --script set 1 boot on

# loop mount the device

LOOP=$(sudo losetup --show -fP $OUTPUT_IMAGE_USB)

# format the first partition

sudo mkfs.vfat -F32 ${LOOP}p1
sudo fatlabel ${LOOP}p1 AngryUEFI

# mount ESP and create necessary files

mkdir -p $USB_DIRECTORY
sudo mount -o uid=`id -u` -o gid=`id -g` ${LOOP}p1 $USB_DIRECTORY
mkdir -p $USB_DIRECTORY/EFI/boot
mkdir -p $USB_DIRECTORY/boot/grub

# copy UEFI shell & AngryUEFI

cp "${EDK2_DIR}"/Build/OvmfX64/RELEASE_GCC5/X64/Shell.efi $USB_DIRECTORY/Shellx64.efi
cp "${EDK2_DIR}"/Build/AngryUEFI/AngryUEFI.efi $USB_DIRECTORY/AngryUEFI.efi

# create autostart file

cat << 'EOF' > $USB_DIRECTORY/startup.nsh
AngryUEFI.efi
EOF

# install GRUB

grub-mkimage -O x86_64-efi -o $USB_DIRECTORY/EFI/boot/bootx64.efi -p /boot/grub all_video chain configfile exfat fat normal search search_label part_gpt

# create GRUB config

cat > $USB_DIRECTORY/boot/grub/grub.cfg << 'EOF'
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

# unmount & clean up

sudo umount $USB_DIRECTORY
rm -rf $USB_DIRECTORY
sudo losetup -d $LOOP

popd
