#!/bin/bash

###   Description

# Add this job to crontab, run as frequently as you like

# Inspired by Hazel, but not going to pay $14 for a 
# nice app when I can just write a simple crontab

# Assumes all photos are organized into folders YYYY/YYYY-MM in ARCHDIR

###   Config 
# This is where dropbox puts camera uploads
SRCDIR="/Users/gnilrets/Dropbox/Camera Uploads"

# This is the root of where I want the files to live
ARCHDIR="/Users/gnilrets/Dropbox/Photos-Master"

# This is where I want to put copies for sharing
SHAREDIR="/Users/gnilrets/Dropbox/Shared/ByMe/ParamoreFamilyPhotos"


###   Archive camera uploads

# Fortunately, the dropbox camera uploader make the create date of the file
# equal to the time the photo was taken.  So archiving them to the appropriate folder
# is easy.

# Move files from the dropbox camera folder into the target/YYYY/YYYY-MM folders
find "$SRCDIR" -type f | while read file; do
    echo $file
    YEAR=`stat -f "%Sm" -t "%Y" "$file"`
    YRMO=`stat -f "%Sm" -t "%Y-%m" "$file"`
    echo $YEAR/$YRMO
    mkdir -p "$ARCHDIR/$YEAR/$YRMO"
    mv "$file" "$ARCHDIR/$YEAR/$YRMO"
done

### Push recent photos to my shared folder
#  warning: this will push any pictures synced to dropbox to a public folder.
#  BE WARNED

# Let's do something really simple - share the last two months of files

CURRENTYR=$(date +"%Y")
CURRENTMO=$(date +"%Y/%Y-%m")
LASTYR=$(date -v-1m +"%Y")
LASTMO=$(date -v-1m +"%Y/%Y-%m")
echo CURRENTYR=$CURRENTYR LASTYR=$LASTYR
echo CURRENTMO=$CURRENTMO LASTMO=$LASTMO

rsync -avz --delete-excluded \
    --include="$CURRENTYR" --include="$CURRENTMO" --include="/$CURRENTMO/**" \
    --include="$LASTYR" --include="$LASTMO" --include="/$LASTMO/**" \
    --exclude=* \
    $ARCHDIR/ $SHAREDIR/

# TODO: Favorites only
