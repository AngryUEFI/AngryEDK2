# AngryEDK2

EDK2 with AngryUEFI as a git submodule

## Install
1. `git clone --recurse-submodules -j8 git@github.com:AngryUEFI/AngryEDK2.git`
2. `init.sh`
3. Install depdencies qemu and qemu-system, e.g. `sudo pacman -S qemu qemu-system`

## Updating
1. `git submodule update --init --recursive`

## Building
0. Follow Install section
1. `build.sh`

## Running
1. `run.sh`
