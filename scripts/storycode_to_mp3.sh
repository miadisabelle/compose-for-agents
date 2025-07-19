#!/bin/bash
# StoryCode to MP3 Pipeline - Complete Audio Production Workflow
# Combines voice synthesis + audio enhancement into one streamlined process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_VOICE="en-GB-Chirp3-HD-Achernar"
DEFAULT_BITRATE="320k"
DEFAULT_GENRE="Technical Narrative"
DEFAULT_ALBUM="Repository StoryCode Chronicles"

show_usage() {
    echo "🎵 StoryCode to MP3 Pipeline"
    echo ""
    echo "Usage: $0 <input_storycode.md> [output.mp3] [options]"
    echo ""
    echo "Options:"
    echo "  --title TITLE       Audio title (default: derived from filename)"
    echo "  --artist ARTIST     Artist name (default: $DEFAULT_VOICE)"
    echo "  --album ALBUM       Album name (default: $DEFAULT_ALBUM)"
    echo "  --genre GENRE       Genre (default: $DEFAULT_GENRE)"
    echo "  --date DATE         Date (default: current year)"
    echo "  --bitrate RATE      MP3 bitrate (default: $DEFAULT_BITRATE)"
    echo "  --keep-wav          Keep intermediate WAV file"
    echo "  --dry-run           Show what would be done without executing"
    echo ""
    echo "Examples:"
    echo "  $0 ../StoryCode.md                                    # Simple conversion"
    echo "  $0 ../StoryCode.md my_story.mp3 --title \"My Story\"   # Custom title"
    echo "  $0 ../StoryCode.md --keep-wav --dry-run               # Preview with WAV retention"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_dependencies() {
    local missing_deps=()
    
    # Check gcloud
    if ! command -v gcloud &> /dev/null; then
        missing_deps+=("gcloud")
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    # Check Python dependencies
    if ! python -c "import mutagen, pydub" 2>/dev/null; then
        missing_deps+=("audio-pipeline-toolkit Python dependencies")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        echo ""
        echo "To install:"
        echo "  gcloud: https://cloud.google.com/sdk/docs/install"
        echo "  jq: apt install jq (or brew install jq)"
        echo "  Python deps: pip install -r ../audio-pipeline-toolkit/requirements.txt"
        return 1
    fi
    
    return 0
}

generate_voice_synthesis() {
    local input_file="$1"
    local wav_output="$2"
    local dry_run="$3"
    
    log_info "Stage 1: Voice synthesis using $DEFAULT_VOICE"
    
    if [ "$dry_run" = "true" ]; then
        log_info "Would run: ./voice_synthesis_gcloud.sh \"$input_file\" \"$wav_output\""
        return 0
    fi
    
    if [ ! -f "./voice_synthesis_gcloud.sh" ]; then
        log_error "voice_synthesis_gcloud.sh not found in current directory"
        return 1
    fi
    
    ./voice_synthesis_gcloud.sh "$input_file" "$wav_output"
    
    if [ ! -f "$wav_output" ] || [ ! -s "$wav_output" ]; then
        log_error "Voice synthesis failed or produced empty file"
        return 1
    fi
    
    local file_size=$(du -h "$wav_output" | cut -f1)
    log_success "Voice synthesis complete: $wav_output ($file_size)"
    return 0
}

convert_to_tagged_mp3() {
    local wav_input="$1"
    local mp3_output="$2"
    local title="$3"
    local artist="$4"
    local album="$5"
    local genre="$6"
    local date="$7"
    local bitrate="$8"
    local dry_run="$9"
    
    log_info "Stage 2: Converting to tagged MP3"
    log_info "  Title: $title"
    log_info "  Artist: $artist"
    log_info "  Album: $album"
    log_info "  Genre: $genre"
    log_info "  Date: $date"
    log_info "  Bitrate: $bitrate"
    
    if [ "$dry_run" = "true" ]; then
        log_info "Would run: python ../audio-pipeline-toolkit/audio_prep_format_n_tags.py ..."
        return 0
    fi
    
    python ../audio-pipeline-toolkit/audio_prep_format_n_tags.py \
        --title "$title" \
        --artist "$artist" \
        --album "$album" \
        --genre "$genre" \
        --date "$date" \
        --bitrate "$bitrate" \
        "$wav_input" "$mp3_output"
    
    if [ ! -f "$mp3_output" ] || [ ! -s "$mp3_output" ]; then
        log_error "MP3 conversion failed or produced empty file"
        return 1
    fi
    
    local file_size=$(du -h "$mp3_output" | cut -f1)
    log_success "MP3 conversion complete: $mp3_output ($file_size)"
    return 0
}

main() {
    # Parse arguments
    local input_file=""
    local output_file=""
    local title=""
    local artist="$DEFAULT_VOICE"
    local album="$DEFAULT_ALBUM"
    local genre="$DEFAULT_GENRE"
    local date=$(date +%Y)
    local bitrate="$DEFAULT_BITRATE"
    local keep_wav="false"
    local dry_run="false"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --title)
                title="$2"
                shift 2
                ;;
            --artist)
                artist="$2"
                shift 2
                ;;
            --album)
                album="$2"
                shift 2
                ;;
            --genre)
                genre="$2"
                shift 2
                ;;
            --date)
                date="$2"
                shift 2
                ;;
            --bitrate)
                bitrate="$2"
                shift 2
                ;;
            --keep-wav)
                keep_wav="true"
                shift
                ;;
            --dry-run)
                dry_run="true"
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                if [ -z "$input_file" ]; then
                    input_file="$1"
                elif [ -z "$output_file" ]; then
                    output_file="$1"
                else
                    log_error "Too many positional arguments"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate inputs
    if [ -z "$input_file" ]; then
        log_error "Input StoryCode file required"
        show_usage
        exit 1
    fi
    
    if [ ! -f "$input_file" ]; then
        log_error "Input file not found: $input_file"
        exit 1
    fi
    
    # Generate output filename if not provided
    if [ -z "$output_file" ]; then
        local basename=$(basename "$input_file" .md)
        output_file="../audio/${basename}_story.mp3"
    fi
    
    # Generate title if not provided
    if [ -z "$title" ]; then
        title=$(basename "$input_file" .md | sed 's/_/ /g' | sed 's/\b\w/\u&/g')
    fi
    
    # Generate intermediate WAV filename
    local wav_file="${output_file%.mp3}_temp.wav"
    
    echo "🎵 StoryCode to MP3 Pipeline"
    echo "================================"
    echo "Input:  $input_file"
    echo "Output: $output_file"
    echo "Title:  $title"
    echo ""
    
    # Check dependencies
    if ! check_dependencies; then
        exit 1
    fi
    
    # Create output directory
    local output_dir=$(dirname "$output_file")
    if [ "$dry_run" != "true" ]; then
        mkdir -p "$output_dir"
    fi
    
    # Stage 1: Voice Synthesis
    if ! generate_voice_synthesis "$input_file" "$wav_file" "$dry_run"; then
        exit 1
    fi
    
    # Stage 2: MP3 Conversion with Tags
    if ! convert_to_tagged_mp3 "$wav_file" "$output_file" "$title" "$artist" "$album" "$genre" "$date" "$bitrate" "$dry_run"; then
        exit 1
    fi
    
    # Cleanup intermediate WAV file unless requested to keep
    if [ "$keep_wav" != "true" ] && [ "$dry_run" != "true" ] && [ -f "$wav_file" ]; then
        rm "$wav_file"
        log_info "Cleaned up intermediate WAV file"
    elif [ "$keep_wav" = "true" ] && [ "$dry_run" != "true" ]; then
        log_info "Intermediate WAV file preserved: $wav_file"
    fi
    
    if [ "$dry_run" != "true" ]; then
        echo ""
        log_success "Audio production pipeline complete!"
        log_success "🎧 Final audio: $output_file"
        echo ""
        echo "🚶 Ready for walking meditation!"
        
        # Show file info
        if command -v file &> /dev/null; then
            echo "📊 File info: $(file "$output_file" | cut -d: -f2-)"
        fi
        if [ -f "$output_file" ]; then
            echo "📐 File size: $(du -h "$output_file" | cut -f1)"
        fi
    else
        echo ""
        log_info "Dry run complete - no files were created"
    fi
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi