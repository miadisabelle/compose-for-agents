#!/bin/bash

# Example 2: Environment-based batch processing
# This example shows how to process multiple files using .env configuration

echo "=== Audio Pipeline Toolkit - Example 2: Environment-based Batch Processing ==="

# Create sample .env file
cat > .env << 'EOF'
TITLE="Podcast Episode"
ARTIST="My Podcast"
ALBUM="Season 1"
GENRE="Podcast"
DATE="2024"
PREFIX="s01e"
SUFFIX="final"
EOF

echo "Created .env file with default metadata"
echo "Contents of .env:"
cat .env
echo ""

# Process files using environment variables
echo "Processing files with environment metadata..."

# Example processing multiple files (assuming they exist)
for file in *.wav; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        ../mp3_tagger.sh "$file"
    fi
done

echo ""
echo "Batch processing complete!"
echo "Usage: Place WAV files in this directory and run ./example2_env_batch.sh"
echo "Modify .env file to change metadata for all files"