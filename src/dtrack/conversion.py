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
    registry.register("VARCHAR", _to_text)
    registry.register("CHAR", _to_text)
    registry.register("CHARACTER", _to_text)
    registry.register("CLOB", _to_text)
    registry.register("TEXT", _to_text)
    registry.register("BINARY", _to_binary)
    registry.register("VARBINARY", _to_binary)
    registry.register("BLOB", _to_binary)
    registry.register("DATE", lambda value: value if isinstance(value, date) else date.fromisoformat(str(value)))
    registry.register("TIME", lambda value: value if isinstance(value, time) else time.fromisoformat(str(value)))
    registry.register(
        "TIMESTAMP", lambda value: value if isinstance(value, datetime) else datetime.fromisoformat(str(value))
    )
    return registry


def _to_text(value: Any) -> str:
    if isinstance(value, str):
        return value
    if isinstance(value, (bytes, bytearray, memoryview)):
        return bytes(value).decode("utf-8")
    return str(value)


def _to_binary(value: Any) -> bytes:
    if isinstance(value, bytes):
        return value
    if isinstance(value, (bytearray, memoryview)):
        return bytes(value)
    if isinstance(value, str):
        return value.encode("utf-8")
    raise TypeError(f"Unsupported binary value type: {type(value).__name__}")
