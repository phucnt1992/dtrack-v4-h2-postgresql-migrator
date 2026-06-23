# H2 Fixture to PostgreSQL Integration Test Plan

**Problem**

Add real integration coverage proving the committed H2 fixture database in `tests/integration/fixtures/` can be migrated into PostgreSQL running in `testcontainers`, with separate coverage for schema creation, data loading, and the full `migrate` CLI path.

**Current state**

- `tests/integration/` has no Python tests yet; only fixture files exist.
- `MigrationService` already exposes `inspect()`, `create_schema()`, `load_data()`, and `migrate()`.
- `H2SourceReader` can read real H2 databases through JDBC, but the repo does not include an H2 JDBC JAR.
- `pyproject.toml` already includes `pytest` and `testcontainers[postgresql]`.
- CLI commands currently do **not** expose `h2_driver_path`, which blocks a real end-to-end CLI test unless the JVM classpath is preconfigured outside the repo.

**Recommended approach**

Use real fixture-driven integration tests with a shared pytest harness:

1. Download or cache a pinned H2 JDBC JAR during test setup so the test suite is self-contained.
2. Copy fixture database files into a temp directory before each test to keep repo fixtures read-only.
3. Reuse one PostgreSQL testcontainer per test session, but isolate each test with a unique PostgreSQL schema name.
4. Compare PostgreSQL results against expectations derived from the H2 snapshot/rows at runtime instead of hardcoding table names from the fixture.
5. Add the missing `--h2-driver-path` CLI option so the full `migrate` command can be exercised with the same real fixture.

**Alternatives considered**

- **Service-only tests**: simpler, but leaves the CLI path unverified and misses the current `h2_driver_path` gap.
- **Synthetic in-test H2 database generation**: easier to control, but does not prove the committed fixture files migrate successfully.
- **One fresh Postgres container per test**: strong isolation, but slower than a shared container with unique schemas.

## Planned file map

### New test files

- `tests/integration/conftest.py` — shared fixtures for driver download, fixture copying, PostgreSQL container lifecycle, schema naming, and options construction.
- `tests/integration/helpers.py` — reusable helpers for building fixture JDBC URLs, reading H2 snapshots/rows, and comparing PostgreSQL state with H2-derived expectations.
- `tests/integration/test_schema_migration.py` — schema-only parity test.
- `tests/integration/test_data_migration.py` — data-only parity test.
- `tests/integration/test_migrate_command.py` — end-to-end CLI migration test with real fixture and testcontainer PostgreSQL.

### Existing files to modify

- `src/dtrack/cli.py` — add `--h2-driver-path` support to `inspect`, `schema`, `data`, and `migrate`, and thread it into `_build_options()`.
- `tests/unit/test_cli.py` — extend command coverage for the new CLI option.
- `README.md` — document how fixture-backed integration tests obtain the H2 driver and how to run them locally.

## Implementation tasks

### Task 1: Build reusable integration harness

**Files**

- Create: `tests/integration/conftest.py`
- Create: `tests/integration/helpers.py`

**Goal**

Create stable, reusable test fixtures so every integration test uses the same self-contained H2 driver provisioning, copied fixture database, session-scoped PostgreSQL container, and per-test schema isolation.

**Steps**

- [ ] Add a pinned H2 driver downloader in `tests/integration/helpers.py` that stores the JAR under pytest-managed cache or temp storage and returns a `Path`.
- [ ] Add a helper that copies every file from `tests/integration/fixtures/` into a per-test temp directory and returns the base JDBC path for the copied H2 database.
- [ ] Add a helper that constructs `MigrationOptions` with `h2_jdbc_url`, `postgres_url`, `schema_name`, and `h2_driver_path`.
- [ ] Add a session-scoped `postgres_container` fixture in `tests/integration/conftest.py` using `testcontainers.postgres.PostgresContainer`.
- [ ] Add function-scoped fixtures for `postgres_url`, `schema_name`, `h2_driver_path`, and copied `fixture_jdbc_url`.
- [ ] Add helper functions that:
  - read `SchemaSnapshot` from the copied H2 fixture,
  - iterate H2 rows table-by-table,
  - inspect PostgreSQL table/column/foreign-key metadata,
  - count PostgreSQL rows per table inside the test schema.

**Verification target**

The harness must let later tests derive expectations from the real H2 fixture without mutating repo files or requiring any manual driver setup.

### Task 2: Add schema parity integration coverage

**Files**

- Create: `tests/integration/test_schema_migration.py`
- Reuse: `tests/integration/conftest.py`, `tests/integration/helpers.py`

**Goal**

Prove `MigrationService.create_schema()` can reproduce the fixture's table structure in PostgreSQL.

**Steps**

- [ ] Read the H2 fixture snapshot through `H2SourceReader` using the shared harness.
- [ ] Run `MigrationService.create_schema()` against a unique PostgreSQL schema for the test.
- [ ] Assert PostgreSQL contains the same set of table names as the H2 snapshot.
- [ ] For each table, assert key structural parity against H2-derived expectations:
  - column names match,
  - nullability matches,
  - primary-key columns match,
  - foreign-key relationships match for references inside the snapshot.
- [ ] Keep assertions runtime-derived from the H2 snapshot so the test remains valid if the fixture content changes intentionally.

**Verification target**

Schema test fails on missing tables, missing columns, or broken key/constraint translation.

### Task 3: Add data parity integration coverage

**Files**

- Create: `tests/integration/test_data_migration.py`
- Reuse: `tests/integration/conftest.py`, `tests/integration/helpers.py`

**Goal**

Prove `MigrationService.load_data()` loads rows from the real H2 fixture into PostgreSQL with stable counts and representative values.

**Steps**

- [ ] Use the shared harness to inspect the H2 snapshot, create the PostgreSQL schema, and then call `MigrationService.load_data()`.
- [ ] For every migrated table, compare H2 row counts with PostgreSQL row counts inside the target schema.
- [ ] For tables with primary keys, fetch deterministic ordered samples from both sources and compare normalized row values after conversion.
- [ ] Normalize value comparisons through helpers so expected PostgreSQL values align with existing conversion logic for booleans, numerics, text, binary, and date/time types.
- [ ] Start with full-row comparison for small tables; use capped ordered samples for larger tables to keep the test stable and fast.

**Verification target**

Data test fails on row loss, row duplication, or value conversion mismatches that show up in representative samples.

### Task 4: Expose H2 driver path in the CLI

**Files**

- Modify: `src/dtrack/cli.py`
- Modify: `tests/unit/test_cli.py`

**Goal**

Unblock real fixture-backed CLI integration tests by allowing the H2 JDBC JAR path to be passed through existing commands.

**Steps**

- [ ] Add `--h2-driver-path` options to `inspect`, `schema`, `data`, and `migrate`.
- [ ] Thread the new option through `_build_options()` into `MigrationOptions.h2_driver_path`.
- [ ] Extend unit tests to verify the command layer still succeeds with the new option wired in.
- [ ] Keep defaults unchanged so existing command usage remains backward-compatible.

**Verification target**

CLI code accepts an explicit driver path without changing behavior for users who already run with a preconfigured JVM classpath.

### Task 5: Add end-to-end migrate command coverage

**Files**

- Create: `tests/integration/test_migrate_command.py`
- Reuse: `tests/integration/conftest.py`, `tests/integration/helpers.py`
- Reuse: `src/dtrack/cli.py`

**Goal**

Prove the public `migrate` CLI command can run the complete inspect -> schema -> data workflow against the real fixture and PostgreSQL testcontainer.

**Steps**

- [ ] Invoke the Typer app with `CliRunner` using the copied fixture JDBC URL, downloaded H2 driver path, shared PostgreSQL URL, and a unique schema name.
- [ ] Assert the command exits successfully and emits the expected high-level success text (`Found ... tables`, `Migration completed`).
- [ ] Re-read PostgreSQL after the command completes and confirm migrated table names plus per-table row counts match the H2-derived expectations.
- [ ] Reuse the same comparison helpers from the data/schema tests so CLI coverage checks behavior, not duplicated assertion logic.

**Verification target**

CLI integration test fails if command wiring, driver-path propagation, schema creation, or data loading breaks anywhere in the full flow.

### Task 6: Document integration-test workflow

**Files**

- Modify: `README.md`

**Goal**

Document the new real-fixture integration test behavior so local and CI runs are predictable.

**Steps**

- [ ] Add a short testing note describing that integration tests download a pinned H2 JDBC JAR automatically.
- [ ] Document the command to run the integration suite directly.
- [ ] Note that fixture files are copied into temp storage during tests and PostgreSQL isolation is handled with per-test schemas.

**Verification target**

A new contributor can run the integration suite without guessing where the H2 driver comes from.

## Suggested todo order

1. Build integration harness.
2. Add schema parity test.
3. Add data parity test.
4. Expose `--h2-driver-path` in the CLI and update unit coverage.
5. Add full `migrate` CLI integration test.
6. Update README testing notes.

## Validation commands for implementation

- `rtk uv run pytest tests/integration/test_schema_migration.py -v`
- `rtk uv run pytest tests/integration/test_data_migration.py -v`
- `rtk uv run pytest tests/integration/test_migrate_command.py -v`
- `rtk task test`

## Notes and risks

- Pick and pin one H2 JDBC version explicitly in the test harness so fixture compatibility is deterministic.
- Keep fixture handling read-only by copying files to temp paths before opening them with H2.
- Prefer shared assertion helpers over duplicated test logic so schema/data/CLI tests stay aligned.
- If the fixture contains very large tables, cap row-content comparisons while still asserting row counts for every table.
- If PostgreSQL type reflection differs from raw H2 metadata in harmless ways, assert semantic parity (names, nullability, PK/FK structure) rather than dialect-specific type string equality.
