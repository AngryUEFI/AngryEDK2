#!/bin/bash

set -ex

# Set some common variables for all scripts

EDK2_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# replace with sudo docker or similar if needed
DOCKER_COMMAND=docker

DOCKER_ARGS=(-v "${EDK2_DIR}":"${EDK2_DIR}" -e EDK2_DOCKER_USER_HOME="${EDK2_DIR}")
DOCKER_IMAGE=ghcr.io/tianocore/containers/ubuntu-22-dev
