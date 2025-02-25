#!/bin/bash

set -ex

# High level overview
#
# 1. Set config to build emulator
# 2. `build`

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

# Assume the host passed: --build_arguments='--arg1=val1 --arg2=val2'
# Loop through the arguments to find the build_arguments parameter.
for arg in "$@"; do
    case $arg in
        --build_arguments=*)
            build_arguments="${arg#*=}"
            ;;
    esac
done

# Split the build_arguments string into an array.
read -r -a build_args_array <<< "$build_arguments"

cd "${EDK2_DIR}"

export EDK_TOOLS_PATH="${EDK2_DIR}"/BaseTools
. edksetup.sh BaseTools

# Emulator config contains our App
cp AngryConfigs/target-EmulatorPkg.txt Conf/target.txt
build "${build_args_array[@]}"
