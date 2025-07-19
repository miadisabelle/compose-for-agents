#!/bin/bash

# Example 3: Creating multiple quality variants
# This example shows how to create different quality versions of the same audio

echo "=== Audio Pipeline Toolkit - Example 3: Quality Variants ==="

INPUT_FILE="source_audio.wav"
BASE_NAME="my_track"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Warning: $INPUT_FILE not found. This is a demonstration script."
    echo "Create a file named '$INPUT_FILE' to test this example."
fi

echo "Creating multiple quality variants of audio file..."

# High quality version (320k)
echo "Creating high quality version..."
python ../audio_prep_format_n_tags.py \
  --title "$BASE_NAME (HQ)" \
  --artist "Demo Artist" \
  --album "Quality Variants Demo" \
  --genre "Demo" \
  --date "2024" \
  --bitrate "320k" \
  "$INPUT_FILE" "${BASE_NAME}_hq.mp3"

# Medium quality version (128k)
echo "Creating medium quality version..."
python ../audio_prep_format_n_tags.py \
  --title "$BASE_NAME (Medium)" \
  --artist "Demo Artist" \
  --album "Quality Variants Demo" \
  --genre "Demo" \
  --date "2024" \
  --bitrate "128k" \
  "$INPUT_FILE" "${BASE_NAME}_medium.mp3"

# Low quality version (64k)
echo "Creating low quality version..."
python ../audio_prep_format_n_tags.py \
  --title "$BASE_NAME (Low)" \
  --artist "Demo Artist" \
  --album "Quality Variants Demo" \
  --genre "Demo" \
  --date "2024" \
  --bitrate "64k" \
  "$INPUT_FILE" "${BASE_NAME}_low.mp3"

echo ""
echo "Quality variants created:"
echo "- ${BASE_NAME}_hq.mp3 (320k bitrate)"
echo "- ${BASE_NAME}_medium.mp3 (128k bitrate)" 
echo "- ${BASE_NAME}_low.mp3 (64k bitrate)"
echo ""
echo "Usage: Place a WAV file named '$INPUT_FILE' in this directory and run ./example3_quality_variants.sh"