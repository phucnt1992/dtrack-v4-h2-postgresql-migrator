from __future__ import annotations

import os
import shutil
import urllib.request
from pathlib import Path
from typing import Any

from sqlalchemy import inspect, text
from sqlalchemy.engine import Engine

from dtrack.config import H2ConnectionSettings
from dtrack.conversion import TypeConversionRegistry, build_default_registry
from dtrack.h2.jdbc import H2SourceReader
from dtrack.models import MigrationOptions, SchemaSnapshot, TableSpec

H2_DRIVER_PATH = Path(__file__).resolve().parents[1] / "vendors" / "h2.jar"


def ensure_h2_driver_path(cache_dir: Path | None = None) -> Path:
    if H2_DRIVER_PATH.exists():
        return H2_DRIVER_PATH
    target_dir = cache_dir or Path(os.environ.get("PYTEST_CACHE_DIR", ".pytest_cache")) / "h2-drivers"
    target_dir.mkdir(parents=True, exist_ok=True)
    jar_path = target_dir / "h2.jar"
    if not jar_path.exists():
        urllib.request.urlretrieve(
            "https://repo1.maven.org/maven2/com/h2database/h2/2.2.224/h2-2.2.224.jar",
            jar_path,
        )
    return jar_path


def copy_fixture_database(fixture_dir: Path, destination_dir: Path) -> Path:
    destination_dir.mkdir(parents=True, exist_ok=True)
    for fixture_file in fixture_dir.iterdir():
        if fixture_file.is_file():
            shutil.copy2(fixture_file, destination_dir / fixture_file.name)
    return destination_dir / "db"


def build_fixture_jdbc_url(database_path: Path) -> str:
    return f"jdbc:h2:file:{database_path}"


def build_migration_options(
    *,
    h2_jdbc_url: str,
    postgres_url: str,
    schema_name: str,
    h2_driver_path: Path | str,
) -> MigrationOptions:
    return MigrationOptions(
        h2_jdbc_url=h2_jdbc_url,
        postgres_url=postgres_url,
        schema_name=schema_name,
        h2_driver_path=str(h2_driver_path),
    )


def inspect_h2_snapshot(h2_jdbc_url: str, h2_driver_path: Path | str) -> SchemaSnapshot:
    settings = H2ConnectionSettings(
        jdbc_url=h2_jdbc_url,
        driver_path=str(h2_driver_path),
    )
    return H2SourceReader(settings).inspect_schema()


def read_h2_rows(h2_jdbc_url: str, h2_driver_path: Path | str, table_name: str) -> list[dict[str, Any]]:
    settings = H2ConnectionSettings(
        jdbc_url=h2_jdbc_url,
        driver_path=str(h2_driver_path),
    )
    reader = H2SourceReader(settings)
    return list(reader.read_rows(table_name))


def normalize_row(row: dict[str, Any], table_spec: TableSpec, registry: TypeConversionRegistry | None = None) -> dict[str, Any]:
    registry = registry or build_default_registry()
    normalized: dict[str, Any] = {}
    for column in table_spec.columns:
        if column.name in row:
            normalized[column.name] = registry.convert(row[column.name], column.type_name)
    return normalized


def fetch_postgres_rows(
    engine: Engine,
    *,
    table_name: str,
    schema_name: str,
    limit: int | None = None,
    order_by: list[str] | None = None,
) -> list[dict[str, Any]]:
    quoted_table = f'"{table_name.replace("\"", "\"\"")}"'
    quoted_schema = f'"{schema_name.replace("\"", "\"\"")}"'
    query = f'SELECT * FROM {quoted_schema}.{quoted_table}'
    if order_by:
        query += " ORDER BY " + ", ".join(order_by)
    if limit is not None:
        query += f" LIMIT {limit}"
    with engine.connect() as connection:
        result = connection.execute(text(query))
        return [dict(row._mapping) for row in result.mappings().all()]


def count_postgres_rows(engine: Engine, *, table_name: str, schema_name: str) -> int:
    quoted_table = f'"{table_name.replace("\"", "\"\"")}"'
    quoted_schema = f'"{schema_name.replace("\"", "\"\"")}"'
    query = f'SELECT COUNT(*) FROM {quoted_schema}.{quoted_table}'
    with engine.connect() as connection:
        result = connection.execute(text(query))
        return int(result.scalar_one())


def get_postgres_table_names(engine: Engine, schema_name: str) -> list[str]:
    inspector = inspect(engine)
    return inspector.get_table_names(schema=schema_name)


def get_postgres_columns(engine: Engine, table_name: str, schema_name: str) -> list[dict[str, Any]]:
    inspector = inspect(engine)
    return inspector.get_columns(table_name, schema=schema_name)


def get_postgres_primary_key(engine: Engine, table_name: str, schema_name: str) -> list[str]:
    inspector = inspect(engine)
    return inspector.get_pk_constraint(table_name, schema=schema_name).get("constrained_columns", [])


def get_postgres_foreign_keys(engine: Engine, table_name: str, schema_name: str) -> list[dict[str, Any]]:
    inspector = inspect(engine)
    return [
        {
            "constrained_columns": foreign_key.get("constrained_columns", []),
            "referred_table": foreign_key.get("referred_table"),
            "referred_columns": foreign_key.get("referred_columns", []),
        }
        for foreign_key in inspector.get_foreign_keys(table_name, schema=schema_name)
    ]
