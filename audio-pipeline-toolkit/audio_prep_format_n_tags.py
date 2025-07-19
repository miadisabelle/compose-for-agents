import argparse
import os
from mutagen.easyid3 import EasyID3
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.mp3 import MP3
from pydub import AudioSegment

def convert_to_mp3(input_file, output_file, bitrate='320k'):
    audio = AudioSegment.from_file(input_file)
    audio.export(output_file, format="mp3", bitrate=bitrate)

def embed_tags(mp3_file, tags):
    try:
        audio = EasyID3(mp3_file)
    except ID3NoHeaderError:
        audio = MP3(mp3_file, ID3=ID3)
        audio.add_tags()
        audio = EasyID3(mp3_file)
    for key, value in tags.items():
        audio[key] = str(value)
    audio.save(mp3_file)

def main():
    parser = argparse.ArgumentParser(description='Convert audio to mp3 and embed ID3 tags.')
    parser.add_argument('input_file', help='Input audio file (wav or other formats)')
    parser.add_argument('output_file', nargs='?', help='Output MP3 file (optional, defaults to input file name)', default=None)
    parser.add_argument('--save', action='store_true', help='Tag the input file and save it back with the same filename')
    parser.add_argument('--title', help='Title tag')
    parser.add_argument('--artist', help='Artist tag')
    parser.add_argument('--album', help='Album tag')
    parser.add_argument('--genre', help='Genre tag')
    parser.add_argument('--date', help='Date tag')
    parser.add_argument('--bitrate', default='320k', help='Bitrate for MP3 conversion (default: 320k)')
    args = parser.parse_args()

    input_ext = os.path.splitext(args.input_file)[1].lower()
    output_file = args.input_file if args.save else args.output_file
    output_ext = os.path.splitext(output_file)[1].lower()

    if output_ext != '.mp3':
        print("Desired output format is MP3. Please provide an output file with '.mp3' extension.")
        exit(1)

    if input_ext != '.mp3':
        convert_to_mp3(args.input_file, output_file, args.bitrate)
    elif not args.save:
        from shutil import copyfile
        copyfile(args.input_file, output_file)

    tags = {k: v for k, v in vars(args).items() if k in ['title', 'artist', 'album', 'genre', 'date'] and v}
    if tags:
        embed_tags(output_file, tags)
        print(f"Tags have been embedded into '{output_file}'.")
    else:
        print("No tags provided.")

if __name__ == '__main__':
    main()