from __future__ import annotations

from dtrack.config import H2ConnectionSettings
from dtrack.h2.jdbc import H2SourceReader
from dtrack.models import SchemaSnapshot


def inspect_h2_schema(settings: H2ConnectionSettings) -> SchemaSnapshot:
    return H2SourceReader(settings).inspect_schema()
