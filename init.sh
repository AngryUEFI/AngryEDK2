#!/bin/bash

set -ex

# High level overview
#
# 1. pull docker container
# 2. launch docker container with mapped working tree in /workspaces/AngryEDK2
# 3. execute init-docker.sh in docker container

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${EDK2_DIR}"/angry-vars.sh

$DOCKER_COMMAND pull "${DOCKER_IMAGE}"
# the container is just used to init the local directory, it can be removed afterwards
$DOCKER_COMMAND run "${DOCKER_ARGS[@]}" --rm -it "${DOCKER_IMAGE}" "${EDK2_DIR}"/init-docker.sh