#!/bin/bash
# Refined StoryCode to MP3 Pipeline - Simplified and Robust
# Eliminates complexity and common failure points

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration - SIMPLIFIED
DEFAULT_ARTIST="Mia & Miette"
DEFAULT_GENRE="Technical Narrative"
DEFAULT_ALBUM="Repository StoryCode Chronicles"
DEFAULT_BITRATE="320k"

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

show_usage() {
    echo "🎵 StoryCode to MP3 Pipeline (Refined)"
    echo "Usage: $0 <input.md> [--artist \"Name\"] [--album \"Album\"] [--dry-run]"
    echo ""
    echo "Simple Examples:"
    echo "  $0 ../StoryCode.md"
    echo "  $0 ../StoryCode.md --artist \"Mia & Miette\" --album \"Volume I\""
}

# SIMPLIFIED dependency check - install if missing, don't fail
ensure_dependencies() {
    # Auto-install Python deps if missing
    if ! python -c "import mutagen, pydub" 2>/dev/null; then
        log_info "Installing Python dependencies..."
        pip install mutagen pydub -q
    fi
    
    # Check gcloud (required, can't auto-install)
    if ! command -v gcloud &> /dev/null; then
        log_error "gcloud CLI required. Install: https://cloud.google.com/sdk/docs/install"
        exit 1
    fi
}

# CONTENT VALIDATION - prevent TTS failures
validate_content() {
    local input_file="$1"
    local char_count=$(wc -c < "$input_file")
    
    log_info "Content validation: $char_count characters"
    
    if [ "$char_count" -gt 4500 ]; then
        log_error "Content too long ($char_count chars). TTS limit is ~4500 chars."
        echo "Consider splitting into chapters or simplifying content."
        exit 1
    fi
    
    # Check for problematic characters that cause TTS issues
    if grep -q '`' "$input_file"; then
        log_info "Found backticks - these sometimes cause TTS issues"
        log_info "Consider removing code blocks if generation fails"
    fi
}

# CLEAN output directory handling
setup_output() {
    local input_file="$1"
    local album="$2"
    
    # Create album directory
    local album_dir="../audio/$(echo "$album" | sed 's/[^a-zA-Z0-9 ]//g; s/ /_/g')"
    mkdir -p "$album_dir"
    
    # Generate clean filename
    local base_name=$(basename "$input_file" .md)
    local clean_name=$(echo "$base_name" | sed 's/[^a-zA-Z0-9]/_/g')
    
    echo "$album_dir/$clean_name.mp3"
}

# MAIN PIPELINE - simplified error handling
main() {
    local input_file="$1"
    local artist="$DEFAULT_ARTIST"
    local album="$DEFAULT_ALBUM"
    local dry_run="false"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --artist) artist="$2"; shift 2 ;;
            --album) album="$2"; shift 2 ;;
            --dry-run) dry_run="true"; shift ;;
            --help) show_usage; exit 0 ;;
            -*) echo "Unknown option: $1"; show_usage; exit 1 ;;
            *) input_file="$1"; shift ;;
        esac
    done
    
    # Validate input
    if [ -z "$input_file" ] || [ ! -f "$input_file" ]; then
        log_error "Input file required and must exist"
        show_usage
        exit 1
    fi
    
    # Setup
    ensure_dependencies
    validate_content "$input_file"
    local output_file=$(setup_output "$input_file" "$album")
    local wav_temp="${output_file%.mp3}_temp.wav"
    
    echo "🎵 StoryCode to MP3 Pipeline"
    echo "Input:  $input_file"
    echo "Output: $output_file"
    echo "Artist: $artist"
    echo "Album:  $album"
    echo ""
    
    if [ "$dry_run" = "true" ]; then
        log_info "DRY RUN - would process file"
        exit 0
    fi
    
    # Stage 1: Voice synthesis
    log_info "Stage 1: Voice synthesis"
    if ! ./voice_synthesis_gcloud.sh "$input_file" "$wav_temp"; then
        log_error "Voice synthesis failed"
        exit 1
    fi
    
    # Check if WAV is valid (not empty 3-byte file)
    local wav_size=$(stat -f%z "$wav_temp" 2>/dev/null || stat -c%s "$wav_temp" 2>/dev/null || echo "0")
    if [ "$wav_size" -lt 1000 ]; then
        log_error "Voice synthesis produced empty/invalid file ($wav_size bytes)"
        log_error "This usually means content exceeded TTS limits or contained problematic characters"
        rm -f "$wav_temp"
        exit 1
    fi
    
    # Stage 2: Convert to MP3
    log_info "Stage 2: Converting to tagged MP3"
    if ! python ../audio-pipeline-toolkit/audio_prep_format_n_tags.py \
        --title "$(basename "$input_file" .md | sed 's/_/ /g')" \
        --artist "$artist" \
        --album "$album" \
        --genre "$DEFAULT_GENRE" \
        --date "$(date +%Y)" \
        --bitrate "$DEFAULT_BITRATE" \
        "$wav_temp" "$output_file"; then
        log_error "MP3 conversion failed"
        rm -f "$wav_temp"
        exit 1
    fi
    
    # Cleanup
    rm -f "$wav_temp"
    
    # Success
    local file_size=$(du -h "$output_file" | cut -f1)
    log_success "Audio production complete!"
    log_success "🎧 Final audio: $output_file ($file_size)"
    echo ""
    echo "🚶 Ready for walking meditation!"
}

main "$@"