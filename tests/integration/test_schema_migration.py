from __future__ import annotations

from sqlalchemy import create_engine

from dtrack.migration.service import MigrationService
from tests.integration.helpers import (
    build_migration_options,
    get_postgres_columns,
    get_postgres_foreign_keys,
    get_postgres_primary_key,
    get_postgres_table_names,
    inspect_h2_snapshot,
)


def test_create_schema_matches_h2_fixture(
    fixture_jdbc_url: str,
    postgres_url: str,
    schema_name: str,
    h2_driver_path,
) -> None:
    snapshot = inspect_h2_snapshot(fixture_jdbc_url, h2_driver_path)
    options = build_migration_options(
        h2_jdbc_url=fixture_jdbc_url,
        postgres_url=postgres_url,
        schema_name=schema_name,
        h2_driver_path=h2_driver_path,
    )

    report = MigrationService().create_schema(options, snapshot=snapshot)

    assert report.success
    engine = create_engine(postgres_url, future=True)
    actual_tables = get_postgres_table_names(engine, schema_name)
    expected_tables = [table.name for table in snapshot.tables]
    assert sorted(actual_tables) == sorted(expected_tables)

    for table_spec in snapshot.tables:
        actual_columns = get_postgres_columns(engine, table_spec.name, schema_name)
        expected_columns = [column.name for column in table_spec.columns]
        assert [column["name"] for column in actual_columns] == expected_columns

        expected_nullable = {column.name: column.nullable for column in table_spec.columns}
        actual_nullable = {column["name"]: column["nullable"] for column in actual_columns}
        assert actual_nullable == expected_nullable

        assert get_postgres_primary_key(engine, table_spec.name, schema_name) == table_spec.primary_keys

        expected_foreign_keys = [
            {
                "constrained_columns": [fk.column_name],
                "referred_table": fk.referenced_table,
                "referred_columns": [fk.referenced_column],
            }
            for fk in table_spec.foreign_keys
        ]
        actual_foreign_keys = get_postgres_foreign_keys(engine, table_spec.name, schema_name)
        assert actual_foreign_keys == expected_foreign_keys
