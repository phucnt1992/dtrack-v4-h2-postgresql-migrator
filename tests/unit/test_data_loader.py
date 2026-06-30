from __future__ import annotations

from typing import Any, cast

from sqlalchemy import Column, Integer, Table

from dtrack.conversion import build_default_registry
from dtrack.models import MigrationOptions
from dtrack.postgres import data_loader


class _FakeReader:
    def count_rows(self, table_name: str) -> int:
        assert table_name == "sample"
        return 3

    def read_rows(self, table_name: str, batch_size: int = 1000):
        assert table_name == "sample"
        yield {"id": "1"}
        yield {"id": "2"}
        yield {"id": "3"}


class _FakeTransaction:
    def __enter__(self) -> object:
        return object()

    def __exit__(self, exc_type: Any, exc: Any, tb: Any) -> None:
        return None


class _FakeEngine:
    def begin(self) -> _FakeTransaction:
        return _FakeTransaction()


def test_load_data_logs_total_rows_progress_and_elapsed(caplog, monkeypatch) -> None:
    def fake_reflect(self, bind, schema=None) -> None:  # noqa: ANN001
        Table("sample", self, Column("id", Integer), schema=schema)

    monkeypatch.setattr(data_loader.MetaData, "reflect", fake_reflect)
    monkeypatch.setattr(data_loader, "_insert_batch", lambda connection, table, batch: None)
    caplog.set_level("INFO")

    options = MigrationOptions(
        h2_jdbc_url="jdbc:h2:mem:test",
        postgres_url="postgresql://test",
        batch_size=2,
    )
    report = data_loader.load_data(
        cast(Any, _FakeEngine()),
        options,
        reader=cast(Any, _FakeReader()),
        registry=build_default_registry(),
    )

    assert report.success is True
    assert any("Total rows in table sample: 3" in rec.message for rec in caplog.records)
    assert any("Progress sample: 100.00% (3/3)" in rec.message for rec in caplog.records)
    assert any("Finished loading table sample" in rec.message and "elapsed" in rec.message for rec in caplog.records)
