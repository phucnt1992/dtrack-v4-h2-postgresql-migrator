from __future__ import annotations

from datetime import date, datetime, time
from typing import Any


class TypeConversionRegistry:
    def __init__(self) -> None:
        self._handlers: dict[str, Any] = {}

    def register(self, source_type: str, handler: Any) -> None:
        self._handlers[self._normalize(source_type)] = handler

    def convert(self, value: Any, source_type: str) -> Any:
        if value is None:
            return None
        handler = self._handlers.get(self._normalize(source_type))
        if handler is None:
            return value
        return handler(value)

    @staticmethod
    def _normalize(source_type: str) -> str:
        return "".join(ch for ch in source_type.upper() if ch.isalnum())


def build_default_registry() -> TypeConversionRegistry:
    registry = TypeConversionRegistry()
    registry.register("BOOLEAN", lambda value: bool(value))
    registry.register("BIT", lambda value: bool(value))
    registry.register("INTEGER", lambda value: int(value))
    registry.register("BIGINT", lambda value: int(value))
    registry.register("DECIMAL", lambda value: float(value))
    registry.register("DOUBLE", lambda value: float(value))
    registry.register("FLOAT", lambda value: float(value))
    registry.register("REAL", lambda value: float(value))
    registry.register("VARCHAR", lambda value: str(value))
    registry.register("CHAR", lambda value: str(value))
    registry.register("CHARACTER", lambda value: str(value))
    registry.register("CLOB", lambda value: str(value))
    registry.register("TEXT", lambda value: str(value))
    registry.register("BINARY", lambda value: value if isinstance(value, bytes) else bytes(str(value), "utf-8"))
    registry.register("VARBINARY", lambda value: value if isinstance(value, bytes) else bytes(str(value), "utf-8"))
    registry.register("BLOB", lambda value: value if isinstance(value, bytes) else bytes(str(value), "utf-8"))
    registry.register("DATE", lambda value: value if isinstance(value, date) else date.fromisoformat(str(value)))
    registry.register("TIME", lambda value: value if isinstance(value, time) else time.fromisoformat(str(value)))
    registry.register(
        "TIMESTAMP", lambda value: value if isinstance(value, datetime) else datetime.fromisoformat(str(value))
    )
    return registry
