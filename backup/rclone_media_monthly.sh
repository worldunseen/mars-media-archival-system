#!/bin/bash

RCLONE='/usr/bin/rclone sync'
TAR='/usr/bin/tar'
BACKUP_DIR='/home/zheyuax/backups'
MAIN_DIR='media'
DEST="drive:yt-dl"

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
  ARCHIVE="${LAST_DIR}.tar.gz"
  $TAR --acls --xattrs -cpf $ARCHIVE $LAST_DIR/

  echo "BACKUP: $ARCHIVE -> $DEST"
  $RCLONE -v $ARCHIVE $DEST/
  rm -f $ARCHIVE
fi

