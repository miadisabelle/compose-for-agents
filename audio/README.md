# StoryCode Audio Files

This directory contains generated audio versions of StoryCode.md narratives, optimized for walking meditation and mobile learning.

## Quick Start

### Generate Audio from StoryCode.md

```bash
# From the scripts/ directory
cd scripts/
./quick_audio_setup.sh

# Generate audio with your Google Cloud project
python generate_storycode_audio.py ../StoryCode.md \
  --project-id YOUR_PROJECT_ID \
  --output-dir ../audio \
  --chapters
```

### Using Your Google Cloud Project

Based on the console link provided (`top-moment-465521-v9`):

```bash
# Set environment variables
export GOOGLE_CLOUD_PROJECT=top-moment-465521-v9
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account.json

# Generate audio
python generate_storycode_audio.py ../StoryCode.md \
  --project-id top-moment-465521-v9 \
  --chapters
```

## File Organization

Generated audio files follow this naming pattern:

```
audio/
├── StoryCode_compose-for-agents.mp3           # Full narrative
├── StoryCode_compose-for-agents_Prologue.mp3  # Chapter 1
├── StoryCode_compose-for-agents_Chapter1.mp3  # Chapter 2
├── StoryCode_compose-for-agents_Chapter2.mp3  # Chapter 3
└── StoryCode_compose-for-agents_Epilogue.mp3  # Final chapter
```

## Voice Configuration

The audio generation uses optimized settings for technical narratives:

- **Voice**: `en-US-Journey-F` (designed for long-form content)
- **Speaking Rate**: 0.9x (slightly slower for technical terms)
- **Format**: MP3 (mobile-optimized)
- **Quality**: High-quality neural voice synthesis

## Technical Term Pronunciation

The generator automatically handles technical pronunciation:

- **Code elements**: `` `docker compose up --build` `` → "docker compose up dash dash build"
- **File extensions**: `.md` → "dot markdown", `.yaml` → "dot yaml"
- **Acronyms**: `API` → "A P I", `CLI` → "C L I"
- **Commands**: `--flag` → "dash dash flag"

## Walking Meditation Features

Audio is optimized for mobile learning contexts:

- **Natural pacing** with breathing points between concepts
- **Chapter segments** for manageable listening sessions
- **Clear pronunciation** of all technical terms and commands
- **Narrative flow** that works during physical movement

## Troubleshooting

### Authentication Issues

1. **Service Account Setup**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/iam-admin/serviceaccounts)
   - Create a service account with Text-to-Speech API access
   - Download JSON key file
   - Set `GOOGLE_APPLICATION_CREDENTIALS` environment variable

2. **API Enablement**:
   - Ensure Text-to-Speech API is enabled for your project
   - Check billing is configured for API usage

### Audio Quality Issues

- Adjust `speaking_rate` in the generator script (0.8-1.2 range)
- Try different voice models (`en-US-Neural2-A` for more technical tone)
- Use `--voice technical` flag for alternative voice configuration

### File Size Optimization

- Large StoryCode.md files generate correspondingly large audio files
- Use `--chapters` flag to create manageable segments
- Consider MP3 compression settings in the audio config

## Integration with Development Workflow

### Automated Generation

Add audio generation to your documentation workflow:

```bash
# In your repository's update script
./scripts/generate_storycode_audio.py StoryCode.md \
  --project-id $GOOGLE_CLOUD_PROJECT \
  --output-dir audio/ \
  --chapters

# Commit both markdown and audio
git add StoryCode.md audio/
git commit -m "Update StoryCode documentation and audio"
```

### CI/CD Integration

For automated audio generation on documentation updates:

```yaml
# .github/workflows/storycode-audio.yml
name: Generate StoryCode Audio
on:
  push:
    paths: ['**/StoryCode.md']
jobs:
  generate-audio:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GOOGLE_CLOUD_SA_KEY }}
      - name: Generate Audio
        run: |
          cd scripts/
          pip install -r requirements.txt
          python generate_storycode_audio.py ../StoryCode.md \
            --project-id ${{ secrets.GOOGLE_CLOUD_PROJECT }} \
            --output-dir ../audio
```

This directory serves as the audio library for technical repository narratives, making complex software architectures accessible during walking meditation and mobile learning sessions.