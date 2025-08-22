#!/bin/sh
docker run \
    -v /$(pwd):/opt/current \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    scor/ruby-android-ndk:latest \
    bash \
    -c './configure'
