#!/bin/sh

set -e
set -u

cd `dirname $0`
rm -rf build target
mkdir -p build target
ROOT=`readlink -f .`
CACHE=`readlink -f cache`
BUILD=`readlink -f build`
TARGET=`readlink -f target`
export LDFLAGS="-L${TARGET}/lib"
#export CFLAGS="-I${TARGET}/include $LDFLAGS -static-libgcc -Wl,-Bstatic -lc"
export CFLAGS="-I${TARGET}/include $LDFLAGS"

cd $BUILD
tar xzvf $CACHE/yasm-1.0.1.tar.gz
cd yasm-1.0.1
./configure --prefix=$TARGET
make -j 4 && make install

cd $BUILD
tar xjvf $CACHE/zlib-1.2.5.tar.bz2
cd zlib-1.2.5
./configure --prefix=$TARGET 
make -j 4 && make install

cd $BUILD
tar xzvf $CACHE/bzip2-1.0.5.tar.gz
cd bzip2-1.0.5
make
make install PREFIX=$TARGET

# Ogg before vorbis
cd $BUILD
tar xzvf $CACHE/libogg-1.2.0.tar.gz
cd libogg-1.2.0
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

# Vorbis before theora
cd $BUILD
tar xjvf $CACHE/libvorbis-1.3.1.tar.bz2
cd libvorbis-1.3.1
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
tar xjvf $CACHE/libtheora-1.1.1.tar.bz2
cd libtheora-1.1.1
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
cp -r $CACHE/libvpx .
cd libvpx
./configure --prefix=$TARGET --disable-shared
make -j 4 && make install

cd $BUILD
tar xjvf $CACHE/faac-1.28.tar.bz2
cd faac-1.28
./configure --prefix=$TARGET --enable-static --disable-shared
# FIXME: gcc incompatibility
sed -i -e "s|^char \*strcasestr.*|//\0|" common/mp4v2/mpeg4ip.h 
make -j 4 && make install

cd $BUILD
tar xjvf $CACHE/x264-snapshot-*.tar.bz2
cd x264-*
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install

cd $BUILD
tar xjvf $CACHE/xvidcore-1.2.2.tar.bz2 
cd xvidcore/build/generic
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install
rm $TARGET/lib/libxvidcore.so.*

cd $BUILD
tar xzvf $CACHE/lame-3.98.4.tar.gz
cd lame-3.98.4
./configure --prefix=$TARGET --enable-static --disable-shared
make -j 4 && make install


# FFMpeg
cd $BUILD
cp -r $CACHE/ffmpeg .
cd ffmpeg
./configure --prefix=${TARGET} --extra-version=static --disable-debug --disable-shared --enable-static --extra-cflags=--static --disable-ffplay --disable-ffserver --disable-doc --enable-gpl --enable-pthreads --enable-postproc --enable-gray --enable-runtime-cpudetect --enable-libfaac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-bzlib --enable-zlib --enable-nonfree --enable-version3 --enable-libvpx --disable-devices
make -j 4 && make install

