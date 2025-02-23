#!/bin/bash

set -ex

# High level overview
#
# 1. Build tools
# 2. Build OVMF BIOS
# 3. Build Emulator config
# 4. Copy bios to Emulator output dir

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

cd "${EDK2_DIR}"

# Base Tools
make -j$(nproc) -C BaseTools
export EDK_TOOLS_PATH="${EDK2_DIR}"/BaseTools
. edksetup.sh BaseTools

# OVMF BIOS
cp AngryConfigs/target-OVMF.txt Conf/target.txt
build

# MdeModulePkg
cp AngryConfigs/target-MdeModulePkg.txt Conf/target.txt
build

# Emulator
cp AngryConfigs/target-EmulatorPkg.txt Conf/target.txt
build
