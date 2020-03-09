#!/bin/bash

# Install needed updates
sudo apt install build-essential g++ gcc pkg-config tar
# Install needed tools
sudo apt install autoconf automake cmake curl gawk git gperf libtool ragel texi2html
# Install dependencies (only add if you don't build them yourself)
sudo apt install libgdbm-dev libsqlite3-dev libreadline6-dev libssl-dev libncurses5-dev #Python (maybe others) dependencies #libx11-dev
sudo apt install \
  frei0r-plugins-dev \
  libass-dev \
  libbz2-dev \
  libcairo2-dev \
  libsdl1.2-dev \
  libva-dev \
  libvdpau-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
#  libfreetype6-dev \
#  libglib2.0-dev \
#  libopencore-amrnb-dev \
#  libopencore-amrwb-dev \
#  libspeex-dev \
#  libssl-dev \
#  libtheora-dev \
#  libvo-amrwbenc-dev \
#  libvorbis-dev \
#  libwebp-dev \
#  libxvidcore-dev \
#  zlib1g-dev
#  libcaca-dev \

# For 12.04
# libx265 requires cmake version >= 2.8.8
# 12.04 only have 2.8.7
ubuntu_version=`lsb_release -rs`
need_ppa=`echo $ubuntu_version'<=12.04' | bc -l`
if [ $need_ppa -eq 1 ]; then
    sudo add-apt-repository ppa:roblib/ppa
    sudo apt-get update
    sudo apt-get install cmake
fi

./build.sh "$@"
