FROM python:3.9-slim

WORKDIR /app

COPY pyproject.toml poetry.lock* ./

RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev --no-root

COPY . .

CMD ["poetry", "run", "python", "-m", "agents.agent"]

