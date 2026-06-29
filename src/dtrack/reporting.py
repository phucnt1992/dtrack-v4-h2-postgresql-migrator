from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from dtrack.models import MigrationReport


def serialize_report(report: MigrationReport) -> dict[str, Any]:
    return {
        "success": report.success,
        "tables": [
            {
                "table_name": table.table_name,
                "rows_read": table.rows_read,
                "rows_inserted": table.rows_inserted,
                "issues": [issue.__dict__ for issue in table.issues],
            }
            for table in report.tables
        ],
        "warnings": report.warnings,
        "errors": report.errors,
    }


def write_report(path: str | None, report: MigrationReport) -> None:
    if not path:
        return
    Path(path).write_text(json.dumps(serialize_report(report), indent=2), encoding="utf-8")
