from __future__ import annotations

from dtrack.config import H2ConnectionSettings
from dtrack.h2.jdbc import H2SourceReader


class FakeJdbcClob:
    def __init__(self, value: str) -> None:
        self.value = value
        self.freed = False

    def length(self) -> int:
        return len(self.value)

    def getSubString(self, start: int, length: int) -> str:  # noqa: N802 - mirrors JDBC API
        offset = max(start - 1, 0)
        return self.value[offset : offset + length]

    def free(self) -> None:
        self.freed = True


class FakeJdbcBlob:
    def __init__(self, value: bytes) -> None:
        self.value = value
        self.freed = False

    def length(self) -> int:
        return len(self.value)

    def getBytes(self, start: int, length: int) -> bytes:  # noqa: N802 - mirrors JDBC API
        offset = max(start - 1, 0)
        return self.value[offset : offset + length]

    def free(self) -> None:
        self.freed = True


def _reader() -> H2SourceReader:
    return H2SourceReader(H2ConnectionSettings(jdbc_url="jdbc:h2:mem:test"))


def test_normalize_value_extracts_text_from_jdbc_clob() -> None:
    reader = _reader()
    clob = FakeJdbcClob('{"kind":"policy"}')

    assert reader._normalize_value(clob) == '{"kind":"policy"}'  # noqa: SLF001 - unit test of normalization seam
    assert clob.freed is True


def test_normalize_value_extracts_bytes_from_jdbc_blob() -> None:
    reader = _reader()
    blob = FakeJdbcBlob(b"\x10\x20\x30")

    assert reader._normalize_value(blob) == b"\x10\x20\x30"  # noqa: SLF001 - unit test of normalization seam
    assert blob.freed is True


def test_count_rows_queries_table_count(monkeypatch) -> None:
    class FakeCursor:
        def execute(self, query: str) -> None:
            assert query == 'SELECT COUNT(*) FROM "EVENTS"'

        def fetchone(self) -> tuple[int]:
            return (42,)

        def close(self) -> None:
            return None

    class FakeConnection:
        def cursor(self) -> FakeCursor:
            return FakeCursor()

        def close(self) -> None:
            return None

    reader = _reader()
    monkeypatch.setattr(reader, "_connect", lambda: FakeConnection())  # noqa: SLF001 - mocking JDBC seam

    assert reader.count_rows("EVENTS") == 42
