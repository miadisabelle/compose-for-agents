# Audio Pipeline Toolkit

A complete toolkit for converting audio files to MP3 format with metadata embedding.

## Files
- `audio_prep_format_n_tags.py` - Main Python script for audio conversion and tagging
- `mp3_tagger.sh` - Bash wrapper script with environment variable support
- `requirements.txt` - Python dependencies

## Quick Start

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Direct usage:
   ```bash
   python audio_prep_format_n_tags.py --title "My Song" --artist "Artist" input.wav output.mp3
   ```

3. Environment-based usage:
   ```bash
   # Create .env file with metadata
   ./mp3_tagger.sh input.wav
   ```

## Features
- Converts WAV and other formats to MP3
- Embeds ID3 metadata (title, artist, album, genre, date)
- Configurable bitrate (default: 320k)
- Environment variable support via .env files
- Batch processing capabilities

See `examples/` directory for usage examples.