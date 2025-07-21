FROM python:3.9-slim

WORKDIR /app

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg     && rm -rf /var/lib/apt/lists/*ENV FFMPEG_PATH="/usr/bin/ffmpeg"ENV FFPROBE_PATH="/usr/bin/ffprobe"

RUN pip install poetry

COPY pyproject.toml .
COPY agents/ ./agents

RUN poetry install --only main
RUN pip install mutagen pydub
RUN python -c "import mutagen, pydub; print('Mutagen and Pydub are installed!')"
RUN echo "PATH: $PATH"

CMD ["poetry", "run", "python", "-m", "agents.agent"]
