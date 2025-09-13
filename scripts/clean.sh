#!/bin/sh

TARGETS="$@"
DIR="$(cd "$(dirname "$0")" && pwd)"
DELIMITER='_'

if [ -z "$TARGETS" ]; then
  "$DIR/tools/docker-dev-action.sh" cmake --build . --target clean-libs
else
  for target in $TARGETS; do
    last_field=$(echo "$target" | awk -F "$DELIMITER" 'NF > 1 {print $NF}')
    if [ -n "$last_field" ]; then
      first_field=$(echo "$target" | cut -d "$DELIMITER" -f 1) 
      "$DIR/tools/docker-dev-action.sh" cmake --build . --target "${first_field}_clean_${last_field}"
    else
      "$DIR/tools/docker-dev-action.sh" cmake --build . --target "${target}_clean"
    fi
  done
fi;