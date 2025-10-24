#!/bin/bash

FILE_LIST="file_list"

# Ensure the file exists
[ ! -f "$FILE_LIST" ] && echo "File not found: $FILE_LIST" && exit 1

# Run checks in parallel
nl -ba -s$'\t' "$FILE_LIST" | parallel -j "$(nproc)" --colsep '\t' '
  [ ! -e "{2}" ] && echo "{1} {2}"
'


