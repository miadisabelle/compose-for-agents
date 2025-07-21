#!/bin/bash
# Quick setup script for StoryCode audio generation - Updated for refined pipeline

set -e

echo "🎵 Setting up StoryCode Audio Generation (Refined Pipeline)..."

# Check if we're in the right directory
if [ ! -f "storycode_to_mp3_refined.sh" ]; then
    echo "⚠️  Run this script from the scripts/ directory"
    echo "   Expected files: storycode_to_mp3_refined.sh, voice_synthesis_gcloud.sh"
    exit 1
fi

# Install Python dependencies
echo "📦 Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "Installing core audio dependencies..."
    pip install mutagen pydub
fi

# Install audio-pipeline-toolkit dependencies
if [ -f "../audio-pipeline-toolkit/requirements.txt" ]; then
    echo "📦 Installing audio toolkit dependencies..."
    pip install -r ../audio-pipeline-toolkit/requirements.txt
fi

# Check gcloud authentication
echo "🔐 Checking Google Cloud authentication..."
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI not found"
    echo "   Install from: https://cloud.google.com/sdk/docs/install"
    echo "   Then run: gcloud auth login"
    exit 1
fi

if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ No active gcloud authentication found"
    echo "   Please run: gcloud auth login"
    exit 1
fi

# Check project configuration
PROJECT_ID=$(gcloud config list --format='value(core.project)')
if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project ID configured"
    echo "   Please run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
else
    echo "✅ Using project: $PROJECT_ID"
fi

# Create audio output directory
mkdir -p ../audio

# Make scripts executable
chmod +x storycode_to_mp3_refined.sh voice_synthesis_gcloud.sh
if [ -f "create_chapter_series.sh" ]; then
    chmod +x create_chapter_series.sh
fi

echo "✅ Setup complete!"
echo ""
echo "🚀 To generate audio from any StoryCode file:"
echo "   ./storycode_to_mp3_refined.sh ../StoryCode.md"
echo ""
echo "🎨 With custom metadata:"
echo "   ./storycode_to_mp3_refined.sh ../StoryCode.md --artist \"Your Name\" --album \"Your Album\""
echo ""
echo "📚 For multi-chapter series:"
echo "   ./create_chapter_series.sh ../LongStoryCode.md"
echo ""
echo "🎧 Audio files will be created in ../audio/ directory"
echo "📖 See AUDIO_WORKFLOW_PROCEDURE.md for complete guide"