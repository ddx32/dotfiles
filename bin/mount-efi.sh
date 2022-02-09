#!/usr/bin/env bash

# Mount EFI volume used for booting up (useful for configuring OpenCore)
u=$(nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:boot-path | sed 's/.*GPT,\([^,]*\),.*/\1/')
if [ "$u" != "" ]
  then sudo diskutil mount "$u"
fi
