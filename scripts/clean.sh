#!/bin/sh
set -e

ROOT_BUILD_DIR=build

rm -rf $ROOT_BUILD_DIR/CMakeFiles


usage() {
cat >&2 <<-EOF
  usage: $0 [-h|s] [PACKAGE ...]

  Package cleanup script.

  Options:
   -h	show this help
   -s	soft clean (only remove package steps files, starting with a dot '.')
EOF
}

soft=no

while getopts "hs" option "$@"
do
  case $option in
  (s)
    soft=yes
    ;;
  (h)
    usage
    exit 0
  (*)
    echo "Unknown command option: $option"
    usage
    exit 1
    ;;
  esac
done
shift $(expr $OPTIND - 1)

TARGETS="$@"

clear_folder() {
  local folder="$1"
  [ -d "$folder" ] && {
    if [ "$soft" = "yes" ]; then
      # Make sure to not delete ".patch.done", as we don't want to reapply patches
      rm -f "$folder/build_dir/.configure.done" \
        "$folder/build_dir/.build.done" \
        "$folder/build_dir/.install.done"
    else
      rm -rf "$folder/build_dir/"*
      rm -f "$folder/build_dir/".*
    fi
  }
}

if [ -z "$TARGETS" ]; then
  rm -f CMakeCache.txt Makefile cmake_install.cmake
  rm -rf CMakeFiles
  for item in "$ROOT_BUILD_DIR"/*; do
    clear_folder "$item"
  done
  rm -f $ROOT_BUILD_DIR/cmake_install.cmake $ROOT_BUILD_DIR/Makefile
  rm -rf target/
else
  for target in $TARGETS; do
    clear_folder "$ROOT_BUILD_DIR/$target"
  done
fi;
