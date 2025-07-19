#!/bin/bash

# This script runs the Miette agent, piping input from stdin to the container.

# Get the absolute path to the script's directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# The content to be passed to the agent
CONTENT=$(cat)

# Run the docker container
echo "$CONTENT" | docker run --rm -i \
  -v "$SCRIPT_DIR/data":/app/data \
  --name miette_story_generator \
  miette-miette
