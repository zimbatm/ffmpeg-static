FFmpeg static build
===================

*STATUS*: community-supported

Three scripts to make a static build of ffmpeg with all the latest codecs (webm + h264).

Just follow the instructions below. Once you have the build dependencies,
run ./build.sh, wait and you should get the ffmpeg binary in target/bin

Build dependencies
------------------

    # Debian & Ubuntu
    $ apt-get install build-essential curl tar libass-dev libtheora-dev libvorbis-dev libtool cmake automake autoconf

    # OS X
    # 1. install XCode
    # 2. install XCode command line tools
    # 3. install homebrew
    # brew install openssl frei0r sdl2 wget

Build & "install"
-----------------

    $ ./build.sh [-j <jobs>] [-B] [-d]
    # ... wait ...
    # binaries can be found in ./target/bin/

Ubuntu users can download dependencies and and install in one command:

    $ sudo ./build-ubuntu.sh

If you have built ffmpeg before with `build.sh`, the default behaviour is to keep the previous configuration. If you would like to reconfigure and rebuild all packages, use the `-B` flag. `-d` flag will only download and unpack the dependencies but not build.

NOTE: If you're going to use the h264 presets, make sure to copy them along the binaries. For ease, you can put them in your home folder like this:

    $ mkdir ~/.ffmpeg
    $ cp ./target/share/ffmpeg/*.ffpreset ~/.ffmpeg


Build in docker
---------------

    $ docker build -t ffmpeg-static .
    $ docker run -it ffmpeg-static
    $ ./build.sh [-j <jobs>] [-B] [-d]

The binaries will be created in `/ffmpeg-static/bin` directory.
Method of getting them out of the Docker container is up to you.
`/ffmpeg-static` is a Docker volume.

Debug
-----

On the top-level of the project, run:

    $ . env.source

You can then enter the source folders and make the compilation yourself

    $ cd build/ffmpeg-*
    $ ./configure --prefix=$TARGET_DIR #...
    # ...

Remaining links
---------------

I'm not sure it's a good idea to statically link those, but it probably
means the executable won't work across distributions or even across releases.

    # On Ubuntu 10.04:
    $ ldd ./target/bin/ffmpeg
    not a dynamic executable

    # on OSX 10.6.4:
    $ otool -L ffmpeg
    ffmpeg:
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.0)

Community, bugs and reports
---------------------------

This repository is community-supported. If you make a useful PR then you will
be added as a contributor to the repo. All changes are assumed to be licensed
under the same license as the project (ISC).

As a contributor you can do whatever you want. Help maintain the scripts,
upgrade dependencies and merge other people's PRs. Just be responsible and
make an issue if you want to introduce bigger changes so we can discuss them
beforehand.

### TODO

 * Add some tests to check that video output is correctly generated
   this would help upgrading the package without too much work
 * OSX's xvidcore does not detect yasm correctly
 * remove remaining libs (?)

Related projects
----------------

* FFmpeg Static Builds - http://johnvansickle.com/ffmpeg/

License
-------

This project is licensed under the ISC. See the [LICENSE](LICENSE) file for
the legalities.

