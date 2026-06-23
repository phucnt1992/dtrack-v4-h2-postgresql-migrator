# DTrack Migration CLI

This repository now includes a Python-based CLI for migrating schema and data from H2 into PostgreSQL.

## Quick start

Install dependencies with `uv sync` and run the CLI via:

```bash
uv run python -m dtrack --help
```

## Available commands

- `inspect` – connect to H2 and print a schema summary
- `schema` – create or validate PostgreSQL schema from discovered H2 metadata
- `data` – copy data rows into PostgreSQL
- `migrate` – run the full inspect → schema → data workflow

Example:

```bash
uv run dtrack inspect --h2-jdbc-url jdbc:h2:./mydb --postgres-url postgresql+psycopg://dtrack:dtrack@localhost:5432/dtrack
```

Both commands accept only connection strings for their database targets.

## Notes

- H2 access uses a JDBC bridge via `jaydebeapi` and requires the H2 JDBC driver JAR plus `jpype1`.
- PostgreSQL connections use SQLAlchemy and `psycopg`.
- The implementation currently focuses on core schema planning, type conversion, and batch data loading with optional JSON reporting.

## Testing

Integration tests use the fixture database under `tests/integration/fixtures/` and run against a real PostgreSQL testcontainer. They download a pinned H2 JDBC JAR automatically into `.pytest_cache/h2-drivers/` on first use, then copy the fixture files into a temporary directory so the repo fixtures stay read-only.

Run the integration suite directly with:

```bash
uv run pytest tests/integration -v
```

