#!/bin/sh

set -e
set -u

jflag=
jval=2
static=1

while getopts 'j:d' OPTION
do
  case $OPTION in
  j)	jflag=1
        	jval="$OPTARG"
	        ;;
  d)    static=0
	  	;;
  ?)	printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%)\n" $(basename $0) >&2
		exit 2
		;;
  esac
done
shift $(($OPTIND - 1))

if [ "$jflag" ]
then
  if [ "$jval" ]
  then
    printf "Option -j specified (%d)\n" $jval
  fi
fi

if [ "$static" = "1" ]
then
	static_opt_enable_static="--enable-static"
	static_opt_disable_shared="--disable-shared"
	static_opt="-static"
	dynamic_opt_enable_shared=""
else
	static_opt_enable_static=""
	static_opt_disable_shared=""
	static_opt=""
	dynamic_opt_enable_shared="--enable-shared"
fi

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR"

# NOTE: this is a fetchurl parameter, nothing to do with the current script
#export TARGET_DIR_DIR="$BUILD_DIR"

if [ "$static" = "1" ]
then
	echo "#### FFmpeg static build, by STVS SA ####"
else
	echo "#### FFmpeg dynamic build, by STVS SA ####"
fi

cd $BUILD_DIR
../fetchurl "http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz"
../fetchurl "http://zlib.net/zlib-1.2.8.tar.gz"
../fetchurl "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
../fetchurl "http://downloads.sf.net/project/libpng/libpng15/older-releases/1.5.14/libpng-1.5.14.tar.gz"
../fetchurl "http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz"
../fetchurl "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz"
../fetchurl "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
../fetchurl "http://webm.googlecode.com/files/libvpx-v1.1.0.tar.bz2"
../fetchurl "http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.bz2"
../fetchurl "ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2"
../fetchurl "http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz"
../fetchurl "http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"
../fetchurl "http://www.ffmpeg.org/releases/ffmpeg-2.1.tar.bz2"

echo "*** Building yasm ***"
cd $BUILD_DIR/yasm*
./configure --prefix=$TARGET_DIR
make -j $jval
make install

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
./configure --prefix=$TARGET_DIR
make -j $jval
make install

echo "*** Building bzip2 ***"
cd $BUILD_DIR/bzip2*
make
make install PREFIX=$TARGET_DIR

# libpng only in static build. otherwise just link the system libpng.
# this causes trouble otherwise (Mac: crashing pkg-config where ImageIO misses symbols in libpng).
if [ "$static" = "1" ]
then
	echo "*** Building libpng ***"
	cd $BUILD_DIR/libpng*
	./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
	make -j $jval
	make install
fi

# Ogg before vorbis
echo "*** Building libogg ***"
cd $BUILD_DIR/libogg*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
make -j $jval
make install

# Vorbis before theora
echo "*** Building libvorbis ***"
cd $BUILD_DIR/libvorbis*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
make -j $jval
make install

echo "*** Building libtheora ***"
cd $BUILD_DIR/libtheora*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
make -j $jval
make install

echo "*** Building livpx ***"
cd $BUILD_DIR/libvpx*
./configure --prefix=$TARGET_DIR $static_opt_disable_shared
make -j $jval
make install

echo "*** Building faac ***"
cd $BUILD_DIR/faac*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
# FIXME: gcc incompatibility, does not work with log()

sed -i -e "s|^char \*strcasestr.*|//\0|" common/mp4v2/mpeg4ip.h
make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared $dynamic_opt_enable_shared --disable-opencl
make -j $jval
make install

echo "*** Building xvidcore ***"
cd "$BUILD_DIR/xvidcore/build/generic"
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
make -j $jval
make install
#rm $TARGET_DIR/lib/libxvidcore.so.*

echo "*** Building lame ***"
cd $BUILD_DIR/lame*
./configure --prefix=$TARGET_DIR $static_opt_enable_static $static_opt_disable_shared
make -j $jval
make install

if [ "$static" = "1" ]
then
	# FIXME: only OS-specific
	rm -f "$TARGET_DIR/lib/*.dylib"
	rm -f "$TARGET_DIR/lib/*.so"
fi

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/ffmpeg*
[ "$static" = "1" ] && extraopts="--extra-version=static --extra-cflags=--static" || extraopts=""
CFLAGS="-I$TARGET_DIR/include" LDFLAGS="-L$TARGET_DIR/lib -lm" ./configure --prefix=${OUTPUT_DIR:-$TARGET_DIR} --extra-cflags="-I$TARGET_DIR/include $static_opt" --extra-ldflags="-L$TARGET_DIR/lib -lm $static_opt" $extraopts --disable-debug $static_opt_disable_shared $static_opt_enable_static $dynamic_opt_enable_shared --disable-ffplay --disable-ffserver --disable-doc --enable-gpl --enable-pthreads --enable-postproc --enable-gray --enable-runtime-cpudetect --enable-libfaac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-bzlib --enable-zlib --enable-nonfree --enable-version3 --enable-libvpx --disable-devices
make -j $jval && make install

