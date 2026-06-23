from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from sqlalchemy.engine import Engine

from dtrack.conversion import TypeConversionRegistry, build_default_registry
from dtrack.models import MigrationOptions, MigrationReport, RowTransformIssue, SchemaSnapshot, TableLoadReport
from dtrack.migration.planner import plan_tables
from dtrack.postgres.schema import build_metadata
from dtrack.h2.jdbc import H2SourceReader


def load_data(engine: Engine, snapshot: SchemaSnapshot, options: MigrationOptions, reader: H2SourceReader | None = None, registry: TypeConversionRegistry | None = None) -> MigrationReport:
    if options.dry_run:
        return MigrationReport(success=True, warnings=["Dry run requested; no rows loaded"])

    registry = registry or build_default_registry()
    metadata = build_metadata(snapshot, options.schema_name)
    ordered_tables = plan_tables(snapshot)
    reports: list[TableLoadReport] = []
    errors: list[str] = []

    for table_spec in ordered_tables:
        table_report = TableLoadReport(table_name=table_spec.name)
        if reader is None:
            continue
        try:
            rows: Iterator[dict[str, Any]] = reader.read_rows(table_spec.name, batch_size=options.batch_size)
            table = _resolve_table(metadata, table_spec.name, options.schema_name)
            with engine.begin() as connection:
                batch: list[dict[str, Any]] = []
                for row in rows:
                    table_report.rows_read += 1
                    converted_row = _convert_row(row, table_spec, registry)
                    batch.append(converted_row)
                    if len(batch) >= options.batch_size:
                        connection.execute(table.insert(), batch)
                        table_report.rows_inserted += len(batch)
                        batch = []
                if batch:
                    connection.execute(table.insert(), batch)
                    table_report.rows_inserted += len(batch)
        except Exception as exc:  # pragma: no cover - relies on runtime behavior
            table_report.issues.append(RowTransformIssue(table_name=table_spec.name, row_number=table_report.rows_read, message=str(exc)))
            errors.append(f"Failed to load table {table_spec.name}: {exc}")
            if not options.continue_on_error:
                raise
        reports.append(table_report)

    return MigrationReport(success=not errors, tables=reports, errors=errors)


def _convert_row(row: dict[str, Any], table_spec: Any, registry: TypeConversionRegistry) -> dict[str, Any]:
    converted: dict[str, Any] = {}
    for column in table_spec.columns:
        if column.name in row:
            converted[column.name] = registry.convert(row[column.name], column.type_name)
    return converted


def _resolve_table(metadata: Any, table_name: str, schema_name: str | None) -> Any:
    if schema_name:
        schema_key = f"{schema_name}.{table_name}"
        return metadata.tables[schema_key]
    return metadata.tables[table_name]
