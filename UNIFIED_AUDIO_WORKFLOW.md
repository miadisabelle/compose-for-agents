# Unified Audio Workflow Guide
**StoryCode → Professional MP3 Audio Generation**

> **Note**: This replaces both [AUDIO_WORKFLOW_PROCEDURE.md](./AUDIO_WORKFLOW_PROCEDURE.md) and [STORYCODE_AUDIO_QUICKSTART.md](./STORYCODE_AUDIO_QUICKSTART.md) to eliminate duplication.

## 🚀 **One-Command Workflow** 

### **For agents in any directory:**
```bash
# Navigate to the audio workflow scripts (from anywhere in the repository)
cd /a/src/compose-for-agents/scripts/

# Generate audio from any StoryCode file
./storycode_to_mp3_refined.sh /path/to/your/StoryCode.md --artist "Your Name" --album "Your Album"
```

### **Multi-chapter series:**
```bash
./create_chapter_series.sh /path/to/LongStoryCode.md --artist "Your Name" --album "Your Series"
```

## 📍 **Context-Aware Usage**

### **From agent directories:**
```bash
# From agno/, a2a/, crew-ai/, etc.
cd ../../scripts/  # or use absolute path
./storycode_to_mp3_refined.sh ../StoryCode.md --artist "Mia & Miette" --album "My Chronicles"
```

### **From repository root:**
```bash
cd scripts/
./storycode_to_mp3_refined.sh ../StoryCode.md --artist "Mia & Miette" --album "My Chronicles"
```

## 🛠️ **One-Time Setup**

```bash
cd /a/src/compose-for-agents/scripts/
./quick_audio_setup.sh
```

**This automatically:**
- ✅ Installs Python dependencies (mutagen, pydub)
- ✅ Validates gcloud authentication
- ✅ Checks project configuration
- ✅ Makes scripts executable

## 📝 **Standard Metadata**

**Always use consistent parameters:**
- `--artist "Mia & Miette"` (clean attribution)
- `--album "Project Name: Volume X"` (series naming)
- Genre: "Technical Narrative" (auto-applied)
- Date: Current year (auto-applied)

## 📁 **Output Structure**

Files are created with clean organization:
```
audio/Your_Album_Name/
├── 01_Chapter_Name.mp3         # Clean numbered tracks
├── 02_Next_Chapter.mp3         # Professional metadata
├── source_manifest.json        # Traceability information
└── README.md                   # Auto-generated guide
```

## 🔄 **Source Traceability**

Every audio generation creates a JSON manifest:
```json
{
  "source_file": "./YourStoryCode.md",
  "output_directory": "./audio/Your_Album/", 
  "artist": "Your Name",
  "album": "Your Album",
  "timestamp": "2025-07-20T21:30:00Z",
  "chapters": [...],
  "technical_details": {...}
}
```

## 🎯 **Content Guidelines**

### **Character Limits:**
- **Single files**: Max 4,000 characters (TTS API safety limit)
- **Multi-chapter**: Automatically split if longer
- **Validation**: Automatic upfront checking

### **Markdown Optimization:**
- ✅ Clean headings and paragraphs work best
- ⚠️ Backticks converted to "code blocks" for TTS
- ⚠️ Technical terms automatically optimized for pronunciation

## 🔧 **Advanced Usage**

### **Custom metadata:**
```bash
./storycode_to_mp3_refined.sh MyStory.md \
  --artist "Custom Name" \
  --album "Special Collection"
```

### **Preview mode:**
```bash
./storycode_to_mp3_refined.sh MyStory.md --dry-run
```

### **Multi-chapter with custom metadata:**
```bash
./create_chapter_series.sh LongStory.md \
  --artist "Mia & Miette" \
  --album "Chronicles: Volume III"
```

## 🆘 **Troubleshooting**

### **Common Issues:**

**"Content too long" error:**
- **Solution**: Use `./create_chapter_series.sh` for automatic chapter splitting
- **Limit**: 4,000 characters per TTS call

**"Voice synthesis produced empty file":**
- **Cause**: Special characters or content formatting issues
- **Solution**: Simplify markdown, remove complex code blocks

**"MP3 conversion failed":**
- **Cause**: Missing Python dependencies
- **Solution**: Run `./quick_audio_setup.sh` again

**Path not found errors:**
- **Cause**: Running from wrong directory
- **Solution**: Use absolute paths: `cd /a/src/compose-for-agents/scripts/`

## 📚 **Examples from This Repository**

### **Volume I Chronicles:**
```bash
./create_chapter_series.sh ../StoryCode_AudioPipeline_Consolidation.md \
  --artist "Mia & Miette" \
  --album "The Spiral Agent Chronicles: Volume I"
```
**Result**: [audio/The_Spiral_Agent_Chronicles_Volume_I/](./audio/The_Spiral_Agent_Chronicles_Volume_I/)

### **Volume II Chronicles:**
```bash
./create_chapter_series.sh ../StoryCode_Chronicles_VolumeII.md \
  --artist "Mia & Miette" \
  --album "The Spiral Agent Chronicles: Volume II"
```
**Result**: [audio/StoryCode_Chronicles_VolumeII_Audio_Series/](./audio/StoryCode_Chronicles_VolumeII_Audio_Series/)

## 🔍 **Service Discovery**

### **For agents in other parts of the system:**

**From any agent directory:**
1. Check if audio capability exists: `ls ../../scripts/storycode_to_mp3_refined.sh`
2. Navigate to workflow: `cd ../../scripts/`
3. Run setup if needed: `./quick_audio_setup.sh`
4. Generate audio: `./storycode_to_mp3_refined.sh /path/to/story.md`

**From Docker containers:**
Mount the scripts directory and use absolute paths to the workflow scripts.

## 📖 **Related Documentation**

- **[StoryCode_Chronicles_VolumeII.md](./StoryCode_Chronicles_VolumeII.md)**: Complete analysis of this system
- **[VOLUME_II_CHRONICLES_LEDGER.md](./VOLUME_II_CHRONICLES_LEDGER.md)**: Technical implementation plan
- **[CLAUDE.md](./CLAUDE.md)**: Integration with broader Compose for Agents ecosystem
- **Knowledge Graph**: Complete workflow captured in MCP stcmastery-compose-for-agents

## ⚡ **Quick Reference**

| Task | Command |
|------|---------|
| **Single story** | `./storycode_to_mp3_refined.sh story.md --artist "Name" --album "Album"` |
| **Multi-chapter** | `./create_chapter_series.sh long_story.md --artist "Name" --album "Series"` |
| **Setup** | `./quick_audio_setup.sh` |
| **Preview** | `./storycode_to_mp3_refined.sh story.md --dry-run` |

---

**This workflow is part of the broader [Compose for Agents](./README.md) ecosystem, specifically the Mia & Miette agent embodiment system.**