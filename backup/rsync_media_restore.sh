#!/bin/bash

RSYNC='/usr/bin/rsync'
RSYNC_OPTS="-az --delete -v"
BACKUP_DIR='/home/zheyuax/backups'
MAIN_DIR='media'
DEST="zheyuax@driver:$MAIN_DIR"

LAST_DIR="$(find $BACKUP_DIR/ -mindepth 1 -maxdepth 1 -type d |\
            grep -P "$BACKUP_DIR/\d{4}(-\d\d){3}(:\d\d){2}_$MAIN_DIR" | tail -n 1)"

if [[ ! -z $1 ]]; then
  if [[ -d $1 ]]; then
    LAST_DIR=$1
  else
    echo "ERROR: specified backup not found"
    exit 1
  fi
fi

if [[ -z $LAST_DIR ]]; then
  echo "ERROR: no backups found"
else
  echo "RESTORE: $LAST_DIR -> $DEST"
  $RSYNC $RSYNC_OPTS $LAST_DIR/ $DEST/
fi

