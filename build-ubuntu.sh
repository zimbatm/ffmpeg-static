#!/bin/bash

apt-get install build-essential curl tar pkg-config
apt-get -y --force-yes install \
	autoconf \
	automake \
	build-essential \
	libass-dev \
	libfreetype6-dev \
	libsdl1.2-dev \
	libtheora-dev \
	libtool \
	libva-dev \
	libvdpau-dev \
	libvorbis-dev \
	libxcb1-dev \
	libxcb-shm0-dev \
	libxcb-xfixes0-dev \
	pkg-config \
	texi2html \
	zlib1g-dev

# FOR 12.04
# libx265 requires cmake version >= 2.8.8
# 12.04 only have 2.8.7
add-apt-repository ppa:roblib/ppa
apt-get update
apt-get install cmake

./build.sh
