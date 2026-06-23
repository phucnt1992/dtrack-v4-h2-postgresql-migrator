# H2 to PostgreSQL Migration CLI Implementation Plan

## Problem

Build a Python CLI that migrates schema and data from an H2 embedded database into PostgreSQL using Typer, SQLAlchemy, and Alembic.

## Current State

- Repository is minimal: `src/main.py` prints a placeholder string.
- No application package, database layer, migration pipeline, or tests exist yet.
- Tooling already exists for `uv`, `ruff`, `ty`, and `pytest`.
- Local Docker Compose already provides PostgreSQL connection defaults for development.

## Clarified Decisions

- H2 access strategy: use a **JDBC bridge from Python** rather than a pure SQLAlchemy H2 dialect.
- CLI shape: provide **phase subcommands** plus one **end-to-end command**.

## Approaches Considered

### 1. JDBC bridge + SQLAlchemy/Alembic orchestration **(recommended)**

- Use a Java-backed H2 client from Python only for source reads.
- Use SQLAlchemy models/metadata plus Alembic to create or validate PostgreSQL schema.
- Run data copy through Python transformation and batching services.

**Why recommend it**

- Matches requested stack without depending on weak H2 support in Python SQLAlchemy.
- Keeps PostgreSQL write path fully native to SQLAlchemy.
- Makes type conversion, dry-run, filtering, and testing easier.

### 2. Export H2 to intermediate files, then import into PostgreSQL

- Extract schema/data to JSON or CSV first, then replay into PostgreSQL.

**Trade-offs**

- Easier to debug step-by-step.
- Adds storage and serialization overhead.
- Makes large-database runs slower and schema fidelity harder.

### 3. Shell out to Java migration utilities and wrap them with Typer

- Typer acts mostly as process orchestration around external Java tools.

**Trade-offs**

- Fastest path to raw H2 compatibility.
- Weakest Python-side control, validation, and testability.
- Harder to keep behavior aligned with SQLAlchemy/Alembic requirements.

## Recommended Design

### Architecture

Split the CLI into five focused layers:

1. **CLI layer** in `src/dtrack/cli.py` exposes `inspect`, `schema`, `data`, and `migrate`.
2. **Source inspection layer** in `src/dtrack/h2/` uses JDBC to read tables, columns, constraints, indexes, and rows from H2.
3. **Migration planning layer** in `src/dtrack/migration/` converts extracted H2 metadata into an internal schema model plus an ordered execution plan.
4. **Target execution layer** in `src/dtrack/postgres/` uses SQLAlchemy engines/sessions and Alembic bootstrap helpers to create schema and insert rows.
5. **Conversion/reporting layer** in `src/dtrack/conversion/` and `src/dtrack/reporting.py` handles type mapping, row-level warnings, progress, and summaries.

### Command Model

- `inspect`: connect to H2 and print/export discovered schema summary.
- `schema`: create or validate PostgreSQL schema from discovered H2 metadata.
- `data`: copy data only, assuming schema already exists.
- `migrate`: run inspect -> schema -> data in sequence.

Common options:

- `--h2-jdbc-url`, `--h2-user`, `--h2-password`
- `--postgres-url` or `--postgres-host/port/db/user/password`
- `--schema-name`
- `--include-table`, `--exclude-table`
- `--batch-size`
- `--dry-run`
- `--stop-on-error/--continue-on-error`
- `--output-json-report`

### H2 Connectivity

- Use a Python JDBC bridge such as `jaydebeapi` with `jpype1`.
- Load H2 JDBC driver JAR from a configurable path or environment variable.
- Keep JDBC-specific code isolated behind `H2SourceReader` so the rest of the system consumes plain Python dataclasses.

### Internal Data Model

Create typed dataclasses for:

- `ColumnSpec`
- `TableSpec`
- `ForeignKeySpec`
- `IndexSpec`
- `SchemaSnapshot`
- `MigrationOptions`
- `MigrationReport`
- `RowTransformIssue`

This lets the CLI, schema builder, and data migrator share a single contract without leaking JDBC result shapes.

### Schema Recreation

- Prefer generating SQLAlchemy `Table` objects dynamically from the extracted snapshot.
- Use those tables to create PostgreSQL schema in dependency order.
- Use Alembic for bootstrap/version tracking and for any repository-owned baseline migration needed before or after copied schema creation.
- Keep schema creation idempotent enough to support `inspect` followed by `schema` retries.

### Data Migration Flow

1. Read tables in dependency order.
2. Disable or defer foreign key checks where safe, otherwise insert parent-first.
3. Stream rows in configurable batches from H2.
4. Convert row values via a dedicated conversion registry.
5. Bulk insert into PostgreSQL with SQLAlchemy Core.
6. Record counts, warnings, and failures in the final report.

### Type Conversion Strategy

Plan explicit mappings for likely H2/PostgreSQL differences:

- `BOOLEAN` / bit-like fields
- `INTEGER`, `BIGINT`, `DECIMAL`, `DOUBLE`
- `VARCHAR`, `CLOB`, long text
- `BINARY`, `VARBINARY`, `BLOB`
- `DATE`, `TIME`, `TIMESTAMP`
- H2 identity/auto-increment metadata -> PostgreSQL identity/sequence handling

Implement conversions through a registry keyed by source type so custom overrides can be added without changing migrator flow.

### Error Handling and Reporting

- Fail fast on connection/schema-planning errors.
- For row-level conversion errors, support either stop-immediately or continue-with-report depending on CLI flag.
- Emit a human-readable summary plus optional JSON report with per-table counts and failure details.
- Use standard logging for progress and warnings.

### Testing Strategy

- Unit tests for metadata normalization, dependency ordering, and type conversion.
- CLI tests for option parsing and command dispatch.
- Integration tests with PostgreSQL testcontainers plus fixture snapshots/mocks for H2 metadata reader.
- If real H2 integration is added later, isolate it behind optional integration tests requiring the JDBC driver artifact.

## Planned File Structure

### New source files

- `src/dtrack/__init__.py`
- `src/dtrack/__main__.py`
- `src/dtrack/cli.py`
- `src/dtrack/config.py`
- `src/dtrack/logging.py`
- `src/dtrack/models.py`
- `src/dtrack/h2/__init__.py`
- `src/dtrack/h2/jdbc.py`
- `src/dtrack/h2/introspection.py`
- `src/dtrack/postgres/__init__.py`
- `src/dtrack/postgres/engine.py`
- `src/dtrack/postgres/schema.py`
- `src/dtrack/postgres/data_loader.py`
- `src/dtrack/conversion.py`
- `src/dtrack/migration/__init__.py`
- `src/dtrack/migration/planner.py`
- `src/dtrack/migration/service.py`
- `src/dtrack/reporting.py`

### New test files

- `tests/unit/test_cli.py`
- `tests/unit/test_conversion.py`
- `tests/unit/test_planner.py`
- `tests/unit/test_schema_builder.py`
- `tests/integration/test_migrate_command.py`

### Existing files to modify

- `src/main.py` to delegate to Typer app entrypoint.
- `pyproject.toml` to add runtime dependencies and optional dev/test configuration.
- `Taskfile.yaml` to add `run` and possibly `db:migrate` tasks if desired for local workflow.
- `README.md` to document CLI setup, H2 JDBC driver requirement, and example commands.

## Execution Phases

### Phase 1: Project scaffolding

- Add runtime deps: `typer`, `sqlalchemy`, `alembic`, `psycopg[binary]`, JDBC bridge package, logging/report helpers if needed.
- Create package layout under `src/dtrack/`.
- Replace placeholder entrypoint with Typer app bootstrap.

### Phase 2: Configuration and connection layer

- Add typed settings objects for H2 and PostgreSQL connection details.
- Implement PostgreSQL engine/session factory.
- Implement JDBC bootstrap and validation for H2.

### Phase 3: H2 schema/data extraction

- Implement metadata queries/readers for tables, columns, indexes, and foreign keys.
- Implement row streaming reader with batching.
- Normalize raw results into dataclasses.

### Phase 4: Schema planning and creation

- Convert snapshot into SQLAlchemy `MetaData`/`Table` objects.
- Determine dependency order and schema creation workflow.
- Wire optional Alembic baseline/version handling.

### Phase 5: Data conversion and loading

- Implement type conversion registry.
- Implement batch insert pipeline and transaction boundaries.
- Support continue-on-error vs stop-on-error behavior.

### Phase 6: CLI commands and reporting

- Add `inspect`, `schema`, `data`, and `migrate` commands.
- Add terminal summaries and JSON report output.
- Document examples and operational caveats.

### Phase 7: Test coverage

- Add unit tests first for conversion/planning logic.
- Add CLI tests.
- Add PostgreSQL integration test for end-to-end migration against controlled fixtures/mocks.

## Risks and Mitigations

- **Python H2 support is weak** -> isolate JDBC bridge behind thin adapter and keep fallback path open.
- **Schema fidelity gaps** -> start with supported core types/constraints and log unsupported constructs explicitly.
- **Foreign key cycles or load ordering issues** -> detect cycles early and use deferred constraints or staged inserts.
- **Large datasets** -> stream reads and batch writes; avoid loading full tables into memory.
- **Sequence/identity drift** -> reset PostgreSQL sequences after data load.

## Suggested Initial Todo Order

1. Scaffold package, dependencies, and Typer entrypoint.
2. Add config models and connection factories.
3. Build H2 metadata snapshot reader.
4. Build schema planner and PostgreSQL schema creator.
5. Build conversion registry and batch data loader.
6. Wire CLI commands and reporting.
7. Add unit/integration tests.
8. Update README and task aliases.

