from __future__ import annotations

from pathlib import Path

from sqlalchemy import text

from dtrack.config import H2ConnectionSettings, PostgresConnectionSettings
from dtrack.migration.service import MigrationService
from dtrack.postgres.engine import create_engine_from_settings
from tests.integration.helpers import build_migration_options


def test_load_data_preserves_lob_values(
    tmp_path: Path,
    postgres_url: str,
    schema_name: str,
    h2_driver_path: Path,
) -> None:
    h2_db_path = tmp_path / "h2-lob-db"
    h2_jdbc_url = f"jdbc:h2:file:{h2_db_path}"
    h2_settings = H2ConnectionSettings(jdbc_url=h2_jdbc_url, driver_path=str(h2_driver_path))

    reader = MigrationService().reader_class(h2_settings)
    h2_conn = reader._connect()  # noqa: SLF001 - integration setup uses JDBC seam
    try:
        h2_cursor = h2_conn.cursor()
        try:
            h2_cursor.execute('CREATE TABLE "lob_payload" ("id" BIGINT PRIMARY KEY, "payload_text" CLOB, "payload_bin" BLOB)')
            h2_cursor.execute(
                "INSERT INTO \"lob_payload\" (\"id\", \"payload_text\", \"payload_bin\") "
                "VALUES (1, '{\"k\":true}', X'00010203')"
            )
        finally:
            h2_cursor.close()
    finally:
        h2_conn.close()

    engine = create_engine_from_settings(PostgresConnectionSettings(url=postgres_url))
    with engine.begin() as connection:
        connection.execute(text(f'CREATE SCHEMA "{schema_name}"'))
        connection.execute(
            text(
                f'CREATE TABLE "{schema_name}"."lob_payload" ('
                '"id" BIGINT PRIMARY KEY, "payload_text" TEXT, "payload_bin" BYTEA)'
            )
        )

    options = build_migration_options(
        h2_jdbc_url=h2_jdbc_url,
        postgres_url=postgres_url,
        schema_name=schema_name,
        h2_driver_path=h2_driver_path,
    )
    report = MigrationService().load_data(options)
    assert report.success is True

    with engine.connect() as connection:
        row = connection.execute(
            text(
                f'SELECT "payload_text", "payload_bin" FROM "{schema_name}"."lob_payload" '
                'WHERE "id" = 1'
            )
        ).one()
        assert row[0] == '{"k":true}'
        assert bytes(row[1]) == b"\x00\x01\x02\x03"
