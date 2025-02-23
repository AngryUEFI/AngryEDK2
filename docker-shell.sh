#!/bin/bash

set -ex

# Spawn a docker shell just as it would look like when commands run

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

$DOCKER_COMMAND run "${DOCKER_ARGS[@]}" --rm -it "${DOCKER_IMAGE}" /bin/bash
