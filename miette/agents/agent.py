import os
import sys

class MietteAgent:
    def __init__(self, output_path="data/narrative_output.md"):
        self.output_path = output_path

    def run(self):
        print("Miette agent is running...")
        try:
            transcript = sys.stdin.read()
            
            story = self.weave_story(transcript)

            with open(self.output_path, 'w') as f:
                f.write(story)
            
            print(f"Story successfully written to {self.output_path}")

        except Exception as e:
            print(f"An error occurred: {e}")

    def weave_story(self, transcript):
        return transcript

if __name__ == "__main__":
    agent = MietteAgent()
    agent.run()
