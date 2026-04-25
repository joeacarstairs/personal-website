#!/bin/bash

LONGLOG="content/logs/longlog.gmi"
LONGLOG_HEADER="templates/longlog-header.gmi"
LONGLOG_SRC_DIR="content/logs/longlog"
HR="-----------------------------------------------------------------------"

trim_longlog_tail()
{
  while [[ -z "$(tail -n 1 "$LONGLOG")" && "$(wc -l "$LONGLOG" | cut -c1)" -ne 0 ]]; do
    head -n -1 "$LONGLOG" | tee "$LONGLOG" 1>/dev/null
  done
}

echo "Cleaning existing longlog..."
rm -f "$LONGLOG"

echo "Copying longlog header..."
cp "$LONGLOG_HEADER" "$LONGLOG"
trim_longlog_tail
echo "" >> "$LONGLOG"

echo "Appending entries to longlog..."
posts=(${LONGLOG_SRC_DIR}/*)
for ((i=${#posts[@]}-1; i>=0; i--)); do
  post="${posts[i]}"
  if [[ "$post" =~ ${LONGLOG_SRC_DIR}/([0-9]{4}-[0-9]{2}-[0-9]{2}(\.[0-9]+)?)\.gmi ]]; then
    date="${BASH_REMATCH[1]}"
    suffix="${BASH_REMATCH[2]}"
    title="$(head -n 1 "${posts[i]}" | sed "s/^\#\+ *//")"
    echo "=> /logs/longlog/${date}${suffix}.gmi    ${date}    ${title}" >> "$LONGLOG"
  else
    echo "Error: $post does not match format YYYY-MM-DD(.n). Aborting..."
    exit 1
  fi
done

echo "Done."
