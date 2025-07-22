# Use Python 3.12 slim image as base
FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1

# Install build dependencies for C++ compilation
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN pip install uv
RUN pip install poetry

WORKDIR /app
# Install system dependencies
#COPY pyproject.toml  README.md ./
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system -r pyproject.toml && \
    rm -fr build dist *.egg-info
# Copy application code
#COPY src/ /app/src
#COPY scripts/ /app/scripts
RUN python -m compileall -q .

COPY <<EOF /entrypoint.sh
#!/bin/bash

if test -f /run/secrets/openai-api-key; then
    export OPENAI_API_KEY=$(cat /run/secrets/openai-api-key)
fi

if test -n "${OPENAI_API_KEY}"; then
    echo "Using OpenAI with ${OPENAI_MODEL_NAME}"
else
    echo "Using Docker Model Runner with ${MODEL_RUNNER_MODEL}"
    export OPENAI_BASE_URL=${MODEL_RUNNER_URL}
    export OPENAI_MODEL_NAME=openai/${MODEL_RUNNER_MODEL}
    export OPENAI_API_KEY=cannot_be_empty
fi
exec poetry run audio_weaver
EOF
RUN chmod +x /entrypoint.sh

# Create non-root user
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

ENTRYPOINT [ "/entrypoint.sh" ] 