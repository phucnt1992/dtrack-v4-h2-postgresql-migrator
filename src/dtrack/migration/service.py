from __future__ import annotations

from dtrack.config import H2ConnectionSettings, PostgresConnectionSettings
from dtrack.conversion import TypeConversionRegistry, build_default_registry
from dtrack.h2.jdbc import H2SourceReader
from dtrack.models import MigrationOptions, MigrationReport
from dtrack.postgres.data_loader import load_data
from dtrack.postgres.engine import create_engine_from_settings


class MigrationService:
    def __init__(
        self, reader_class: type[H2SourceReader] | None = None, registry: TypeConversionRegistry | None = None
    ) -> None:
        self.reader_class = reader_class or H2SourceReader
        self.registry = registry or build_default_registry()

    def load_data(self, options: MigrationOptions) -> MigrationReport:
        engine = create_engine_from_settings(self._build_postgres_settings(options))
        reader = self.reader_class(self._build_h2_settings(options))
        return load_data(engine, options, reader=reader, registry=self.registry)

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
