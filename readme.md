# MArS (Media Archiving System)

## Parsing and Downloading Media

### `ytdl-parse.sh`

```
Usage: $SCRIPT_NAME [FILE]... [URL]...
Read FILES(s) and URL(s) to archive and log with youtube-dl
```

This is a Bash script that parses files and urls for compatible urls for
youtube-dl, which then downloads the media and auxillary media (metadata,
captions, thumbnails, etc.) and is automatically filed to an appropriate
location.

It also logs overall status of each url to the main `rsyslog` file, and
logs further debug info in a separate log file (`youtube-dl.log`). By
default, these get logged to the `youtube-dl` and `youtube-dl-info`
rsyslog tags respectively.

`youtube-dl` also keeps track of files already downloaded through
a rudimentary database plaintext file.

### rsyslog Config

```
:syslogtag, contains, "youtube-dl-info" /var/log/youtube-dl.log
& stop
```

This config allows rsyslog to separate the youtube-dl debug output
into a separate log file.

## Backing Up Data

There are also utility scripts located on the backup server that
facilitate the backing up of media on the original driver server using
tools like `rsync` and `rclone`.

### `rsync_media_hourly.sh`

This script creates a timestamped incremental backup of the media content
located on the driver server.

### `rsync_media_restore.sh`

This script restores the media content located on the driver server with
the latest incremental backup directory (or specify your own). 

### `rclone_media_monthly.sh`

This script creates a timestamped tar archive of the latest incremental
backup and uploads it to an `rclone` provider (Google Drive, Dropbox,
etc.).

# TODO: installing rclone, youtube-dl, setting up servers, cronjobs
