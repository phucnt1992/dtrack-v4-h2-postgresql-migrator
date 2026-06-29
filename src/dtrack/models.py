from __future__ import annotations

from dataclasses import dataclass, field


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
