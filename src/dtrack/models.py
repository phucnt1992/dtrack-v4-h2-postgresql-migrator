from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any


@dataclass(slots=True)
class ColumnSpec:
    name: str
    type_name: str
    nullable: bool = True
    primary_key: bool = False
    length: int | None = None
    precision: int | None = None
    scale: int | None = None
    default: Any = None
    identity: bool = False


@dataclass(slots=True)
class ForeignKeySpec:
    name: str
    column_name: str
    referenced_table: str
    referenced_column: str


@dataclass(slots=True)
class IndexSpec:
    name: str
    columns: list[str] = field(default_factory=list)
    unique: bool = False


@dataclass(slots=True)
class TableSpec:
    name: str
    columns: list[ColumnSpec] = field(default_factory=list)
    primary_keys: list[str] = field(default_factory=list)
    foreign_keys: list[ForeignKeySpec] = field(default_factory=list)
    indexes: list[IndexSpec] = field(default_factory=list)


@dataclass(slots=True)
class SchemaSnapshot:
    tables: list[TableSpec] = field(default_factory=list)
    source_name: str = "h2"


@dataclass(slots=True)
class MigrationOptions:
    h2_jdbc_url: str
    h2_user: str = "sa"
    h2_password: str = ""
    h2_driver_path: str | None = None
    postgres_url: str | None = None
    schema_name: str | None = None
    include_table: list[str] | None = None
    exclude_table: list[str] | None = None
    batch_size: int = 1000
    dry_run: bool = False
    continue_on_error: bool = False
    output_json_report: str | None = None


@dataclass(slots=True)
class RowTransformIssue:
    table_name: str
    row_number: int
    message: str
    exception: str | None = None


@dataclass(slots=True)
class TableLoadReport:
    table_name: str
    rows_read: int = 0
    rows_inserted: int = 0
    issues: list[RowTransformIssue] = field(default_factory=list)


@dataclass(slots=True)
class MigrationReport:
    success: bool
    tables: list[TableLoadReport] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
