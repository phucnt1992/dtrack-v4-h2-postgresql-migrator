from __future__ import annotations

from typing import Generator
import uuid
from pathlib import Path

import pytest
from testcontainers.postgres import PostgresContainer

from tests.integration.helpers import (
    build_fixture_jdbc_url,
    copy_fixture_database,
    ensure_h2_driver_path
)


@pytest.fixture(scope="session")
def postgres_container() -> Generator[PostgresContainer, None, None]:
    with PostgresContainer("postgres:16-alpine") as container:
        container.start()
        yield container


@pytest.fixture()
def postgres_url(postgres_container: PostgresContainer) -> str:
    return postgres_container.get_connection_url().replace("postgresql+psycopg2://", "postgresql+psycopg://", 1)


@pytest.fixture()
def schema_name() -> str:
    return f"test_{uuid.uuid4().hex[:12]}"


@pytest.fixture()
def h2_driver_path() -> Path:
    return ensure_h2_driver_path()


@pytest.fixture()
def fixture_jdbc_url(tmp_path: Path, h2_driver_path: Path) -> str:
    fixture_dir = Path(__file__).parent / "fixtures"
    copied_dir = tmp_path / "fixtures"
    copy_fixture_database(fixture_dir, copied_dir)
    return build_fixture_jdbc_url(copied_dir / "db")
