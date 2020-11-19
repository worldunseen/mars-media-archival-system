# User manual

## Rsyslog Config
```
:syslogtag, contains, "youtube-dl-info" /var/log/youtube-dl.log
```

## ```ytdl-parse.sh```

```
Usage: $SCRIPT_NAME [FILE]... [URL]...
Read FILES(s) and URL(s) to archive and log with youtube-dl
```

This is a Bash script that parses files and urls for compatible urls for
youtube-dl, which then downloads the media and auxillary media (metadata,
captions, thumbnails, etc.) and is automatically filed to an appropriate
location.

It also logs overall status of each url to the main `rsyslog` file, and
logs further debug info in a separate log file (youtube-dl.log). By
default, these get logged to the `youtube-dl` and `youtube-dl-info`
rsyslog tags respectively.

youtube-dl also keeps track of files already download through
a rudimentary database plaintext file.
