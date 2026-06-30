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
                columns = self._column_names(cursor)
                while True:
                    batch = cursor.fetchmany(batch_size)
                    if not batch:
                        break
                    for row in batch:
                        normalized_row = [self._normalize_value(value) for value in row]
                        yield dict(zip(columns, normalized_row))
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

    def count_rows(self, table_name: str) -> int:
        conn = self._connect()
        try:
            cursor = conn.cursor()
            try:
                cursor.execute(f'SELECT COUNT(*) FROM "{table_name}"')
                row = cursor.fetchone()
                return int(row[0]) if row else 0
            finally:
                cursor.close()
        finally:
            conn.close()

    @staticmethod
    def _column_names(cursor: Any) -> list[str]:
        return [column[0] for column in cursor.description or []]

    def _normalize_value(self, value: Any) -> Any:
        if value is None:
            return None
        if self._is_jdbc_clob(value):
            text = value.getSubString(1, int(value.length()))
            self._free_lob(value)
            return str(text)
        if self._is_jdbc_blob(value):
            raw_bytes = value.getBytes(1, int(value.length()))
            self._free_lob(value)
            return bytes(raw_bytes)
        return value

    @staticmethod
    def _is_jdbc_clob(value: Any) -> bool:
        class_name = value.__class__.__name__.lower()
        return "clob" in class_name and hasattr(value, "getSubString") and hasattr(value, "length")

    @staticmethod
    def _is_jdbc_blob(value: Any) -> bool:
        class_name = value.__class__.__name__.lower()
        return "blob" in class_name and hasattr(value, "getBytes") and hasattr(value, "length")

    @staticmethod
    def _free_lob(value: Any) -> None:
        free_method = getattr(value, "free", None)
        if callable(free_method):
            free_method()
