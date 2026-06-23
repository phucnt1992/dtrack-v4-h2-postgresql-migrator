from __future__ import annotations

from dataclasses import dataclass


@dataclass(slots=True)
class H2ConnectionSettings:
    jdbc_url: str
    user: str = "sa"
    password: str = ""
    driver_path: str | None = None
    driver_class: str = "org.h2.Driver"


@dataclass(slots=True)
class PostgresConnectionSettings:
    url: str
