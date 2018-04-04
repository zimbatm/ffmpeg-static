#!/bin/bash -eux
sudo ./prepare-ubuntu.sh
./build.sh "$@"
