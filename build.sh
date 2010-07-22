#!/bin/sh

set -e
set -u

cd `dirname $0`
rm -rf build target
mkdir -p build target
ROOT=`readlink -f .`
BUILD=`readlink -f build`
TARGET=`readlink -f target`
export LDFLAGS="-L${TARGET}/lib"
#export CFLAGS="-I${TARGET}/include $LDFLAGS -static-libgcc -Wl,-Bstatic -lc"
export CFLAGS="-I${TARGET}/include $LDFLAGS"


cd $BUILD
../fetchurl "http://www.tortall.net/projects/yasm/releases/yasm-1.0.1.tar.gz"
cd yasm-1.0.1
./configure --prefix=$TARGET
make -j 4 && make install

cd $BUILD
../fetchurl "http://zlib.net/zlib-1.2.5.tar.bz2"
cd zlib-1.2.5
./configure --prefix=$TARGET 
make -j 4 && make install

cd $BUILD
../fetchurl "http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz"
cd bzip2-1.0.5
make
make install PREFIX=$TARGET

# Ogg before vorbis
cd $BUILD
../fetchurl "http://downloads.xiph.org/releases/ogg/libogg-1.2.0.tar.gz"
cd libogg-1.2.0
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

# Vorbis before theora
cd $BUILD
../fetchurl "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.1.tar.bz2"
cd libvorbis-1.3.1
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
../fetchurl "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
cd libtheora-1.1.1
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
../fetchurl "http://webm.googlecode.com/files/libvpx-0.9.1.tar.bz2"
cd libvpx-0.9.1
./configure --prefix=$TARGET --disable-shared
make -j 4 && make install

cd $BUILD
../fetchurl "http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.bz2?use_mirror=auto"
cd faac-1.28
./configure --prefix=$TARGET --enable-static --disable-shared
# FIXME: gcc incompatibility
sed -i -e "s|^char \*strcasestr.*|//\0|" common/mp4v2/mpeg4ip.h 
make -j 4 && make install

cd $BUILD
../fetchurl "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20100620-2245.tar.bz2"
cd x264-*
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
../fetchurl "http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.bz2"
cd xvidcore/build/generic
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install
rm $TARGET/lib/libxvidcore.so.*

cd $BUILD
../fetchurl "http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz?use_mirror=auto"
cd lame-3.98.4
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install


# FFMpeg
cd $BUILD
../fetchurl "http://www.ffmpeg.org/releases/ffmpeg-0.6.tar.gz"
cd ffmpeg-0.6
./configure --prefix=${TARGET} --extra-version=static --disable-debug --disable-shared --enable-static --extra-cflags=--static --disable-ffplay --disable-ffserver --disable-doc --enable-gpl --enable-pthreads --enable-postproc --enable-gray --enable-runtime-cpudetect --enable-libfaac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-bzlib --enable-zlib --enable-nonfree --enable-version3 --enable-libvpx --disable-devices
make -j 4 && make install
