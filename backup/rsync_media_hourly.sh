#!/bin/bash

RSYNC='/usr/bin/rsync'
RSYNC_OPTS="-az --delete -v"
BACKUP_DIR='/home/zheyuax/backups'
MAIN_DIR='media'
SOURCE="zheyuax@driver:$MAIN_DIR"
DEST="$BACKUP_DIR/$(date +'%F-%T')_$MAIN_DIR"

LAST_DIR="$(find $BACKUP_DIR/ -mindepth 1 -maxdepth 1 -type d |\
            grep -P "$BACKUP_DIR/\d{4}(-\d\d){3}(:\d\d){2}_$MAIN_DIR" | tail -n 1)"

if [[ -z $LAST_DIR ]]; then
  echo "BACKUP: $SOURCE -> $DEST (first time)"
else
  echo "BACKUP: $SOURCE -> $DEST"
  RSYNC_OPTS="$RSYNC_OPTS --link-dest=$LAST_DIR/"
fi

$RSYNC $RSYNC_OPTS $SOURCE/ $DEST/
