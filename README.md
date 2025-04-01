# AngryEDK2

EDK2 with AngryUEFI as a git submodule

## Install
1. `git clone --recurse-submodules -j8 git@github.com:AngryUEFI/AngryEDK2.git`
2. `cd AngryEDK2`
3. `./init.sh` *Note:* Takes a while, it builds 2 different targets. Can be run again if some files get deleted/changed.
4. Install dependencies xorriso mtools, qemu and qemu-system, e.g. `sudo pacman -S qemu qemu-system xorriso mtools`

## Updating
1. `git submodule update --init --recursive`

## Building
0. Follow Install section
1. `./build.sh`

## Running
1. `./run.sh`

## Docker Shell
1. `./docker-shell.sh`

## USB Boot

### BIOS/UEFI config
Some/most(?) main boards require the network stack to be enabled in the UEFI settings. This is usually called something like "Network Boot" or "Boot from onboard LAN". On some main boards you can disable the network boot options in the boot device table while keeping the network functionality.

It is recommended to disable SMT ("hyper threading") so each physical core only has one single thread. Otherwise some units, e.g. the microcode RAM, might be shared between cores in AngryUEFI leading to problems when testing different updates on different codes.

### Initial install
Flash the USB image to an empty USB stick, e.g. with dd.

### Updating AngryUEFI
After the initial install on the UBS stick, you can update AngryUEFI by replacing the AngryUEFI.efi file in the root of the USB stick.

### Booting AngryUEFI
Select the USB stick as boot device. This should pop up an UEFI shell with a 5s timer. You can either wait for the timer to expire or press any button except ESC to launch AngryUEFI. After launch AngryUEFI will get an IPv4 address via DHCP. This is usually the same as for other OSs on the same hardware. If in doubt check your DHCP server log. Once "TCP Configured." is printed on the screen AngryUEFI is ready to accept commands on port 3239.

### Boot principle
AngryUEFI requires (currently) an UEFI shell to output status information. Some/most(?) mainboards do not ship with such a shell. The USB image contains an UEFI shell as a replacement. When the USB stick is selected as UEFI boot device, it launches GRUB, which looks for a file system with the label "AngryUEFI". It then chainloads  Shellx64.efi which in turn auto executes AngryUEFI.efi based on the startup.nsh.
