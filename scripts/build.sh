#!/bin/sh

BASEDIR=$(pwd)
docker run \
    -v $BASEDIR:/opt/current \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    scor/ruby-android-ndk:latest \
    /bin/bash \
    -c 'cmake --build .'
