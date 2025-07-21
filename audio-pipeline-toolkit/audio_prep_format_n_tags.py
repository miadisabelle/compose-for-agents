#!/usr/bin/env python3
"""
Audio Processing Script for StoryCode to MP3 Pipeline
Converts audio files to MP3 format with embedded metadata tags.

Usage:
    python audio_prep_format_n_tags.py input.wav output.mp3 --title "Title" --artist "Artist"
"""

import argparse
import os
import sys
from pathlib import Path

try:
    from mutagen.easyid3 import EasyID3
    from mutagen.id3 import ID3, ID3NoHeaderError
    from mutagen.mp3 import MP3
    from pydub import AudioSegment
from pydub.utils import get_prober_name, get_converter_name

# Explicitly set ffmpeg and ffprobe paths
AudioSegment.converter = get_converter_name("ffmpeg")
AudioSegment.prober = get_prober_name("ffprobe")
except ImportError as e:
    print(f"Error: Required audio library not found: {e}")
    print("Install with: pip install mutagen pydub")
    sys.exit(1)

def convert_to_mp3(input_file, output_file, bitrate='320k'):
    """Convert audio file to MP3 with error handling"""
    try:
        # Validate input file
        if not os.path.exists(input_file):
            raise FileNotFoundError(f"Input file not found: {input_file}")
        
        # Check file size
        file_size = os.path.getsize(input_file)
        if file_size < 1000:
            raise ValueError(f"Input file too small ({file_size} bytes). Likely corrupted or empty.")
        
        # Convert audio
        audio = AudioSegment.from_file(input_file)
        
        # Validate audio content
        if len(audio) < 100:  # Less than 0.1 seconds
            raise ValueError(f"Audio content too short ({len(audio)}ms). Check input file.")
        
        # Export with optimized settings for voice content
        audio.export(
            output_file, 
            format="mp3", 
            bitrate=bitrate,
            parameters=["-ac", "1"]  # Force mono for voice content
        )
        
        # Validate output
        if not os.path.exists(output_file) or os.path.getsize(output_file) < 1000:
            raise RuntimeError("MP3 conversion failed - output file missing or too small")
            
    except Exception as e:
        print(f"Error converting audio: {e}")
        raise

def embed_tags(mp3_file, tags):
    """Embed ID3 tags into MP3 file with validation"""
    try:
        # Validate MP3 file exists
        if not os.path.exists(mp3_file):
            raise FileNotFoundError(f"MP3 file not found: {mp3_file}")
        
        # Load or create ID3 tags
        try:
            audio = EasyID3(mp3_file)
        except ID3NoHeaderError:
            audio = MP3(mp3_file, ID3=ID3)
            audio.add_tags()
            audio = EasyID3(mp3_file)
        
        # Validate and clean tag values
        valid_tags = {}
        for key, value in tags.items():
            if value and str(value).strip():
                # Clean the tag value
                clean_value = str(value).strip()
                # Limit tag length to prevent issues
                if len(clean_value) > 200:
                    clean_value = clean_value[:200] + "..."
                valid_tags[key] = clean_value
        
        # Apply tags
        for key, value in valid_tags.items():
            audio[key] = value
        
        # Save with error handling
        audio.save(mp3_file)
        
        # Verify tags were saved
        verify = EasyID3(mp3_file)
        saved_tags = {k: v[0] if v else None for k, v in verify.items()}
        
        return saved_tags
        
    except Exception as e:
        print(f"Error embedding tags: {e}")
        raise

def main():
    parser = argparse.ArgumentParser(
        description='Convert audio to MP3 and embed ID3 tags for StoryCode pipeline.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s input.wav output.mp3 --title "My Story" --artist "Mia & Miette"
  %(prog)s audio.wav --save --album "Chronicles Vol I"
        """
    )
    parser.add_argument('input_file', help='Input audio file (WAV or other formats)')
    parser.add_argument('output_file', nargs='?', help='Output MP3 file (required unless --save used)', default=None)
    parser.add_argument('--save', action='store_true', help='Modify input file in-place (input must be MP3)')
    parser.add_argument('--title', help='Title tag')
    parser.add_argument('--artist', help='Artist tag')
    parser.add_argument('--album', help='Album tag') 
    parser.add_argument('--genre', help='Genre tag')
    parser.add_argument('--date', help='Date tag (year)')
    parser.add_argument('--bitrate', default='320k', help='MP3 bitrate (default: 320k)')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    
    args = parser.parse_args()
    
    # Validate arguments
    if not args.save and not args.output_file:
        parser.error("Output file required unless --save is used")
    
    if not os.path.exists(args.input_file):
        parser.error(f"Input file not found: {args.input_file}")

    try:
        input_ext = os.path.splitext(args.input_file)[1].lower()
        output_file = args.input_file if args.save else args.output_file
        output_ext = os.path.splitext(output_file)[1].lower()

        # Validate output format
        if output_ext != '.mp3':
            print("Error: Output file must have .mp3 extension")
            sys.exit(1)
        
        # Create output directory if needed
        output_dir = os.path.dirname(output_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        if args.verbose:
            print(f"Processing: {args.input_file} -> {output_file}")
        
        # Convert or copy audio file
        if input_ext != '.mp3':
            if args.verbose:
                print(f"Converting {input_ext} to MP3...")
            convert_to_mp3(args.input_file, output_file, args.bitrate)
        elif not args.save:
            if args.verbose:
                print("Copying MP3 file...")
            from shutil import copyfile
            copyfile(args.input_file, output_file)
        
        # Embed tags if provided
        tags = {k: v for k, v in vars(args).items() 
                if k in ['title', 'artist', 'album', 'genre', 'date'] and v}
        
        if tags:
            if args.verbose:
                print(f"Embedding tags: {tags}")
            saved_tags = embed_tags(output_file, tags)
            print(f"Tags have been embedded into '{output_file}'.")
            if args.verbose:
                print(f"Saved tags: {saved_tags}")
        else:
            print("No tags provided to embed.")
        
        # Final validation
        if os.path.exists(output_file):
            file_size = os.path.getsize(output_file)
            if args.verbose:
                print(f"Output file size: {file_size} bytes")
            if file_size < 1000:
                print("Warning: Output file unusually small, may be corrupted")
                sys.exit(1)
        else:
            print("Error: Output file was not created")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()