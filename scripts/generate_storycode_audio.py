#!/usr/bin/env python3
"""
StoryCode Audio Generation Script
Converts StoryCode.md narratives to optimized audio using Google Cloud Text-to-Speech
"""

import os
import re
import json
import argparse
from pathlib import Path
from typing import Dict, List, Tuple
from google.cloud import texttospeech
import markdown
from bs4 import BeautifulSoup


class StoryCodeAudioGenerator:
    """Generate audio from StoryCode.md files with speech optimization"""
    
    def __init__(self, project_id: str, credentials_path: str = None):
        """Initialize with Google Cloud project configuration"""
        self.project_id = project_id
        
        # Handle authentication - prefer API key from environment
        if credentials_path and os.path.exists(credentials_path):
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials_path
        elif 'GOOGLE_API_KEY' in os.environ:
            # For API key authentication, we don't need service account credentials
            pass
        
        self.client = texttospeech.TextToSpeechClient()
        self.setup_pronunciation_dict()
        self.setup_voice_config()
    
    def setup_pronunciation_dict(self):
        """Technical term pronunciation mappings"""
        self.pronunciations = {
            # Code Elements
            r'`([^`]+)`': self._format_code_element,
            
            # File Extensions  
            r'\.md\b': ' dot markdown',
            r'\.yaml\b': ' dot yaml',
            r'\.yml\b': ' dot yaml',
            r'\.toml\b': ' dot tom l',
            r'\.json\b': ' dot jason',
            r'\.py\b': ' dot pie',
            r'\.js\b': ' dot jay ess',
            r'\.ts\b': ' dot tee ess',
            
            # Common Acronyms (spell out)
            r'\bAPI\b': 'A P I',
            r'\bCLI\b': 'C L I', 
            r'\bGPU\b': 'G P U',
            r'\bCPU\b': 'C P U',
            r'\bURL\b': 'U R L',
            r'\bHTTP\b': 'H T T P',
            r'\bSSL\b': 'S S L',
            r'\bTLS\b': 'T L S',
            r'\bMCP\b': 'M C P',
            
            # Framework Names
            r'\bA2A\b': 'A two A',
            r'\bADK\b': 'A D K',
            r'\bYAML\b': 'yam l',
            r'\bJSON\b': 'jay son',
            
            # Command Patterns
            r'--([a-zA-Z-]+)': r'dash dash \1',
            r'-([a-zA-Z])': r'dash \1',
        }
    
    def _format_code_element(self, match) -> str:
        """Format inline code elements for speech"""
        code = match.group(1)
        
        # Common command patterns
        if 'docker compose' in code:
            return code.replace('--', 'dash dash ')
        elif code.startswith('./') or code.startswith('../'):
            return code.replace('./', 'dot slash ').replace('../', 'dot dot slash ')
        elif '/' in code and not ' ' in code:
            # File paths
            return code.replace('/', ' slash ')
        else:
            # Generic code - add slight pause
            return f" {code} "
    
    def setup_voice_config(self):
        """Configure optimal voice settings for technical narratives"""
        self.voice_configs = {
            'default': texttospeech.VoiceSelectionParams(
                language_code="en-US",
                name="en-US-Journey-F",
                ssml_gender=texttospeech.SsmlVoiceGender.FEMALE
            ),
            'technical': texttospeech.VoiceSelectionParams(
                language_code="en-US", 
                name="en-US-Neural2-A",
                ssml_gender=texttospeech.SsmlVoiceGender.MALE
            )
        }
        
        self.audio_config = texttospeech.AudioConfig(
            audio_encoding=texttospeech.AudioEncoding.MP3,
            speaking_rate=0.9,  # Slightly slower for technical content
            pitch=0.0,
            volume_gain_db=0.0
        )
    
    def extract_text_from_markdown(self, md_content: str) -> str:
        """Extract and clean text from markdown for speech synthesis"""
        # Convert markdown to HTML
        html = markdown.markdown(md_content)
        
        # Parse HTML and extract text
        soup = BeautifulSoup(html, 'html.parser')
        
        # Remove code blocks (will be handled separately)
        for code_block in soup.find_all('pre'):
            code_block.decompose()
        
        text = soup.get_text()
        
        # Clean up extra whitespace
        text = re.sub(r'\n\s*\n', '\n\n', text)
        text = re.sub(r' +', ' ', text)
        
        return text.strip()
    
    def optimize_text_for_speech(self, text: str) -> str:
        """Apply speech optimization patterns"""
        optimized = text
        
        # Apply pronunciation dictionary
        for pattern, replacement in self.pronunciations.items():
            if callable(replacement):
                optimized = re.sub(pattern, replacement, optimized)
            else:
                optimized = re.sub(pattern, replacement, optimized, flags=re.IGNORECASE)
        
        # Add natural pause markers
        optimized = self._add_pause_markers(optimized)
        
        return optimized
    
    def _add_pause_markers(self, text: str) -> str:
        """Add natural pause points for better speech flow"""
        # Add pauses after section headers
        text = re.sub(r'^(#{1,6}[^\n]+)', r'\1...', text, flags=re.MULTILINE)
        
        # Add pauses around em-dashes
        text = re.sub(r'—', '... ', text)
        
        # Add pauses after colons in explanatory context
        text = re.sub(r'([^:]):([^:])', r'\1:...\2', text)
        
        return text
    
    def create_ssml(self, text: str, voice_type: str = 'default') -> str:
        """Wrap optimized text in SSML for enhanced speech synthesis"""
        
        # Split into paragraphs for better pacing
        paragraphs = text.split('\n\n')
        
        ssml_parts = ['<speak>']
        
        for para in paragraphs:
            if not para.strip():
                continue
                
            para = para.strip()
            
            # Check if this is a header (starts with #)
            if para.startswith('#'):
                # Extract header text and level
                header_match = re.match(r'^(#{1,6})\s*(.+)', para)
                if header_match:
                    level = len(header_match.group(1))
                    header_text = header_match.group(2).replace('...', '')
                    
                    if level <= 2:
                        ssml_parts.append(f'<p><emphasis level="strong">{header_text}</emphasis></p>')
                        ssml_parts.append('<break time="1s"/>')
                    else:
                        ssml_parts.append(f'<p><emphasis level="moderate">{header_text}</emphasis></p>')
                        ssml_parts.append('<break time="0.5s"/>')
                    continue
            
            # Regular paragraph
            # Replace pause markers with SSML breaks
            para_ssml = para.replace('...', '<break time="0.5s"/>')
            ssml_parts.append(f'<p>{para_ssml}</p>')
        
        ssml_parts.append('</speak>')
        
        return '\n'.join(ssml_parts)
    
    def synthesize_audio(self, text: str, output_path: str, voice_type: str = 'default') -> bool:
        """Generate audio file from text using Google Cloud TTS"""
        try:
            # Optimize text for speech
            optimized_text = self.optimize_text_for_speech(text)
            
            # Create SSML
            ssml_content = self.create_ssml(optimized_text, voice_type)
            
            # Prepare synthesis request
            synthesis_input = texttospeech.SynthesisInput(ssml=ssml_content)
            
            # Synthesize speech
            response = self.client.synthesize_speech(
                input=synthesis_input,
                voice=self.voice_configs[voice_type],
                audio_config=self.audio_config
            )
            
            # Save audio file
            with open(output_path, "wb") as out:
                out.write(response.audio_content)
                
            print(f"Audio content written to {output_path}")
            return True
            
        except Exception as e:
            print(f"Error synthesizing audio: {e}")
            return False
    
    def split_into_chapters(self, md_content: str) -> List[Tuple[str, str]]:
        """Split StoryCode.md into chapters for segmented audio"""
        chapters = []
        
        # Split by main headers (# or ##)
        chapter_pattern = r'^(#{1,2}\s+.+?)(?=^#{1,2}\s|\Z)'
        matches = re.finditer(chapter_pattern, md_content, re.MULTILINE | re.DOTALL)
        
        for i, match in enumerate(matches):
            chapter_content = match.group(1).strip()
            
            # Extract chapter title
            title_match = re.match(r'^#{1,2}\s+(.+)', chapter_content)
            title = title_match.group(1) if title_match else f"Chapter {i+1}"
            
            # Clean title for filename
            clean_title = re.sub(r'[^\w\s-]', '', title).strip()
            clean_title = re.sub(r'[-\s]+', '_', clean_title)
            
            chapters.append((clean_title, chapter_content))
        
        return chapters
    
    def process_storycode_file(self, input_path: str, output_dir: str, 
                              create_chapters: bool = True) -> List[str]:
        """Process a StoryCode.md file to generate audio outputs"""
        
        input_file = Path(input_path)
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        # Read the markdown file
        with open(input_file, 'r', encoding='utf-8') as f:
            md_content = f.read()
        
        # Extract plain text for speech
        text_content = self.extract_text_from_markdown(md_content)
        
        generated_files = []
        
        # Generate full audio file
        full_output = output_path / f"StoryCode_{input_file.stem}.mp3"
        if self.synthesize_audio(text_content, str(full_output)):
            generated_files.append(str(full_output))
        
        # Generate chapter segments if requested
        if create_chapters:
            chapters = self.split_into_chapters(md_content)
            
            for chapter_name, chapter_content in chapters:
                chapter_text = self.extract_text_from_markdown(chapter_content)
                chapter_output = output_path / f"StoryCode_{input_file.stem}_{chapter_name}.mp3"
                
                if self.synthesize_audio(chapter_text, str(chapter_output)):
                    generated_files.append(str(chapter_output))
        
        return generated_files


def main():
    """Command-line interface for StoryCode audio generation"""
    parser = argparse.ArgumentParser(description='Generate audio from StoryCode.md files')
    parser.add_argument('input', help='Path to StoryCode.md file')
    parser.add_argument('--output-dir', '-o', default='./audio', 
                       help='Output directory for audio files')
    parser.add_argument('--project-id', required=True,
                       help='Google Cloud project ID')
    parser.add_argument('--credentials', 
                       help='Path to Google Cloud credentials JSON file')
    parser.add_argument('--chapters', action='store_true', default=True,
                       help='Generate separate audio files for each chapter')
    parser.add_argument('--voice', choices=['default', 'technical'], 
                       default='default', help='Voice type to use')
    
    args = parser.parse_args()
    
    # Create audio generator
    generator = StoryCodeAudioGenerator(
        project_id=args.project_id,
        credentials_path=args.credentials
    )
    
    # Process the file
    try:
        generated_files = generator.process_storycode_file(
            input_path=args.input,
            output_dir=args.output_dir,
            create_chapters=args.chapters
        )
        
        print(f"\nGenerated {len(generated_files)} audio files:")
        for file_path in generated_files:
            print(f"  - {file_path}")
            
    except Exception as e:
        print(f"Error processing file: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())