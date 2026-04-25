#!/bin/bash

TMP="tmp-build-loglog-$(date +%s%N)"
LOGLOG="content/logs/loglog.gmi"
LOGLOG_HEADER="loglog-header.gmi"

new_filename()
{
  DATE="$1"
  mkdir -p "$TMP/$DATE"
  N=0
  while [[ -f "$TMP/$DATE/$N" ]]; do
    N=$(( N + 1 ))
  done
  echo "$TMP/$DATE/$N"
}

read_log_to_tmp()
{
  LOGPATH="$1"
  LOG="$(echo $LOGPATH | sed "s/.*\///g" | sed "s/\.gmi//g")"
  CURRENT_POST_HEADING=""
  CURRENT_POST_FILENAME=""
  while read line; do
    if [[ -z "$CURRENT_POST_FILENAME" ]]; then
      if [[ "$line" =~ (\#+)\ *([0-9]{4}-[0-9]{2}-[0-9]{2})(\.[0-9]+)?\ * ]]; then
        CURRENT_POST_HEADING="${BASH_REMATCH[1]}"
        DATE="${BASH_REMATCH[2]}"
        CURRENT_POST_FILENAME="$(new_filename $DATE)"
      elif [[ "$line" =~ \=\>\ +([^\ ]+)\ +([0-9]{4}-[0-9]{2}-[0-9]{2})(\.[0-9]+)?\ +(.*) ]]; then
        HREF="${BASH_REMATCH[1]}"
        DATE="${BASH_REMATCH[2]}"
        NAME="${BASH_REMATCH[3]}"
        FILENAME="$(new_filename $DATE)"
        echo "
=> $HREF $DATE $NAME

From my $LOG.

=> /logs/$LOG.gmi My $LOG" \
         >> "$FILENAME"
      fi
    else
      if [[ "$line" =~ (\#+)\ *([0-9]{4}-[0-9]{2}-[0-9]{2})\ * ]]; then
        echo "From my $LOG.

=> /logs/$LOG.gmi My $LOG" \
          >> "$CURRENT_POST_FILENAME"
        CURRENT_POST_HEADING="${BASH_REMATCH[1]}"
        DATE="${BASH_REMATCH[2]}"
        CURRENT_POST_FILENAME="$(new_filename $DATE)"
      elif [[ "$line" =~ \#.* ]] && ! [[ "$line" =~ ${CURRENT_POST_HEADING}\#.* ]]; then
        echo "From my $LOG.

=> /logs/$LOG.gmi My $LOG" \
          >> "$CURRENT_POST_FILENAME"
        CURRENT_POST_HEADING=""
        DATE=""
        CURRENT_POST_FILENAME=""
      else
        echo "$line" >> "$CURRENT_POST_FILENAME"
      fi
    fi
  done <$LOGPATH
}

trim_entries()
{
  ENTRY_DIR="$1"
  for entry in $ENTRY_DIR/*; do
    while [[ -z "$(head -n 1 "$entry")" && "$(wc -l "$entry" | cut -c1)" -ne 0 ]]; do
      tail -n +2 "$entry" | tee "$entry" 1>/dev/null
    done
    while [[ -z "$(tail -n 1 "$entry")" && "$(wc -l "$entry" | cut -c1)" -ne 0 ]]; do
      head -n -1 "$entry" | tee "$entry" 1>/dev/null
    done
    if [[ -z "$(cat "$entry")" ]]; then
      echo "Removing entry $entry: $(cat $entry)"
      rm "$entry"
    fi
  done
  if [[ "$(ls "$ENTRY_DIR" | wc -l)" -eq 0 ]]; then
    rmdir "$ENTRY_DIR"
  fi
}

append_entries_for_date()
{
  DATE_DIR="$1"
  DATE="$(echo "$DATE_DIR" | sed "s/.*\///g")"
  echo "## $DATE
" >> "$LOGLOG"
  ENTRY_COUNT="$(ls $DATE_DIR | wc -l)"
  LAST_ENTRY="$(ls $DATE_DIR | tail -n 1)"
  for entry in $DATE_DIR/*; do
    cat "$entry" >> "$LOGLOG"
    echo "" >> "$LOGLOG"
    if [[ "$ENTRY_COUNT" -gt 1 && "$entry" != "$DATE_DIR/$LAST_ENTRY" ]]; then
      echo \
------------------------------------------------------------------------ >> "$LOGLOG"
      echo "" >> "$LOGLOG"
    fi
  done
}

echo "Cleaning existing loglog..."
rm -f "$LOGLOG"

echo "Reading logs to temporary files..."
for log in content/logs/*log.gmi; do
  read_log_to_tmp "$log"
done

echo "Trimming entries in temporary files..."
for date in $TMP/*; do
  trim_entries "$date"
done

echo "Copying loglog header..."
cp "$LOGLOG_HEADER" "$LOGLOG"

echo "Appending entries to loglog..."
dates=($TMP/*)
for ((i=${#dates[@]}-1; i>=0; i--)); do
  append_entries_for_date "${dates[i]}"
done

echo "Cleaning up temporary files..."
rm -rf "$TMP"

echo "Done."
