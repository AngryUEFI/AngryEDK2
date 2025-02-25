#!/bin/bash

set -ex

# Convert file $1 into a C header and store it at $2

xxd -i "$1" > "$2"
