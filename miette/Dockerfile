FROM python:3.9-slim

WORKDIR /app

RUN pip install poetry

COPY pyproject.toml .
COPY agents/ ./agents

RUN poetry install --only main

CMD ["poetry", "run", "python", "-m", "agents.agent"]
