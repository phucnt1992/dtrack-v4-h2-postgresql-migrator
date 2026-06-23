from __future__ import annotations

from sqlalchemy import create_engine
from sqlalchemy.engine import Engine

from dtrack.config import PostgresConnectionSettings


def create_engine_from_settings(settings: PostgresConnectionSettings) -> Engine:
    url = settings.url
    if url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+psycopg://", 1)
    elif url.startswith("postgresql+psycopg2://"):
        url = url.replace("postgresql+psycopg2://", "postgresql+psycopg://", 1)
    return create_engine(url, future=True)
