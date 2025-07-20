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

# Extract and clean text from markdown with improved TTS optimization
TEXT_CONTENT=$(cat "$INPUT_FILE" | \
    # Remove markdown headers but keep content
    sed 's/^#\+\s*//g' | \
    # Remove markdown formatting
    sed 's/\*\*\([^*]*\)\*\*/\1/g' | \
    sed 's/\*\([^*]*\)\*/\1/g' | \
    # Convert code blocks to speech-friendly format
    sed 's/`\([^`]*\)`/ code \1 /g' | \
    # Improve technical term pronunciation
    sed 's/\.md\b/ dot M D file/g' | \
    sed 's/\.py\b/ dot Python file/g' | \
    sed 's/\.sh\b/ dot shell script/g' | \
    sed 's/\.mp3\b/ dot M P 3 file/g' | \
    sed 's/\bAPI\b/A P I/g' | \
    sed 's/\bCLI\b/command line interface/g' | \
    sed 's/\bMP3\b/M P 3/g' | \
    sed 's/\bTTS\b/text to speech/g' | \
    sed 's/\bID3\b/I D 3/g' | \
    sed 's/--\([a-zA-Z-]*\)/ dash dash \1/g' | \
    # Convert technical punctuation
    sed 's/&/and/g' | \
    sed 's/@/ at /g' | \
    # Clean up extra whitespace and newlines
    tr '\n' ' ' | tr -s ' ' | \
    # Limit length for API with safety margin
    head -c 4000
)

# Escape text for JSON
JSON_TEXT=$(echo "$TEXT_CONTENT" | jq -Rs .)

echo "🔄 Generating audio with Google Cloud TTS..."

# Validate text length before API call
TEXT_LENGTH=${#TEXT_CONTENT}
echo "📏 Text length: $TEXT_LENGTH characters"

if [ $TEXT_LENGTH -lt 10 ]; then
    echo "❌ Text content too short ($TEXT_LENGTH chars). Check input file."
    exit 1
fi

if [ $TEXT_LENGTH -gt 4000 ]; then
    echo "⚠️  Text content long ($TEXT_LENGTH chars). May hit API limits."
fi

# Make the API call with improved error handling
echo "🔄 Calling Google Cloud TTS API..."
API_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
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
    \"volumeGainDb\": 0.0,
    \"sampleRateHertz\": 24000
  }
}" "https://texttospeech.googleapis.com/v1/text:synthesize")

# Check for API errors
if echo "$API_RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    echo "❌ API Error:"
    echo "$API_RESPONSE" | jq -r '.error.message'
    exit 1
fi

# Extract and decode audio content
echo "$API_RESPONSE" | jq -r '.audioContent' | base64 --decode > "$OUTPUT_FILE"

# Validate output file
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "❌ Output file was not created"
    exit 1
fi

FILE_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "❌ Output file too small ($FILE_SIZE bytes). Likely an error occurred."
    echo "💡 Try simplifying the input text or removing special characters."
    exit 1
fi

echo "✅ Audio generated successfully!"
echo "🎧 File: $OUTPUT_FILE"
echo "📊 Size: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo "🚶 Ready for walking meditation!"

# Show file info
ls -lh "$OUTPUT_FILE"