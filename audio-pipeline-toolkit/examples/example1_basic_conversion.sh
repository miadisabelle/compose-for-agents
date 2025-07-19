#!/bin/bash

# Example 1: Basic WAV to MP3 conversion with metadata
# This example shows the simplest usage of the audio pipeline toolkit

echo "=== Audio Pipeline Toolkit - Example 1: Basic Conversion ==="

# Convert a WAV file to MP3 with basic metadata
python ../audio_prep_format_n_tags.py \
  --title "My First Song" \
  --artist "Demo Artist" \
  --album "Demo Album" \
  --genre "Demo" \
  --date "2024" \
  --bitrate "320k" \
  input_demo.wav output_demo.mp3

echo "Conversion complete! Check output_demo.mp3"
echo "Usage: ./example1_basic_conversion.sh"
echo "Note: Requires input_demo.wav file in this directory"