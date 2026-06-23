from __future__ import annotations

from sqlalchemy import Column, ForeignKeyConstraint, MetaData, Table, Text
from sqlalchemy.engine import Engine
from sqlalchemy.sql import text

from dtrack.migration.planner import plan_tables
from dtrack.models import ColumnSpec, MigrationOptions, SchemaSnapshot, TableSpec


def create_schema(engine: Engine, snapshot: SchemaSnapshot, options: MigrationOptions) -> None:
    if options.dry_run:
        return

    metadata = build_metadata(snapshot, options.schema_name)
    with engine.begin() as connection:
        if options.schema_name:
            connection.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{options.schema_name}"'))
        metadata.create_all(connection, checkfirst=True)


def build_metadata(snapshot: SchemaSnapshot, schema_name: str | None = None) -> MetaData:
    metadata = MetaData(schema=schema_name)
    ordered_tables = plan_tables(snapshot)
    for table in ordered_tables:
        _build_table(metadata, table, schema_name)
    return metadata


def _build_table(metadata: MetaData, table_spec: TableSpec, schema_name: str | None) -> None:
    columns = [
        Column(
            column.name,
            _map_column_type(column),
            primary_key=column.primary_key,
            nullable=column.nullable,
            default=column.default,
        )
        for column in table_spec.columns
    ]
    table = Table(table_spec.name, metadata, *columns, schema=schema_name)
    if table_spec.foreign_keys:
        table.append_constraint(
            ForeignKeyConstraint(
                [fk.column_name for fk in table_spec.foreign_keys],
                [f"{fk.referenced_table}.{fk.referenced_column}" for fk in table_spec.foreign_keys],
            )
        )


def _map_column_type(column: ColumnSpec):
    normalized = "".join(character for character in column.type_name.upper() if character.isalnum())
    if normalized in {"BOOLEAN", "BOOL", "BIT"}:
        from sqlalchemy import Boolean

        return Boolean()
    if normalized in {"INTEGER", "INT", "INT4"}:
        from sqlalchemy import Integer

        return Integer()
    if normalized in {"BIGINT", "BIGINT"}:
        from sqlalchemy import BigInteger

        return BigInteger()
    if normalized in {"DECIMAL", "NUMERIC"}:
        from sqlalchemy import Numeric

        return Numeric(column.precision or 10, column.scale or 0)
    if normalized in {"DOUBLE", "FLOAT", "REAL"}:
        from sqlalchemy import Float

        return Float()
    if normalized in {"VARCHAR", "CHAR", "CHARACTER", "NVARCHAR", "NCHAR"}:
        from sqlalchemy import String

        return String(length=column.length or 255)
    if normalized in {"CLOB", "TEXT", "LONGVARCHAR"}:
        return Text()
    if normalized in {"BINARY", "VARBINARY", "BLOB"}:
        from sqlalchemy import LargeBinary

        return LargeBinary()
    if normalized in {"DATE"}:
        from sqlalchemy import Date

        return Date()
    if normalized in {"TIME"}:
        from sqlalchemy import Time

        return Time()
    if normalized in {"TIMESTAMP", "DATETIME"}:
        from sqlalchemy import DateTime

        return DateTime()
    from sqlalchemy import String

    return String(length=column.length or 255)
