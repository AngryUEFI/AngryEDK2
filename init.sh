#!/bin/bash

# High level overview
#
# 1. pull docker container
# 2. launch docker container with mapped working tree in /workspaces/AngryEDK2
# 3. execute init-docker.sh in docker container

EDK2_DIR=$(dirname "$0")

source "${EDK2_DIR}"/angry-vars.sh

$DOCKER_COMMAND pull "${DOCKER_IMAGE}"
# the container is just used to init the local directory, it can be removed afterwards
$DOCKER_COMMAND run --rm -it "${DOCKER_IMAGE}" "${EDK2_DIR}"/init-docker.sh