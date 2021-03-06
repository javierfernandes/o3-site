#!/bin/bash

FOLDER="./content/posts/"

function create_metadata() {
  FILE=$1
  NAME=$(basename $FILE)
  NAME_NO_EXT=$(echo $NAME | cut -f1 -d'.')
  echo $NAME_NO_EXT
  (echo -e "---\ntitle: \"$NAME_NO_EXT\"\ndate:  2018-06-20T19:27:10-03:00\n---\n\n"; cat $FILE) > $FOLDER$NAME_NO_EXT.md
}

for f in ${FOLDER}*.md.md; do create_metadata "$f"; done
