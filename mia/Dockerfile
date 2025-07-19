FROM python:3.9-slim

WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy the project files
COPY pyproject.toml .
COPY agents/ ./agents

# Install dependencies
RUN poetry install --only main

# Set the command to run the agent
CMD ["poetry", "run", "python", "-m", "agents.agent"]