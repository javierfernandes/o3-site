#!/bin/bash

FOLDER="content/posts/"

function create_metadata() {
  FILE=$1
  (echo -e "---\ntitle: \"$FILE\"\ndate:  2018-06-20T19:27:10-03:00\n---\n\n"; cat ${FOLDER}$(basename $FILE)) > $FILE.mig
}

for f in ${FOLDER}*.md.md; do create_metadata "$f"; done
