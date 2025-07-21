#!/usr/bin/env python
import logging
import os
import sys
from typing import Any

import yaml

from audio_weaver.crew import AudioWeaverCrew


def run() -> None:
    """
    Run the crew.
    """
    crew = AudioWeaverCrew()
    crew.crew().kickoff()
