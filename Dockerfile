FROM ubuntu:16.04

RUN mkdir -p /ffmpeg-static
WORKDIR /ffmpeg-static
COPY prepare-ubuntu.sh /ffmpeg-static/
RUN \
  apt-get update && \
  ./prepare-ubuntu.sh && \
  rm -rf /var/lib/apt/lists/*

# Copy the build scripts.
COPY build.sh download.pl env.source fetchurl /ffmpeg-static/
RUN ./build.sh
