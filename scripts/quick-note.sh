#!/usr/bin/env bash

# put current date as yyyy-mm-dd HH:MM in $date
TIME=$(date '+%H:%M')
DATE=$(date '+%Y-%m-%d-%H:%M')
FILE_PATH=$(echo ${@%/})
NOTE_FILE=$(echo "$FILE_PATH/$DATE-note.md")

cat > $NOTE_FILE <<- EOM
---
title: Unnamed
time: $TIME
tags: 
---

EOM

echo $NOTE_FILE
