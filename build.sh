#!/bin/sh

set -e
set -u

cd `dirname $0`
ENV_ROOT=`pwd`
. env.source
LOG_FILE="$ENV_ROOT"/build-`date +%Y-%m-%d@%Hh%M`.log

rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR"

# NOTE: this is a fetchurl parameter, nothing to do with the current script
#export TARGET_DIR_DIR="$BUILD_DIR"

log() {
  echo $ $@  
  #$@ 1>"$LOG_FILE" 2>&1
  $@ 1>"$LOG_FILE"
}

echo "# FFmpeg static build, by STVS SA"
log cd $BUILD_DIR
log ../fetchurl "http://www.tortall.net/projects/yasm/releases/yasm-1.0.1.tar.gz"
log ../fetchurl "http://zlib.net/zlib-1.2.5.tar.bz2"
log ../fetchurl "http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz"
log ../fetchurl "http://downloads.xiph.org/releases/ogg/libogg-1.2.0.tar.gz"
log ../fetchurl "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.1.tar.bz2"
log ../fetchurl "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
log ../fetchurl "http://webm.googlecode.com/files/libvpx-0.9.1.tar.bz2"
log ../fetchurl "http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.bz2?use_mirror=auto"
log ../fetchurl "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20100620-2245.tar.bz2"
log ../fetchurl "http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.bz2"
log ../fetchurl "http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz?use_mirror=auto"
log ../fetchurl "http://www.ffmpeg.org/releases/ffmpeg-0.6.tar.gz"

log cd "$BUILD_DIR/yasm-1.0.1"
log ./configure --prefix=$TARGET_DIR
log make -j 4 && make install

log cd "$BUILD_DIR/zlib-1.2.5"
log ./configure --prefix=$TARGET_DIR 
log make -j 4 && make install

log cd "$BUILD_DIR/bzip2-1.0.5"
log make
log make install PREFIX=$TARGET_DIR

# Ogg before vorbis
log cd "$BUILD_DIR/libogg-1.2.0"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install

# Vorbis before theora
log cd "$BUILD_DIR/libvorbis-1.3.1"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install


log cd "$BUILD_DIR/libtheora-1.1.1"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install


log cd "$BUILD_DIR/libvpx-0.9.1"
log ./configure --prefix=$TARGET_DIR --disable-shared
log make -j 4 && make install


log cd "$BUILD_DIR/faac-1.28"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
# FIXME: gcc incompatibility, does not work with log()
sed -i -e "s|^char \*strcasestr.*|//\0|" common/mp4v2/mpeg4ip.h
log make -j 4 && make install


log cd "$BUILD_DIR/x264-snapshot-20100620-2245"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install


log cd "$BUILD_DIR/xvidcore/build/generic"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install
#log rm $TARGET_DIR/lib/libxvidcore.so.*

log cd "$BUILD_DIR/lame-3.98.4"
log ./configure --prefix=$TARGET_DIR --enable-static --disable-shared
log make -j 4 && make install

# FIXME: only OS-sepcific
log rm "$TARGET_DIR/lib/*.dylib"
log rm "$TARGET_DIR/lib/*.so"

# FFMpeg
log cd "$BUILD_DIR/ffmpeg-0.6"
log ./configure --prefix=${TARGET_DIR} --extra-version=static --disable-debug --disable-shared --enable-static --extra-cflags=--static --disable-ffplay --disable-ffserver --disable-doc --enable-gpl --enable-pthreads --enable-postproc --enable-gray --enable-runtime-cpudetect --enable-libfaac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-bzlib --enable-zlib --enable-nonfree --enable-version3 --enable-libvpx --disable-devices
log make -j 4 && make install
