#!/bin/sh

# ex: ~/dev/PSDK-android
HOME_ANDROID_PROJECT="$1"
cp -rf target/android/assets/* "$HOME_ANDROID_PROJECT/app/src/main/assets/"
cp -rf target/android/include/* "$HOME_ANDROID_PROJECT/app/src/main/cpp/external/"
cp -rf target/android/bin/* "$HOME_ANDROID_PROJECT/app/src/main/jniLibs/"
