from datetime import date

from dtrack.conversion import build_default_registry


def test_default_registry_converts_boolean_and_date_values() -> None:
    registry = build_default_registry()

    assert registry.convert("true", "BOOLEAN") is True
    assert registry.convert("2024-01-02", "DATE") == date(2024, 1, 2)


def test_default_registry_converts_memoryview_to_binary_bytes() -> None:
    registry = build_default_registry()

    assert registry.convert(memoryview(b"\x00\x01\x02"), "BLOB") == b"\x00\x01\x02"


def test_default_registry_decodes_utf8_bytes_for_text_types() -> None:
    registry = build_default_registry()

    assert registry.convert(b'{"ok":true}', "TEXT") == '{"ok":true}'
