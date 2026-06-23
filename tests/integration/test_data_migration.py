from __future__ import annotations

from sqlalchemy import create_engine

from dtrack.migration.service import MigrationService
from tests.integration.helpers import (
    build_migration_options,
    count_postgres_rows,
    fetch_postgres_rows,
    inspect_h2_snapshot,
    normalize_row,
    read_h2_rows,
)


def test_load_data_matches_h2_fixture(
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

    service = MigrationService()
    schema_report = service.create_schema(options, snapshot=snapshot)
    data_report = service.load_data(options, snapshot=snapshot)

    assert schema_report.success
    assert data_report.success

    engine = create_engine(postgres_url, future=True)
    for table_spec in snapshot.tables:
        expected_rows = read_h2_rows(fixture_jdbc_url, h2_driver_path, table_spec.name)
        actual_count = count_postgres_rows(engine, table_name=table_spec.name, schema_name=schema_name)
        assert actual_count == len(expected_rows)
        if not expected_rows:
            continue

        sample_size = 25 if len(expected_rows) > 25 else len(expected_rows)
        expected_sample = [normalize_row(row, table_spec) for row in expected_rows[:sample_size]]
        actual_sample = [
            normalize_row(row, table_spec)
            for row in fetch_postgres_rows(engine, table_name=table_spec.name, schema_name=schema_name, limit=sample_size)
        ]
        assert actual_sample == expected_sample
