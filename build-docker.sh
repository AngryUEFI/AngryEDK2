#!/bin/bash

set -ex

# High level overview
#
# 1. Set config to build emulator
# 2. `build`

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

cd "${EDK2_DIR}"

export EDK_TOOLS_PATH="${EDK2_DIR}"/BaseTools
. edksetup.sh BaseTools

# Emulator config contains our App
cp AngryConfigs/target-EmulatorPkg.txt Conf/target.txt
build
