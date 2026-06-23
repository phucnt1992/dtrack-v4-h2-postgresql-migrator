from __future__ import annotations

from collections import deque

from dtrack.models import SchemaSnapshot, TableSpec


def plan_tables(snapshot: SchemaSnapshot) -> list[TableSpec]:
    table_names = {table.name for table in snapshot.tables}
    parents: dict[str, set[str]] = {table.name: set() for table in snapshot.tables}
    children: dict[str, set[str]] = {table.name: set() for table in snapshot.tables}

    for table in snapshot.tables:
        for foreign_key in table.foreign_keys:
            if foreign_key.referenced_table in table_names:
                parents[table.name].add(foreign_key.referenced_table)
                children[foreign_key.referenced_table].add(table.name)

    indegree = {name: len(parents[name]) for name in parents}
    pending = deque(sorted(name for name, degree in indegree.items() if degree == 0))
    ordered: list[str] = []

    while pending:
        current = pending.popleft()
        ordered.append(current)
        for child in sorted(children[current]):
            indegree[child] -= 1
            if indegree[child] == 0:
                pending.append(child)

    if len(ordered) != len(snapshot.tables):
        raise ValueError("Cycle detected in foreign key relationships")

    table_map = {table.name: table for table in snapshot.tables}
    return [table_map[name] for name in ordered]
