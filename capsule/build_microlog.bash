#!/bin/bash

MICROLOG="content/logs/microlog.gmi"
MICROLOG_HEADER="templates/microlog-header.gmi"
MICROLOG_SRC_DIR="microlog"
HR="-----------------------------------------------------------------------"

trim_microlog_tail()
{
  while [[ -z "$(tail -n 1 "$MICROLOG")" && "$(wc -l "$MICROLOG" | cut -c1)" -ne 0 ]]; do
    head -n -1 "$MICROLOG" | tee "$MICROLOG" 1>/dev/null
  done
}

echo "Cleaning existing microlog..."
rm -f "$MICROLOG"

echo "Copying microlog header..."
cp $MICROLOG_HEADER $MICROLOG
trim_microlog_tail

echo "Appending entries to microlog..."
posts=(${MICROLOG_SRC_DIR}/*)
for ((i=${#posts[@]}-1; i>=0; i--)); do
  if [[ "${posts[i]}" =~ ${MICROLOG_SRC_DIR}/([0-9]{4}-[0-9]{2}-[0-9]{2}(\.[0-9]+)?)\.gmi ]]; then
    date="${BASH_REMATCH[1]}"
    echo "" >> "$MICROLOG"
    echo "## ${date}" >> "$MICROLOG"
    echo "" >> "$MICROLOG"
    cat "${posts[i]}" >> "$MICROLOG"
    trim_microlog_tail
  else
    echo "Error: $post does not match format YYYY-MM-DD(.n). Aborting..."
    exit 1
  fi
done

echo "Done."
