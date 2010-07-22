FFmpeg static build
===================

Two script to make a static build of ffmpeg with all the latest codecs (webm + h264).

NOTE: there remains some dependencies I don't know how to remove. If you have any ideas, you're welcome to help.

    $ ldd build/bin/ffmpeg
	linux-gate.so.1 =>  (0xb78df000)
	libm.so.6 => /lib/tls/i686/cmov/libm.so.6 (0xb789f000)
	libz.so.1 => /lib/libz.so.1 (0xb788a000)
	libpthread.so.0 => /lib/tls/i686/cmov/libpthread.so.0 (0xb7870000)
	libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xb7716000)
	/lib/ld-linux.so.2 (0xb78e0000)

Dependencies
------------

    # Debian & Ubuntu
    $ apt-get install build-essential git-core ruby1.8 curl tar <FIXME>


Build
-----

    $ ./build.sh
    # ... wait ...
    # binaries can be found in ./target/bin/

TODO
----

 * remove remaining libs
 * re-write fetchurl in shell instead of ruby to avoid dependency
