## Chapter 3: The Architecture of Unified Audio Production

The consolidation required careful architectural thinking. We designed a two-stage pipeline wrapped in an intelligent orchestration layer:

**Stage 1: Voice Synthesis**
- Input: StoryCode markdown file
- Process: Text extraction, pronunciation optimization, Google Cloud TTS with Chirp3-HD-Achernar
- Output: High-quality WAV file (LINEAR16, 24kHz)

**Stage 2: Audio Enhancement**
- Input: WAV file from Stage 1
- Process: Format conversion, quality optimization, metadata embedding
- Output: Professional MP3 with ID3v2.4.0 tags

**Orchestration Intelligence:**
- **Smart Defaults**: Auto-generate titles from filenames, set appropriate artist/album/genre
- **Error Handling**: Validate dependencies, check file existence, handle failures gracefully
- **Cleanup Management**: Remove intermediate files unless explicitly requested to keep them
- **Preview Mode**: Dry-run capability to show what would happen without executing

**The Metadata Standards:**
We established clear standards for how StoryCode narratives should be tagged:
- **Title**: Derived from filename or customizable
- **Artist**: "en-GB-Chirp3-HD-Achernar" (proper voice attribution)
- **Album**: "Repository StoryCode Chronicles" (organized collection)
- **Genre**: "Technical Narrative" or "Walking Meditation"
- **Date**: Current year or customizable

---


