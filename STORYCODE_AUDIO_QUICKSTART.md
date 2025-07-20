# StoryCode Audio Workflow - Quick Start

**Specific guide for the StoryCode → MP3 audio generation capability within Compose for Agents**

> **Note**: This is ONE workflow among many in the Compose for Agents repository. 
> For other agent frameworks and demos, see the main [README.md](README.md)

## 🚀 **Simple 3-Step Process**

### **Step 1: Setup (One-time)**
```bash
cd scripts/
./quick_audio_setup.sh
```

### **Step 2: Create Your Story**
Write your story in a markdown file (like `MyStory.md`)

### **Step 3: Generate Audio**
```bash
./storycode_to_mp3_refined.sh ../MyStory.md --artist "Your Name" --album "Your Album"
```

**That's it!** Your professional MP3 will be in `../audio/Your_Album/`

## 📚 **For Multi-Chapter Albums**
```bash
./create_chapter_series.sh ../LongStory.md
```

## 📖 **Example: Creating a Chronicle Like Ours**

1. **Write your consolidation story** (how you solved a problem)
2. **Generate the album**:
   ```bash
   ./storycode_to_mp3_refined.sh ../MyConsolidationStory.md \
     --artist "Mia & Miette" \
     --album "My Project Chronicles: Volume I"
   ```
3. **Result**: Professional album with clean metadata in `../audio/My_Project_Chronicles_Volume_I/`

## 🆘 **If Confused**
- **Main documentation**: See `AUDIO_WORKFLOW_PROCEDURE.md`
- **Architecture**: See `CLAUDE.md`
- **Example output**: See `audio/The_Spiral_Agent_Chronicles_Volume_I/`

## ⚠️ **What NOT to Use**
- ❌ `storycode_to_mp3_legacy.sh` (old version, kept for reference)
- ❌ `demo_complete.sh` (development artifact)
- ❌ Any file with "legacy", "demo", or "sample" in the name

**Use only**: `storycode_to_mp3_refined.sh` and `create_chapter_series.sh`