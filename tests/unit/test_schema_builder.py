from sqlalchemy import inspect
from sqlalchemy.engine import create_engine

from dtrack.models import ColumnSpec, MigrationOptions, SchemaSnapshot, TableSpec
from dtrack.postgres.schema import create_schema


def test_create_schema_creates_sqlalchemy_tables() -> None:
    engine = create_engine("sqlite:///:memory:")
    snapshot = SchemaSnapshot(
        tables=[
            TableSpec(
                name="users",
                columns=[
                    ColumnSpec(name="id", type_name="INTEGER", primary_key=True),
                    ColumnSpec(name="name", type_name="VARCHAR", length=100),
                ],
            )
        ]
    )
    options = MigrationOptions(h2_jdbc_url="jdbc:h2:mem:test")

    create_schema(engine, snapshot, options)

    inspector = inspect(engine)
    assert inspector.get_table_names() == ["users"]
