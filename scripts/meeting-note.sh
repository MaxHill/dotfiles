#!/usr/bin/env bash

# Prompt for title
TITLE=$(gum input --placeholder "Enter meeting title")
FILE_TITLE=${TITLE// /-}  # Replace spaces with hyphens

# put current date as yyyy-mm-dd in $date
DATE=$(date '+%Y-%m-%d')
FILE_PATH=$(echo ${@%/})
NOTE_FILE=$(echo "$FILE_PATH/meetings/$DATE-$FILE_TITLE.md")

# Only create the file if it doesn't already exist
if [ ! -f "$NOTE_FILE" ]; then
  cat > "$NOTE_FILE" <<- EOM
---
title: $TITLE
date: $DATE
tags: #mhc #work
---
EOM
fi

echo $NOTE_FILE
