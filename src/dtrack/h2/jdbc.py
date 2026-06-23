from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from dtrack.config import H2ConnectionSettings
from dtrack.models import ColumnSpec, ForeignKeySpec, SchemaSnapshot, TableSpec


class H2SourceReader:
    def __init__(self, settings: H2ConnectionSettings) -> None:
        self.settings = settings

    def inspect_schema(self) -> SchemaSnapshot:
        try:
            import jaydebeapi  # type: ignore
        except ImportError as exc:  # pragma: no cover - exercised when driver missing
            raise RuntimeError("jaydebeapi and jpype1 are required for H2 access") from exc

        conn = self._connect()
        try:
            cursor = conn.cursor()
            try:
                cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_TYPE = 'TABLE'")
                rows = cursor.fetchall()
                tables: list[TableSpec] = []
                for (table_name,) in rows:
                    tables.append(self._inspect_table(cursor, table_name))
            finally:
                cursor.close()
        finally:
            conn.close()
        return SchemaSnapshot(tables=tables)

    def read_rows(self, table_name: str, batch_size: int = 1000) -> Iterator[dict[str, Any]]:
        try:
            import jaydebeapi  # type: ignore
        except ImportError as exc:  # pragma: no cover - exercised when driver missing
            raise RuntimeError("jaydebeapi and jpype1 are required for H2 access") from exc

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
            import jaydebeapi  # type: ignore
        except ImportError as exc:  # pragma: no cover - exercised when driver missing
            raise RuntimeError("jaydebeapi and jpype1 are required for H2 access") from exc

        driver_args = [self.settings.user, self.settings.password]
        return jaydebeapi.connect(
            self.settings.driver_class,
            self.settings.jdbc_url,
            driver_args=driver_args,
            jars=self.settings.driver_path,
        )

    def _inspect_table(self, cursor: Any, table_name: str) -> TableSpec:
        cursor.execute(
            "SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, ORDINAL_POSITION FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_NAME = ? ORDER BY ORDINAL_POSITION",
            (table_name,),
        )
        columns = []
        for column_name, data_type, is_nullable, column_default, _ in cursor.fetchall():
            columns.append(
                ColumnSpec(
                    name=column_name,
                    type_name=data_type,
                    nullable=is_nullable == "YES",
                    default=column_default,
                )
            )

        cursor.execute(
            "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.PRIMARY_KEYS WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_NAME = ?",
            (table_name,),
        )
        primary_keys = [row[0] for row in cursor.fetchall()]

        cursor.execute(
            "SELECT CONSTRAINT_NAME, COLUMN_LIST, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_LIST FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE TABLE_SCHEMA = 'PUBLIC' AND TABLE_NAME = ?",
            (table_name,),
        )
        foreign_keys = []
        for constraint_name, column_list, referenced_table_name, referenced_column_list in cursor.fetchall():
            columns_list = [name.strip() for name in column_list.split(",")]
            referenced_columns = [name.strip() for name in referenced_column_list.split(",")]
            for column_name, referenced_column in zip(columns_list, referenced_columns, strict=False):
                foreign_keys.append(
                    ForeignKeySpec(
                        name=constraint_name,
                        column_name=column_name,
                        referenced_table=referenced_table_name,
                        referenced_column=referenced_column,
                    )
                )

        return TableSpec(name=table_name, columns=columns, primary_keys=primary_keys, foreign_keys=foreign_keys)

    @staticmethod
    def _column_names(cursor: Any) -> list[str]:
        return [column[0] for column in cursor.description or []]
