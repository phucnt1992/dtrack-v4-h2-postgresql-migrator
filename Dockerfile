FROM python:3.14-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN apt update && apt install -y --no-install-recommends \
    default-jdk curl \
    && curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | bash \
    && apt install task \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN task init && task clear-cache
