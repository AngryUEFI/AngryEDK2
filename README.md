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
