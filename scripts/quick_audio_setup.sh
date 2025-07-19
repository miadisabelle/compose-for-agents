#!/bin/bash
# Quick setup script for StoryCode audio generation

set -e

echo "🎵 Setting up StoryCode Audio Generation..."

# Check if we're in the right directory
if [ ! -f "../StoryCode.md" ]; then
    echo "⚠️  Run this script from the scripts/ directory with StoryCode.md in parent directory"
    exit 1
fi

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Check for Google Cloud credentials
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "⚠️  GOOGLE_APPLICATION_CREDENTIALS environment variable not set"
    echo "   Please set it to point to your service account JSON file:"
    echo "   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/credentials.json"
    echo ""
    echo "   Or pass --credentials flag to the generation script"
fi

# Check for project ID
if [ -z "$GOOGLE_CLOUD_PROJECT" ]; then
    echo "⚠️  GOOGLE_CLOUD_PROJECT environment variable not set"
    echo "   Please set it to your Google Cloud project ID:"
    echo "   export GOOGLE_CLOUD_PROJECT=your-project-id"
    echo ""
    echo "   Or pass --project-id flag to the generation script"
fi

# Create audio output directory
mkdir -p ../audio

echo "✅ Setup complete!"
echo ""
echo "🚀 To generate audio from StoryCode.md:"
echo "   python generate_storycode_audio.py ../StoryCode.md --project-id YOUR_PROJECT_ID"
echo ""
echo "📖 Or for the repository chronicle specifically:"
echo "   python generate_storycode_audio.py ../StoryCode.md \\"
echo "     --project-id top-moment-465521-v9 \\"
echo "     --output-dir ../audio \\"
echo "     --chapters"
echo ""
echo "🎧 Audio files will be created in ../audio/ directory"