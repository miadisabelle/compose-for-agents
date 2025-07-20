# Audio Workflow Procedure for Agents

## Simple One-Command Workflow (REFINED)

```bash
cd scripts/
./storycode_to_mp3_refined.sh ../StoryCode.md --artist "Mia & Miette" --album "Album Name"
```

**That's it.** One command produces a professional tagged MP3.

### Key Improvements in Refined Version:
✅ **Auto-installs** Python dependencies if missing  
✅ **Validates content** upfront (prevents TTS failures)  
✅ **Clean output** directories with consistent naming  
✅ **Robust error handling** with clear messages  
✅ **No manual cleanup** required

## Standard Metadata

**Always use these exact parameters:**
- `--artist "Mia & Miette"`
- `--album "Album Name"` (customize per project)
- `--genre "Technical Narrative"`
- `--date "2025"`

## Prerequisites (One-time setup)

```bash
# Install Python dependencies (if not already done)
pip install mutagen pydub

# Verify gcloud auth (should already be configured)
gcloud auth list
```

## Output Structure

Files are created in: `audio/Album_Name/`
- Clean numbered tracks: `01_Track_Name.mp3`
- Professional ID3v2.4.0 metadata
- 160kbps MP3, 24kHz, Monaural

## Multi-Chapter Albums

For album series, create chapter files first:

```bash
# Split long StoryCode into chapters (if needed)
./create_chapter_series.sh StoryCode.md

# Then process each chapter
for chapter in ../temp_chapters/Chapter_*.md; do
    ./storycode_to_mp3.sh "$chapter" --artist "Mia & Miette" --album "Series: Volume I"
done
```

## Troubleshooting

### Problem: Empty WAV files (3-byte files)
**Cause**: TTS character limit exceeded or special characters in markdown
**Solution**: 
1. Check chapter length: `wc -c ../StoryCode.md` (should be <5000 chars)
2. Remove backticks and special symbols from content
3. Simplify markdown formatting

### Problem: Scattered output files
**Cause**: Script running from wrong directory
**Solution**: Always run from `scripts/` directory: `cd scripts/`

### Problem: Metadata inconsistency
**Cause**: Manual metadata fixing attempts
**Solution**: Use standard parameters from the start, never manually fix metadata

### Problem: Missing dependencies
**Cause**: Python libraries not installed
**Solution**: `pip install mutagen pydub`

## Clean Workflow Example

```bash
# 1. Navigate to scripts
cd scripts/

# 2. Single story
./storycode_to_mp3.sh ../StoryCode.md --artist "Mia & Miette" --album "My Project"

# 3. Multi-chapter series
./create_chapter_series.sh ../LongStory.md
for chapter in ../temp_chapters/Chapter_*.md; do
    ./storycode_to_mp3.sh "$chapter" --artist "Mia & Miette" --album "Long Story: Volume I"
done

# 4. Clean up
rm -rf ../temp_chapters/  # Only after successful generation
```

## What NOT to Do

❌ **Don't** manually fix metadata afterward  
❌ **Don't** create "_fixed" or "_temp" files  
❌ **Don't** scatter files across multiple directories  
❌ **Don't** use the long artist name with voice model details  
❌ **Don't** run complex dependency checks - just install once  
❌ **Don't** attempt manual cleanup of failed generations  

## Success Indicators

✅ Single command execution  
✅ Clean numbered output files  
✅ Consistent metadata across all tracks  
✅ No manual intervention required  
✅ Professional audio quality (160kbps MP3)  

## File Structure Result

```
audio/
└── Album_Name/
    ├── 01_Track_Name.mp3  (professional metadata)
    ├── 02_Track_Name.mp3  (consistent formatting)
    └── 03_Track_Name.mp3  (clean numbering)
```

**Remember**: If it requires more than one command, you're doing it wrong.