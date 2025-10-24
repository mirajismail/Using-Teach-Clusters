#!/bin/bash

FILE_LIST="file_list"

# Ensure the file exists
[ ! -f "$FILE_LIST" ] && echo "File not found: $FILE_LIST" && exit 1

# Check each file in parallel
nl -ba "$FILE_LIST" | parallel -j "$(nproc)" '
  line={1}
  f={2}
  [ ! -e "$f" ] && echo "$line $f"
'

