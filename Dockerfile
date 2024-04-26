FROM ubuntu:noble

# Basic packages needed to download dependencies and unpack them.
RUN apt-get update && apt-get install -y \
  bzip2 \
  perl \
  tar \
  wget \
  xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Install packages necessary for compilation.
RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  bash \
  build-essential \
  cmake \
  curl \
  frei0r-plugins-dev \
  gawk \
  libfontconfig-dev \
  libfreetype6-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libsdl2-dev \
  libspeex-dev \
  libtheora-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvo-amrwbenc-dev \
  libvorbis-dev \
  libwebp-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  libxvidcore-dev \
  lsb-release \
  pkg-config \
  sudo \
  tar \
  texi2html \
  yasm \
  && rm -rf /var/lib/apt/lists/*

# Copy the build scripts.
COPY build.sh download.pl env.source fetchurl /ffmpeg-static/

VOLUME /ffmpeg-static
WORKDIR /ffmpeg-static
CMD /bin/bash
