#!/bin/bash

set -ex

# Set some common variables for all scripts

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# replace with sudo docker or similar if needed
DOCKER_COMMAND=docker

DOCKER_ARGS=(-v "${EDK2_DIR}":"${EDK2_DIR}" -i -e EDK2_DOCKER_USER_HOME="${EDK2_DIR}")
if [ "$CI_RUN" != "1" ]; then
  DOCKER_ARGS+=( -t )
fi
DOCKER_IMAGE=ghcr.io/tianocore/containers/ubuntu-22-dev

OUTPUT_DIR="${EDK2_DIR}"/Build/AngryUEFI
OUTPUT_IMAGE=AngryUEFI.img
OUTPUT_IMAGE_USB=AngryUEFI_USB.img
