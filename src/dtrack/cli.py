from __future__ import annotations

from typing import Annotated

import typer

from dtrack.logging import configure_logging
from dtrack.models import MigrationOptions
from dtrack.migration.service import MigrationService
from dtrack.reporting import write_report

app = typer.Typer(add_completion=False, no_args_is_help=True)


@app.command()
def data(
    h2_jdbc_url: Annotated[str, typer.Option("--h2-jdbc-url")],
    postgres_url: Annotated[str, typer.Option("--postgres-url")] = "",
    schema_name: Annotated[str | None, typer.Option("--schema-name")] = None,
    h2_driver_path: Annotated[str | None, typer.Option("--h2-driver-path")] = None,
    include_table: Annotated[list[str] | None, typer.Option("--include-table")] = None,
    exclude_table: Annotated[list[str] | None, typer.Option("--exclude-table")] = None,
    batch_size: Annotated[int, typer.Option("--batch-size")] = 1000,
    dry_run: Annotated[bool, typer.Option("--dry-run")] = False,
    continue_on_error: Annotated[bool, typer.Option("--continue-on-error")] = False,
    output_json_report: Annotated[str | None, typer.Option("--output-json-report")] = None,
) -> None:
    configure_logging()
    options = _build_options(
        h2_jdbc_url=h2_jdbc_url,
        postgres_url=postgres_url,
        schema_name=schema_name,
        h2_driver_path=h2_driver_path,
        include_table=include_table,
        exclude_table=exclude_table,
        batch_size=batch_size,
        dry_run=dry_run,
        continue_on_error=continue_on_error,
        output_json_report=output_json_report,
    )
    report = MigrationService().load_data(options)
    typer.echo("Data load completed")
    if output_json_report:
        write_report(output_json_report, report)


def _build_options(
    *,
    h2_jdbc_url: str,
    postgres_url: str,
    schema_name: str | None,
    h2_driver_path: str | None,
    include_table: list[str] | None,
    exclude_table: list[str] | None,
    batch_size: int,
    dry_run: bool = False,
    continue_on_error: bool = False,
    output_json_report: str | None = None,
) -> MigrationOptions:
    return MigrationOptions(
        h2_jdbc_url=h2_jdbc_url,
        postgres_url=postgres_url,
        schema_name=schema_name,
        h2_driver_path=h2_driver_path,
        include_table=include_table,
        exclude_table=exclude_table,
        batch_size=batch_size,
        dry_run=dry_run,
        continue_on_error=continue_on_error,
        output_json_report=output_json_report,
    )


def main() -> None:
    app()
