#!/bin/sh

# ex: ~/dev/PSDK-android
HOME_ANDROID_PROJECT="$1"

cp -rf target/android/assets/* "$HOME_ANDROID_PROJECT/plugins/ruby-vm/shared/src/main/cpp/assets/files/"
cp -rf target/android/include/* "$HOME_ANDROID_PROJECT/plugins/ruby-vm/shared/src/main/cpp/external/include"
cp -rf target/android/lib/* "$HOME_ANDROID_PROJECT/plugins/ruby-vm/shared/src/main/cpp/external/lib"
