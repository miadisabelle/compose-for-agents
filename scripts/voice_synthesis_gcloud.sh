#!/bin/bash
# Voice Synthesis using gcloud authentication and en-GB-Chirp3-HD-Achernar voice
# Based on existing _sample_voice_synt.sh pattern

set -e

# Check if gcloud is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ No active gcloud authentication found"
    echo "   Please run: gcloud auth login"
    exit 1
fi

# Get project ID
PROJECT_ID=$(gcloud config list --format='value(core.project)')
if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project ID configured"
    echo "   Please run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "🎵 Using project: $PROJECT_ID"
echo "🎤 Using voice: en-GB-Chirp3-HD-Achernar"

# Input text file (or default)
INPUT_FILE="${1:-../StoryCode_VoiceSynthesis.md}"
OUTPUT_FILE="${2:-../audio/voice_synthesis_story_chirp.wav}"

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Input file not found: $INPUT_FILE"
    echo "   Usage: $0 [input_file] [output_file]"
    exit 1
fi

# Create output directory
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "📖 Reading: $INPUT_FILE"
echo "🎧 Output: $OUTPUT_FILE"

# Extract and clean text from markdown
TEXT_CONTENT=$(cat "$INPUT_FILE" | \
    # Remove markdown headers
    sed 's/^#\+\s*//g' | \
    # Remove markdown bold/italic
    sed 's/\*\*\([^*]*\)\*\*/\1/g' | \
    sed 's/\*\([^*]*\)\*/\1/g' | \
    # Remove code blocks
    sed 's/`\([^`]*\)`/ \1 /g' | \
    # Handle technical terms
    sed 's/\.md\b/ dot markdown/g' | \
    sed 's/\.py\b/ dot pie/g' | \
    sed 's/\bAPI\b/A P I/g' | \
    sed 's/\bCLI\b/C L I/g' | \
    sed 's/--\([a-zA-Z-]*\)/ dash dash \1/g' | \
    # Clean up extra whitespace
    tr -s ' ' | \
    # Limit length for API
    head -c 4500
)

# Escape text for JSON
JSON_TEXT=$(echo "$TEXT_CONTENT" | jq -Rs .)

echo "🔄 Generating audio with Google Cloud TTS..."

# Make the API call
curl -X POST -H "Content-Type: application/json" \
-H "X-Goog-User-Project: $PROJECT_ID" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data "{
  \"input\": {
    \"text\": $JSON_TEXT
  },
  \"voice\": {
    \"languageCode\": \"en-GB\",
    \"name\": \"en-GB-Chirp3-HD-Achernar\"
  },
  \"audioConfig\": {
    \"audioEncoding\": \"LINEAR16\",
    \"speakingRate\": 0.9,
    \"pitch\": 0.0,
    \"volumeGainDb\": 0.0
  }
}" "https://texttospeech.googleapis.com/v1/text:synthesize" | \
jq -r '.audioContent' | base64 --decode > "$OUTPUT_FILE"

if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ] && [ -s "$OUTPUT_FILE" ]; then
    echo "✅ Audio generated successfully!"
    echo "🎧 File: $OUTPUT_FILE"
    echo "🚶 Ready for walking meditation!"
    
    # Show file info
    ls -lh "$OUTPUT_FILE"
else
    echo "❌ Audio generation failed"
    exit 1
fi