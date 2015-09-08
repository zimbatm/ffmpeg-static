#!/bin/sh

set -e
set -u

jflag=
jval=2

while getopts 'j:' OPTION
do
  case $OPTION in
  j)	jflag=1
        	jval="$OPTARG"
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

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

#download and extract package
download(){
filename="$1"
if [ ! -z "$2" ];then
	filename="$2"
fi
../download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
#disable uncompress
CACHE_DIR="$DOWNLOAD_DIR" ../fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build ####"

#this is our working directory
cd $BUILD_DIR

download \
	"yasm-1.3.0.tar.gz" \
	"" \
	"fc9e586751ff789b34b1f21d572d96af" \
	"http://www.tortall.net/projects/yasm/releases/"

download \
	"last_x264.tar.bz2" \
	"" \
	"2b712f196293bd04f4241e4f218e102d" \
	"http://download.videolan.org/pub/x264/snapshots/"

download \
	"x265_1.7.tar.gz" \
	"" \
	"ff31a807ebc868aa59b60706e303102f" \
	"https://bitbucket.org/multicoreware/x265/downloads/"

download \
	"master" \
	"fdk-aac.tar.gz" \
	"e6a0df5ba4b2343edaf4c05ed5925de9" \
	"https://github.com/mstorsjo/fdk-aac/tarball"

download \
	"lame-3.99.5.tar.gz" \
	"" \
	"84835b313d4a8b68f5349816d33e07ce" \
	"http://downloads.sourceforge.net/project/lame/lame/3.99"

download \
	"opus-1.1.tar.gz" \
	"" \
	"c5a8cf7c0b066759542bc4ca46817ac6" \
	"http://downloads.xiph.org/releases/opus"

download \
	"libvpx-1.4.0.tar.bz2" \
	"" \
	"63b1d7f59636a42eeeee9225cc14e7de" \
	"http://ftp.osuosl.org/pub/blfs/svn/l"

download \
	"2.8.tar.gz" \
	"ffmpeg2.8.tar.gz" \
	"984465afafb8db41d8fe80e9a56a0ffb" \
	"https://github.com/FFmpeg/FFmpeg/archive/release"

echo "*** Building yasm ***"
cd $BUILD_DIR/yasm*
./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/x265*
cd build/linux
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:bool=off ../../source
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
./configure --prefix=$TARGET_DIR --disable-shared
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests
PATH="$BIN_DIR:$PATH" make -j $jval
make install

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/FFmpeg*
PATH="$BIN_DIR:$PATH" \
PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
  --prefix="$TARGET_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$TARGET_DIR/include" \
  --extra-ldflags="-L$TARGET_DIR/lib" \
  --bindir="$BIN_DIR" \
  --enable-ffplay \
  --enable-ffserver \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$BIN_DIR:$PATH" make
make install
make distclean
hash -r
