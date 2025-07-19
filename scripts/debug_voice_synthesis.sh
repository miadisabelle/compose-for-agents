#!/bin/bash
# Debug voice synthesis to see what's happening

set -e

PROJECT_ID=$(gcloud config list --format='value(core.project)')
echo "🔍 Debugging voice synthesis with project: $PROJECT_ID"

# Simple test text
TEST_TEXT="Hello, this is a test of the voice synthesis system using the beautiful Chirp3-HD-Achernar voice."

echo "🔄 Making API call with debug output..."

# Make the API call and capture full response
RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
-H "X-Goog-User-Project: $PROJECT_ID" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data "{
  \"input\": {
    \"text\": \"$TEST_TEXT\"
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
}" "https://texttospeech.googleapis.com/v1/text:synthesize")

echo "📄 API Response:"
echo "$RESPONSE" | jq .

# Check if we got audioContent
if echo "$RESPONSE" | jq -e '.audioContent' > /dev/null; then
    echo "✅ Audio content found in response"
    echo "$RESPONSE" | jq -r '.audioContent' | base64 --decode > debug_test.wav
    echo "🎧 Test audio saved as debug_test.wav"
    ls -lh debug_test.wav
else
    echo "❌ No audio content in response"
    echo "🔍 Full response: $RESPONSE"
fi