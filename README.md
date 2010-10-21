FFmpeg static build
===================

Three scripts to make a static build of ffmpeg with all the latest codecs (webm + h264).

Just follow the instructions below. Once you have the build dependencies,
just run ./build.sh, wait and you should get the ffmpeg binary in target/bin

Build dependencies
------------------

    # Debian & Ubuntu
    $ apt-get install build-essential curl tar <FIXME???>

	# OS X
	# install XCode, it can be found at http://developer.apple.com/
	# (apple login needed)
	# <FIXME???>

Build
-----

    $ ./build.sh
    # ... wait ...
    # binaries can be found in ./target/bin/

Debug
-----

On the top-level of the project, run:

	$ ENV_ROOT=`pwd`
	$ . env.source
	
Then you can enter the source folders and make the compilation yourself

	$ cd build/ffmpeg-*
	$ ./configure --prefix=$TARGET_DIR #...
	# ...

TODO
----

NOTE: there remains some dependencies I don't know how to remove. If you have any ideas, you're welcome to help.

    $ ldd build/bin/ffmpeg
	linux-gate.so.1 =>  (0xb78df000)
	libm.so.6 => /lib/tls/i686/cmov/libm.so.6 (0xb789f000)
	libz.so.1 => /lib/libz.so.1 (0xb788a000)
	libpthread.so.0 => /lib/tls/i686/cmov/libpthread.so.0 (0xb7870000)
	libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xb7716000)
	/lib/ld-linux.so.2 (0xb78e0000)

	# on OSX it's better:
    $ otool -L ffmpeg 
	ffmpeg:
		/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.2.0)
	
 * Add some tests to check that video output is correctly generated
   this would help upgrading the package without too much work
 * OSX's xvidcore does not detect yasm correctly
 * remove remaining libs
 
