from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from dtrack.config import H2ConnectionSettings

class H2SourceReader:
    def __init__(self, settings: H2ConnectionSettings) -> None:
        self.settings = settings

    def read_rows(self, table_name: str, batch_size: int = 1000) -> Iterator[dict[str, Any]]:
        conn = self._connect()
        try:
            cursor = conn.cursor()
            try:
                cursor.execute(f'SELECT * FROM "{table_name}"')
                while True:
                    batch = cursor.fetchmany(batch_size)
                    if not batch:
                        break
                    for row in batch:
                        yield dict(zip(self._column_names(cursor), row))
            finally:
                cursor.close()
        finally:
            conn.close()

    def _connect(self) -> Any:
        try:
            import jaydebeapi
        except ImportError as exc:  # pragma: no cover - exercised when driver missing
            raise RuntimeError("jaydebeapi and jpype1 are required for H2 access") from exc

        driver_args = [self.settings.user, self.settings.password]
        return jaydebeapi.connect(
            self.settings.driver_class,
            self.settings.jdbc_url,
            driver_args=driver_args,
            jars=self.settings.driver_path,
        )

    @staticmethod
    def _column_names(cursor: Any) -> list[str]:
        return [column[0] for column in cursor.description or []]
