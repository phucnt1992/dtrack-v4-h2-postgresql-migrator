from __future__ import annotations

import logging
import time
from collections.abc import Iterator
from typing import Any

from sqlalchemy import MetaData, Table
from sqlalchemy.engine import Engine
from sqlalchemy.dialects.postgresql import insert as pg_insert

from dtrack.conversion import TypeConversionRegistry, build_default_registry
from dtrack.models import MigrationOptions, MigrationReport, RowTransformIssue, TableLoadReport
from dtrack.h2.jdbc import H2SourceReader

logger = logging.getLogger(__name__)

def load_data(
    engine: Engine,
    options: MigrationOptions,
    reader: H2SourceReader | None = None,
    registry: TypeConversionRegistry | None = None,
) -> MigrationReport:
    if options.dry_run:
        logger.info("Dry run requested; no rows loaded")
        return MigrationReport(success=True, warnings=["Dry run requested; no rows loaded"])

    registry = registry or build_default_registry()

    logger.info(f"Reflecting schema {options.schema_name or 'public'} from PostgreSQL...")
    metadata = MetaData()
    metadata.reflect(bind=engine, schema=options.schema_name)
    logger.info(f"Found {len(metadata.sorted_tables)} tables in target schema.")

    reports: list[TableLoadReport] = []
    errors: list[str] = []
    load_started = time.perf_counter()
    table_totals: dict[str, int | None] = {}
    overall_total_rows = 0
    overall_rows_read = 0

    for table in metadata.sorted_tables:
        h2_table_name = table.name

        if options.exclude_table and h2_table_name in options.exclude_table:
            logger.debug(f"Skipping table {h2_table_name} (excluded via options)")
            continue
        if options.include_table and h2_table_name not in options.include_table:
            logger.debug(f"Skipping table {h2_table_name} (not in included tables)")
            continue

        logger.info(f"Loading table {h2_table_name}...")
        table_report = TableLoadReport(table_name=h2_table_name)
        if reader is None:
            logger.warning("No H2 reader provided, skipping row loads")
            continue

        try:
            table_started = time.perf_counter()
            total_rows = _count_rows(reader, h2_table_name)
            table_totals[h2_table_name] = total_rows
            if total_rows is not None:
                overall_total_rows += total_rows
                logger.info(f"Total rows in table {h2_table_name}: {total_rows}")
            rows: Iterator[dict[str, Any]] = reader.read_rows(h2_table_name, batch_size=options.batch_size)
            with engine.begin() as connection:
                batch: list[dict[str, Any]] = []
                for row in rows:
                    table_report.rows_read += 1
                    overall_rows_read += 1
                    converted_row = _convert_row(row, table, registry)
                    batch.append(converted_row)
                    if len(batch) >= options.batch_size:
                        _log_progress(h2_table_name, table_report.rows_read, total_rows)
                        _insert_batch(connection, table, batch)
                        logger.debug(f"Inserted batch of {len(batch)} rows into {h2_table_name}")
                        table_report.rows_inserted += len(batch)
                        batch = []

                if batch:
                    _log_progress(h2_table_name, table_report.rows_read, total_rows)
                    _insert_batch(connection, table, batch)
                    logger.debug(f"Inserted final batch of {len(batch)} rows into {h2_table_name}")
                    table_report.rows_inserted += len(batch)

            table_elapsed = time.perf_counter() - table_started
            logger.info(
                f"Finished loading table {h2_table_name}. Read: {table_report.rows_read}, "
                f"Inserted (or UPSERTed): {table_report.rows_inserted}, elapsed: {table_elapsed:.2f}s"
            )
        except Exception as exc:  # pragma: no cover - relies on runtime behavior
            logger.error(f"Error loading table {h2_table_name}: {exc}")
            table_report.issues.append(
                RowTransformIssue(table_name=h2_table_name, row_number=table_report.rows_read, message=str(exc))
            )
            errors.append(f"Failed to load table {h2_table_name}: {exc}")
            if not options.continue_on_error:
                raise
        reports.append(table_report)

    if errors:
        logger.warning(f"Data load completed with {len(errors)} errors.")
    else:
        logger.info("Data load completed successfully.")
    load_elapsed = time.perf_counter() - load_started
    if table_totals and all(total is not None for total in table_totals.values()):
        logger.info(
            f"Overall load progress: 100.00% ({overall_rows_read}/{overall_total_rows}) in {load_elapsed:.2f}s"
        )
    else:
        logger.info(f"Overall load progress: {overall_rows_read} rows processed in {load_elapsed:.2f}s")

    return MigrationReport(success=not errors, tables=reports, errors=errors)


def _log_progress(h2_table_name: str, rows_read: int, total_rows: int | None) -> None:
    if total_rows and total_rows > 0:
        table_progress = (rows_read / total_rows) * 100
        logger.info(
            f"Progress {h2_table_name}: {table_progress:.2f}% ({rows_read}/{total_rows})"
        )
    else:
        logger.info(f"Progress {h2_table_name}: {rows_read} rows processed")


def _insert_batch(connection: Any, table: Table, batch: list[dict[str, Any]]) -> None:
    stmt = pg_insert(table).values(batch)
    stmt = stmt.on_conflict_do_nothing()
    connection.execute(stmt)


def _convert_row(row: dict[str, Any], table: Table, registry: TypeConversionRegistry) -> dict[str, Any]:
    converted: dict[str, Any] = {}
    for column in table.columns:
        if column.name in row:
            type_name = column.type.__class__.__name__.upper()
            converted[column.name] = registry.convert(row[column.name], type_name)
    return converted


def _count_rows(reader: H2SourceReader, table_name: str) -> int | None:
    count_rows = getattr(reader, "count_rows", None)
    if not callable(count_rows):
        return None
    try:
        return int(count_rows(table_name))
    except Exception as exc:  # pragma: no cover - runtime-specific JDBC behavior
        logger.warning(f"Failed to count rows for table {table_name}: {exc}")
        return None
