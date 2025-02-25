#!/bin/bash

set -ex

# High level overview
#
# 1. Run docker container
# 2. Run build-docker.sh in docker container
# 3. Run prepare-image.sh
# 4. Copy outputs to Build/AngryUEFI/

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh
$DOCKER_COMMAND run "${DOCKER_ARGS[@]}" --rm -it "${DOCKER_IMAGE}" "${EDK2_DIR}"/build-docker.sh "$@"

cp "${EDK2_DIR}"/Build/EmulatorX64/DEBUG_GCC5/X64/AngryUEFI.efi "${OUTPUT_DIR}"

"${EDK2_DIR}"/prepare-image.sh
