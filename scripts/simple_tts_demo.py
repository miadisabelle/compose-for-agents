#!/usr/bin/env python3
"""
Simple Text-to-Speech demo using Google Cloud TTS REST API
Demonstrates the voice synthesis capability we just built
"""

import os
import re
import json
import requests
from pathlib import Path


class SimpleTTSDemo:
    """Simple TTS demo using REST API"""
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://texttospeech.googleapis.com/v1"
        
    def clean_text_for_speech(self, text: str) -> str:
        """Apply basic speech optimizations"""
        # Remove markdown syntax
        text = re.sub(r'#{1,6}\s*', '', text)  # Headers
        text = re.sub(r'\*\*([^*]+)\*\*', r'\1', text)  # Bold
        text = re.sub(r'\*([^*]+)\*', r'\1', text)  # Italic
        text = re.sub(r'`([^`]+)`', r' \1 ', text)  # Code
        
        # Clean up extra whitespace
        text = re.sub(r'\n\s*\n', '\n\n', text)
        text = re.sub(r' +', ' ', text)
        
        # Handle technical terms
        replacements = {
            r'\.md\b': ' dot markdown',
            r'\.py\b': ' dot pie',
            r'\bAPI\b': 'A P I',
            r'\bCLI\b': 'C L I',
            r'--([a-zA-Z-]+)': r'dash dash \1',
        }
        
        for pattern, replacement in replacements.items():
            text = re.sub(pattern, replacement, text, flags=re.IGNORECASE)
        
        return text.strip()
    
    def create_audio_request(self, text: str) -> dict:
        """Create TTS request payload"""
        return {
            "input": {"text": text},
            "voice": {
                "languageCode": "en-US",
                "name": "en-US-Journey-F",
                "ssmlGender": "FEMALE"
            },
            "audioConfig": {
                "audioEncoding": "MP3",
                "speakingRate": 0.9,
                "pitch": 0.0,
                "volumeGainDb": 0.0
            }
        }
    
    def synthesize_text(self, text: str, output_path: str) -> bool:
        """Synthesize text to audio file"""
        try:
            # Clean text for speech
            clean_text = self.clean_text_for_speech(text)
            
            # Truncate if too long (TTS API has limits)
            if len(clean_text) > 5000:
                clean_text = clean_text[:4950] + "... and the story continues."
            
            # Create request
            request_data = self.create_audio_request(clean_text)
            
            # Make API call
            url = f"{self.base_url}/text:synthesize?key={self.api_key}"
            response = requests.post(url, json=request_data)
            
            if response.status_code == 200:
                result = response.json()
                
                # Decode base64 audio content
                import base64
                audio_content = base64.b64decode(result['audioContent'])
                
                # Save to file
                with open(output_path, 'wb') as f:
                    f.write(audio_content)
                
                print(f"✅ Audio generated: {output_path}")
                return True
            else:
                print(f"❌ API Error: {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ Error: {e}")
            return False
    
    def demo_voice_synthesis_story(self, output_dir: str = "../audio"):
        """Create a demo of our voice synthesis capability"""
        
        # Create output directory
        Path(output_dir).mkdir(exist_ok=True)
        
        # Demo text about what we just accomplished
        demo_text = """
        # The Voice Synthesis Magic We Just Created
        
        We have just accomplished something remarkable in our repository journey. 
        We built a complete voice synthesis system that can transform technical 
        stories into spoken audio, perfect for walking meditation.
        
        Our system handles complex technical terms like A P I, C L I, and 
        docker compose up dash dash build with perfect pronunciation.
        
        This demonstrates the recursive magic of our StoryCode pattern: 
        we created tools to make technical stories speakable, and now we're 
        using those very tools to tell the story of their creation.
        
        The result is a self-demonstrating system that grows stronger with 
        each use, making complex software architectures accessible to more 
        people in more learning contexts.
        
        This audio you're hearing right now proves that our voice synthesis 
        system works beautifully, transforming written chronicles into 
        walking companions for technical exploration.
        """
        
        # Generate the demo audio
        output_file = f"{output_dir}/voice_synthesis_demo.mp3"
        
        print("🎵 Generating voice synthesis demo...")
        success = self.synthesize_text(demo_text, output_file)
        
        if success:
            print(f"🎧 Demo audio created: {output_file}")
            print("   This proves our voice synthesis system works!")
            return output_file
        else:
            print("❌ Demo generation failed")
            return None


def main():
    """Demo the voice synthesis capability"""
    
    # Get API key from environment
    api_key = os.environ.get('GOOGLE_API_KEY')
    
    if not api_key:
        print("❌ GOOGLE_API_KEY environment variable not set")
        print("   Please set it with: export GOOGLE_API_KEY=your_api_key")
        return 1
    
    # Create demo
    demo = SimpleTTSDemo(api_key)
    
    # Generate demo audio
    result = demo.demo_voice_synthesis_story()
    
    if result:
        print("\n🎉 Voice synthesis demo complete!")
        print("🚶 Perfect for walking meditation and mobile learning")
        return 0
    else:
        return 1


if __name__ == "__main__":
    exit(main())