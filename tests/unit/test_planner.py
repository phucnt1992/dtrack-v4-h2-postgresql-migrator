import pytest

from dtrack.models import ForeignKeySpec, SchemaSnapshot, TableSpec
from dtrack.migration.planner import plan_tables


def test_plan_tables_orders_parents_before_children() -> None:
    snapshot = SchemaSnapshot(
        tables=[
            TableSpec(name="child", foreign_keys=[ForeignKeySpec(name="fk", column_name="parent_id", referenced_table="parent", referenced_column="id")]),
            TableSpec(name="parent"),
        ]
    )

    ordered = plan_tables(snapshot)

    assert [table.name for table in ordered] == ["parent", "child"]


def test_plan_tables_raises_for_cycles() -> None:
    snapshot = SchemaSnapshot(
        tables=[
            TableSpec(name="a", foreign_keys=[ForeignKeySpec(name="fk1", column_name="b_id", referenced_table="b", referenced_column="id")]),
            TableSpec(name="b", foreign_keys=[ForeignKeySpec(name="fk2", column_name="a_id", referenced_table="a", referenced_column="id")]),
        ]
    )

    with pytest.raises(ValueError, match="Cycle detected"):
        plan_tables(snapshot)
