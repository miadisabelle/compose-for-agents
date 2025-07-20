#!/bin/bash
# Create multi-chapter MP3 series from StoryCode with Mia & Miette attribution

set -e

# Default configuration - can be overridden by command line
ALBUM_TITLE="The Spiral Agent Chronicles: Volume I"
ARTISTS="Mia & Miette"
GENRE="Technical Narrative"
DATE="$(date +%Y)"

echo "🎵 Creating Spiral Agent Chronicles - Chapter Series"
echo "=================================================="
echo "Album: $ALBUM_TITLE"
echo "Artists: $ARTISTS"
echo ""

# Extract chapters from the main StoryCode file with improved parsing
extract_chapters() {
    local input_file="$1"
    local temp_dir="$2"
    
    # Validate input
    if [ ! -f "$input_file" ]; then
        echo "❌ Input file not found: $input_file"
        return 1
    fi
    
    # Create temporary directory for chapters
    mkdir -p "$temp_dir"
    
    # Check content length before processing
    local total_chars=$(wc -c < "$input_file")
    echo "📊 Total content: $total_chars characters"
    
    # Split by chapter headers with better content validation
    awk '
    BEGIN { chapter = 0; filename = ""; content = ""; chars = 0 }
    /^##? (Chapter|Prologue|Epilogue)/ { 
        if (filename != "") {
            if (chars > 10) {
                print content > filename
                printf "   Chapter %d: %d characters\n", chapter, chars > "/dev/stderr"
            }
            close(filename)
        }
        chapter++
        title = $0
        gsub(/^##? /, "", title)
        gsub(/[^a-zA-Z0-9 ]/, "", title)
        gsub(/ /, "_", title)
        filename = temp_dir "/Chapter_" sprintf("%02d", chapter) "_" title ".md"
        content = $0 "\n"
        chars = length($0) + 1
        next
    }
    { 
        content = content $0 "\n" 
        chars += length($0) + 1
    }
    END {
        if (filename != "" && chars > 10) {
            print content > filename
            printf "   Chapter %d: %d characters\n", chapter, chars > "/dev/stderr"
            close(filename)
        }
    }
    ' temp_dir="$temp_dir" "$input_file"
    
    local chapter_count=$(ls -1 "$temp_dir"/*.md 2>/dev/null | wc -l)
    echo "✅ Extracted $chapter_count chapters"
    
    # Validate chapter lengths
    local long_chapters=0
    for chapter_file in "$temp_dir"/*.md; do
        if [ -f "$chapter_file" ]; then
            local char_count=$(wc -c < "$chapter_file")
            if [ "$char_count" -gt 4000 ]; then
                echo "⚠️  Warning: $(basename "$chapter_file") is $char_count chars (may exceed TTS limits)"
                long_chapters=$((long_chapters + 1))
            fi
        fi
    done
    
    if [ "$long_chapters" -gt 0 ]; then
        echo "⚠️  $long_chapters chapters may be too long for TTS processing"
    fi
    
    return 0
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
        
        # Use refined pipeline for better reliability
        if [ -x "./storycode_to_mp3_refined.sh" ]; then
            ./storycode_to_mp3_refined.sh "$chapter_file" \
                --artist "$ARTISTS" \
                --album "$ALBUM_TITLE"
        else
            # Fallback to original script
            ./storycode_to_mp3.sh "$chapter_file" "$output_file" \
                --title "$chapter_title" \
                --artist "$ARTISTS" \
                --album "$ALBUM_TITLE" \
                --genre "$GENRE" \
                --date "$DATE"
        fi
        
        if [ -f "$output_file" ]; then
            local file_size=$(du -h "$output_file" | cut -f1)
            echo "✅ Chapter $chapter_num complete: $file_size"
        else
            echo "❌ Chapter $chapter_num failed"
        fi
        
        chapter_num=$((chapter_num + 1))
    done
}

# Main execution with command line support
main() {
    local input_file="$1"
    local temp_dir="../temp_chapters"
    local output_dir
    
    # Default input if not provided
    if [ -z "$input_file" ]; then
        input_file="../StoryCode_AudioPipeline_Consolidation.md"
    fi
    
    if [ ! -f "$input_file" ]; then
        echo "❌ Input file not found: $input_file"
        echo "Usage: $0 [input_storycode_file.md]"
        exit 1
    fi
    
    # Generate output directory from input filename
    local base_name=$(basename "$input_file" .md)
    output_dir="../audio/$(echo "$base_name" | sed 's/[^a-zA-Z0-9]/_/g')"
    
    # Update album title based on input file
    if [[ "$input_file" != *"AudioPipeline_Consolidation"* ]]; then
        ALBUM_TITLE="$(echo "$base_name" | sed 's/_/ /g'): Audio Series"
    fi
    
    echo "📖 Processing: $input_file"
    echo "📁 Output directory: $output_dir"
    echo ""
    
    # Extract chapters
    extract_chapters "$input_file" "$temp_dir"
    
    # Generate MP3s
    generate_chapter_mp3s "$temp_dir" "$output_dir"
    
    # Optional cleanup (keep chapters for debugging if needed)
    echo "🧹 Cleaning up temporary files..."
    if [ "$KEEP_CHAPTERS" != "true" ]; then
        rm -rf "$temp_dir"
        echo "✅ Temporary chapters removed"
    else
        echo "📁 Chapters preserved in: $temp_dir"
    fi
    
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