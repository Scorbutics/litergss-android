#!/bin/sh

rm -f CMakeCache.txt Makefile cmake_install.cmake
rm -rf CMakeFiles
rm -rf build/CMakeFiles
for item in "build"/*
do
  [ -d "$item" ] && rm -rf $item/build_dir/* && rm -rf $item/build_dir/.*
done
rm -f build/cmake_install.cmake build/Makefile

rm -rf target/