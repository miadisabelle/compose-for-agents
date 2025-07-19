#!/bin/bash

# Load environment variables from .env file
if [ ! -e .env ]; then
  echo "No .env file found"
else
  set -o allexport
  source .env
  set +o allexport

  if [ -z "$1" ]; then
    echo "Usage: $0 <input_file> [prefix] [suffix]"
  else
    f="$1"
    prefix="${2:-$PREFIX}"
    ff=${f%.*}
    suffix="${3:-$SUFFIX}"
    if [ -z "$suffix" ]; then
      suffix="tagged"
    fi
    tagger_python_script_path="/w/rawill2411/scripts/audio_prep_format_n_tags.py"
    python $tagger_python_script_path \
      --title "$TITLE - $ff" \
      --artist "$ARTIST" \
      --album "$ALBUM" \
      --genre "$GENRE" \
      --date "$DATE" \
      "$f" $prefix"$ff.$suffix.mp3"

    #usage: audio_prep_format_n_tags.py [-h] [--title TITLE] [--artist ARTIST] [--album ALBUM] [--genre GENRE] [--date DATE] [--bitrate BITRATE] input_file output_file
  fi
fi

