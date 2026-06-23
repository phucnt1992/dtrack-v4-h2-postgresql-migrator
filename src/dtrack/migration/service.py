from __future__ import annotations

from dtrack.config import H2ConnectionSettings, PostgresConnectionSettings
from dtrack.conversion import TypeConversionRegistry, build_default_registry
from dtrack.h2.jdbc import H2SourceReader
from dtrack.models import MigrationOptions, MigrationReport, SchemaSnapshot
from dtrack.postgres.data_loader import load_data
from dtrack.postgres.engine import create_engine_from_settings
from dtrack.postgres.schema import create_schema
from dtrack.reporting import write_report


class MigrationService:
    def __init__(self, reader_class: type[H2SourceReader] | None = None, registry: TypeConversionRegistry | None = None) -> None:
        self.reader_class = reader_class or H2SourceReader
        self.registry = registry or build_default_registry()

    def inspect(self, options: MigrationOptions) -> SchemaSnapshot:
        reader = self.reader_class(self._build_h2_settings(options))
        snapshot = reader.inspect_schema()
        return snapshot

    def create_schema(self, options: MigrationOptions, snapshot: SchemaSnapshot | None = None) -> MigrationReport:
        snapshot = snapshot or self.inspect(options)
        engine = create_engine_from_settings(self._build_postgres_settings(options))
        create_schema(engine, snapshot, options)
        return MigrationReport(success=True, warnings=["Schema creation complete"])

    def load_data(self, options: MigrationOptions, snapshot: SchemaSnapshot | None = None) -> MigrationReport:
        snapshot = snapshot or self.inspect(options)
        engine = create_engine_from_settings(self._build_postgres_settings(options))
        reader = self.reader_class(self._build_h2_settings(options))
        return load_data(engine, snapshot, options, reader=reader, registry=self.registry)

    def migrate(self, options: MigrationOptions) -> tuple[SchemaSnapshot, MigrationReport]:
        snapshot = self.inspect(options)
        schema_report = self.create_schema(options, snapshot=snapshot)
        data_report = self.load_data(options, snapshot=snapshot)
        report = MigrationReport(
            success=schema_report.success and data_report.success,
            tables=data_report.tables,
            warnings=schema_report.warnings + data_report.warnings,
            errors=schema_report.errors + data_report.errors,
        )
        if options.output_json_report:
            write_report(options.output_json_report, report)
        return snapshot, report

    def _build_h2_settings(self, options: MigrationOptions) -> H2ConnectionSettings:
        return H2ConnectionSettings(
            jdbc_url=options.h2_jdbc_url,
            user=options.h2_user,
            password=options.h2_password,
            driver_path=options.h2_driver_path,
        )

    def _build_postgres_settings(self, options: MigrationOptions) -> PostgresConnectionSettings:
        if not options.postgres_url:
            raise ValueError("A PostgreSQL connection string is required")
        return PostgresConnectionSettings(url=options.postgres_url)
