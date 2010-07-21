#!/bin/sh

cd `dirname $0`
rm -rf cache
mkdir -p cache
cd cache

wget http://www.tortall.net/projects/yasm/releases/yasm-1.0.1.tar.gz
wget http://zlib.net/zlib-1.2.5.tar.bz2
wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
wget http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz?use_mirror=sunet
#wget http://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2?use_mirror=garr
wget http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.bz2?use_mirror=mesh
wget http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.bz2
#git clone git://git.videolan.org/x264.git
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20100620-2245.tar.bz2
wget http://downloads.xiph.org/releases/ogg/libogg-1.2.0.tar.gz
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.1.tar.bz2
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2
git clone git://review.webmproject.org/libvpx.git
svn checkout svn://svn.ffmpeg.org/ffmpeg/trunk ffmpeg

