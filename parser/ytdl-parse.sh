#!/bin/bash
set -o pipefail

readonly SCRIPT_NAME=$(basename $0)
readonly SYSLOG_TAG="youtube-dl"
readonly SYSLOG_TAG_DEBUG="youtube-dl-info"
readonly YTDL_CONFIG="configs/ytdl.conf"
readonly DBFILE="configs/db.txt"
readonly MEDIADIR="media"

help() {
  echo "Usage: $SCRIPT_NAME [FILE]... [URL]... "
  echo "Read FILES(s) and URL(s) to archive and log with youtube-dl"
  return 1
}

log() {
    echo "$@"
    logger -p user.notice -t $SYSLOG_TAG "$@"
}

err() {
    echo "$@"
    logger -p user.error -t $SYSLOG_TAG "$@"
}

parse_url() {
    SITEDIR=""
    OUTFILE=""
    case $1 in
        *youtube.com/*|*youtu.be/*)
            SITEDIR="yt"
            OUTFILE="$MEDIADIR/$SITEDIR/%(uploader)s - %(upload_date)s - %(title)s - %(id)s.%(ext)s"
        ;;
        *soundcloud.com/*)
            SITEDIR="sc"
            OUTFILE="$MEDIADIR/$SITEDIR/%(uploader)s/%(upload_date)s - %(title)s - %(id)s.%(ext)s"
        ;;
        *bandcamp.com/*)
            SITEDIR="bc"
            OUTFILE="$MEDIADIR/$SITEDIR/%(uploader)s/%(album)s/%(track_number)02d - %(title)s - %(upload_date)s - %(id)s.%(ext)s"
        ;;
        *vimeo.com/*)
            SITEDIR="vimeo"
            OUTFILE="$MEDIADIR/$SITEDIR/%(uploader)s - %(upload_date)s - %(title)s - %(id)s.%(ext)s"
        ;;
        *)
            err "ERROR: bad parse $1"
        ;;
    esac

    if [[ ! -z $SITEDIR  ]]; then
        echo "Downloading $1 to $MEDIADIR/$SITEDIR"
        youtube-dl --config-location "$YTDL_CONFIG" \
                   --download-archive "$DBFILE" \
                   -o "$OUTFILE" "$1" 2>&1 | logger -p user.info -t $SYSLOG_TAG_DEBUG

        if [[ $? -eq 0 ]]; then
            log "SUCCESS: $1"
        else
            err "ERROR: $1"
        fi
    fi
}



if [[ $# -lt 1 ]]; then
  help
fi

for ARG in "$@"; do
  if [[ -f $ARG ]]; then
      while IFS="" read -r p || [ -n "$p" ]
      do
          parse_url "$p"
      done < $ARG
  else
      parse_url "$ARG"
  fi
done

exit 0
