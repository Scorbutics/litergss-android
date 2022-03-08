# LiteRGSS2 build for Android v8a (64bits)

Only Android 8.0+ is supported.

# Requirements /!\

Note that before building you require :
 - NDK >= r22b
 - Android Studio >= 4.2.0
 - CMake >= 3.19.2
 - Ninja
 - libtool binary (package 'libtool-bin' on Ubuntu) for 'flac'

# Build

Build using "./configure" in root folder.
Default ANDROID API values are written into 'arm64-v8a-android-toolchain.params'.
You can edit it if you know what you're doing.

# Output

The build output is in "target/android".
