# LiteRGSS2 build for Android v8a (64bits)

Only Android 8.0+ is supported.

# Requirements /!\

1. Install docker, if not already present on your host
2. Clone the following repository: https://github.com/Scorbutics/ruby-android-ndk-docker
3. Execute the "build.sh" script of this existing repository, it will build your docker environment required to compile

# Old Requirements (no docker, manual version) /!\

Note that before building you require :
 - NDK >= r22b
 - Android Studio >= 4.2.0
 - CMake >= 3.19.2
 - Ninja
 - libtool binary (package 'libtool-bin' on Ubuntu) for 'flac'

# Build

## With docker
From the root folder:
 - execute `./scripts/configure.sh`
 - then, execute `./scripts/build.sh`

## Without docker (manual version)
Build using "./configure" in root folder.
Default ANDROID API values are written into 'arm64-v8a-android-toolchain.params'.
You can edit it if you know what you're doing.

# Output

The build output is in "target/android".
