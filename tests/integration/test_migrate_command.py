from __future__ import annotations

from typer.testing import CliRunner

from dtrack.cli import app
from tests.integration.helpers import count_postgres_rows, inspect_h2_snapshot, read_h2_rows


def test_migrate_command_runs_full_flow(
    fixture_jdbc_url: str,
    postgres_url: str,
    schema_name: str,
    h2_driver_path,
) -> None:
    snapshot = inspect_h2_snapshot(fixture_jdbc_url, h2_driver_path)

    runner = CliRunner()
    result = runner.invoke(
        app,
        [
            "migrate",
            "--h2-jdbc-url",
            fixture_jdbc_url,
            "--postgres-url",
            postgres_url,
            "--schema-name",
            schema_name,
            "--h2-driver-path",
            str(h2_driver_path),
        ],
    )

    assert result.exit_code == 0, result.stdout
    assert "Found" in result.stdout
    assert "Migration completed" in result.stdout

    from sqlalchemy import create_engine

    engine = create_engine(postgres_url, future=True)
    for table_spec in snapshot.tables:
        expected_rows = read_h2_rows(fixture_jdbc_url, h2_driver_path, table_spec.name)
        actual_count = count_postgres_rows(engine, table_name=table_spec.name, schema_name=schema_name)
        assert actual_count == len(expected_rows)
