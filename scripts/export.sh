#!/bin/sh

# ex: ~/dev/PSDK-android
HOME_ANDROID_PROJECT="$1"
cp -f target/android/arm64-v8a.jar "$HOME_ANDROID_PROJECT/app/libs/arm64-v8a.jar"
cp -rf target/android/ext-native-libs/* "$HOME_ANDROID_PROJECT/app/src/main/ext-native-libs/"
