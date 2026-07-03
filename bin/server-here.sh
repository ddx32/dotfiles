#!/bin/bash

if [[ $1 == "" ]]; then
  # Random port in 30000-65535 using the bash RANDOM builtin (portable;
  # jot is BSD/macOS-only). Combine two draws to cover the full range.
  PORTNUMBER=$(( 30000 + (RANDOM * 32768 + RANDOM) % 35536 ))
else
  PORTNUMBER=$1
fi

echo "Starting HTTP static server on port $PORTNUMBER..."
echo "http://localhost:$PORTNUMBER"
docker run --rm -it -p "$PORTNUMBER":80 -v "$(pwd)":/usr/share/nginx/html:ro nginx:latest
