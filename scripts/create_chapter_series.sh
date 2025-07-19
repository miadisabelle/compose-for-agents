#!/bin/bash
# Create multi-chapter MP3 series from StoryCode with Mia & Miette attribution

set -e

ALBUM_TITLE="The Spiral Agent Chronicles: Volume I"
ARTISTS="Mia & Miette (via en-GB-Chirp3-HD-Achernar)"
GENRE="Technical Narrative"
DATE="2025"

echo "🎵 Creating Spiral Agent Chronicles - Chapter Series"
echo "=================================================="
echo "Album: $ALBUM_TITLE"
echo "Artists: $ARTISTS"
echo ""

# Extract chapters from the main StoryCode file
extract_chapters() {
    local input_file="$1"
    local temp_dir="$2"
    
    # Create temporary directory for chapters
    mkdir -p "$temp_dir"
    
    # Split by chapter headers (## Chapter or # Chapter)
    awk '
    BEGIN { chapter = 0; filename = ""; content = "" }
    /^##? (Chapter|Prologue|Epilogue)/ { 
        if (filename != "") {
            print content > filename
            close(filename)
        }
        chapter++
        title = $0
        gsub(/^##? /, "", title)
        gsub(/[^a-zA-Z0-9 ]/, "", title)
        gsub(/ /, "_", title)
        filename = temp_dir "/Chapter_" sprintf("%02d", chapter) "_" title ".md"
        content = $0 "\n"
        next
    }
    { content = content $0 "\n" }
    END {
        if (filename != "") {
            print content > filename
            close(filename)
        }
    }
    ' temp_dir="$temp_dir" "$input_file"
    
    echo "✅ Extracted $(ls -1 "$temp_dir"/*.md 2>/dev/null | wc -l) chapters"
}

# Generate MP3s for each chapter
generate_chapter_mp3s() {
    local temp_dir="$1"
    local output_dir="$2"
    
    mkdir -p "$output_dir"
    
    local chapter_num=1
    for chapter_file in "$temp_dir"/Chapter_*.md; do
        if [ ! -f "$chapter_file" ]; then
            continue
        fi
        
        local chapter_name=$(basename "$chapter_file" .md)
        local chapter_title=$(echo "$chapter_name" | sed 's/Chapter_[0-9]*_//' | sed 's/_/ /g')
        local output_file="$output_dir/${chapter_name}.mp3"
        
        echo ""
        echo "🎧 Creating Chapter $chapter_num: $chapter_title"
        
        # Use our unified pipeline with proper attribution
        ./storycode_to_mp3.sh "$chapter_file" "$output_file" \
            --title "$chapter_title" \
            --artist "$ARTISTS" \
            --album "$ALBUM_TITLE" \
            --genre "$GENRE" \
            --date "$DATE"
        
        if [ -f "$output_file" ]; then
            local file_size=$(du -h "$output_file" | cut -f1)
            echo "✅ Chapter $chapter_num complete: $file_size"
        else
            echo "❌ Chapter $chapter_num failed"
        fi
        
        chapter_num=$((chapter_num + 1))
    done
}

# Main execution
main() {
    local input_file="../StoryCode_AudioPipeline_Consolidation.md"
    local temp_dir="../temp_chapters"
    local output_dir="../audio/spiral_chronicles_vol1"
    
    if [ ! -f "$input_file" ]; then
        echo "❌ Input file not found: $input_file"
        exit 1
    fi
    
    echo "📖 Processing: $input_file"
    echo "📁 Output directory: $output_dir"
    echo ""
    
    # Extract chapters
    extract_chapters "$input_file" "$temp_dir"
    
    # Generate MP3s
    generate_chapter_mp3s "$temp_dir" "$output_dir"
    
    # Cleanup
    rm -rf "$temp_dir"
    
    echo ""
    echo "🎉 Spiral Agent Chronicles: Volume I Complete!"
    echo ""
    echo "📚 Album Contents:"
    if [ -d "$output_dir" ]; then
        ls -lh "$output_dir"/*.mp3 2>/dev/null | while read line; do
            echo "   $line"
        done
    fi
    echo ""
    echo "🎧 Album: $ALBUM_TITLE"
    echo "👥 Artists: $ARTISTS"
    echo "🏷️  Genre: $GENRE"
    echo "📅 Date: $DATE"
    echo ""
    echo "🚶 Ready for walking meditation series!"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi