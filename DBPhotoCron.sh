#!/bin/bash

#Not going to pay $14 for a nice app when I can just write a simple crontab

# This is where dropbox puts camera uploads
SRCDIR="/Users/gnilrets/Dropbox/Camera Uploads"

#This is the root of where I want the files to live
OUTDIR="/Users/gnilrets/Dropbox/Photos-Master"

# Move files from the dropbox camera folder into the target/YYYY/YYYY-MM folders
find "$SRCDIR" -type f | while read file; do
    echo $file
    YEAR=`stat -f "%Sm" -t "%Y" "$file"`
    YRMO=`stat -f "%Sm" -t "%Y-%m" "$file"`
    echo $YEAR/$YRMO
    mkdir -p "$OUTDIR/$YEAR/$YRMO"
    mv "$file" "$OUTDIR/$YEAR/$YRMO"
done

