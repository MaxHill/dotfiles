#!/usr/bin/env bash

# put current date as yyyy-mm-dd in $date
DATE=$(date '+%Y-%m-%d')
FILE_PATH=$(echo ${@%/})
NOTE_FILE=$(echo "$FILE_PATH/$DATE-note.md")

# Only create the file if it doesn't already exist
if [ ! -f "$NOTE_FILE" ]; then
  cat > "$NOTE_FILE" <<- EOM
---
title: Daily note
date: $DATE
tags: #work #mhc
---
EOM
fi

echo $NOTE_FILE
