from datetime import date

from dtrack.conversion import build_default_registry


def test_default_registry_converts_boolean_and_date_values() -> None:
    registry = build_default_registry()

    assert registry.convert("true", "BOOLEAN") is True
    assert registry.convert("2024-01-02", "DATE") == date(2024, 1, 2)
