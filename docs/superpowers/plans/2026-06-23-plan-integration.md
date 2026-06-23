# Plan Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add fixture-backed H2-to-PostgreSQL integration coverage and expose the missing H2 driver path through the CLI.

**Architecture:** Reuse the existing migration service and CLI entry points, but add reusable pytest fixtures to provision an H2 JDBC jar, copy embedded fixture files into temp storage, and run schema/data migration assertions against a testcontainer PostgreSQL instance.

**Tech Stack:** Python 3.14, Typer, SQLAlchemy, pytest, testcontainers[postgresql], jaydebeapi, jpype1.

## Global Constraints

- Use pytest with Arrange-Act-Assert structure.
- Keep integration tests self-contained by downloading a pinned H2 JDBC JAR automatically.
- Preserve backward-compatible CLI defaults while adding `--h2-driver-path` support.

---

### Task 1: Build reusable integration harness

**Files:**
- Create: `tests/integration/conftest.py`
- Create: `tests/integration/helpers.py`

- [ ] Add a pinned H2 JDBC downloader in `tests/integration/helpers.py`.
- [ ] Add fixture-copying and JDBC URL helpers.
- [ ] Add shared PostgreSQL container and per-test schema fixtures in `tests/integration/conftest.py`.
- [ ] Add helpers to inspect H2 snapshots and compare PostgreSQL state.

### Task 2: Add schema parity coverage

**Files:**
- Create: `tests/integration/test_schema_migration.py`

- [ ] Write a test that inspects the real H2 fixture schema.
- [ ] Run `MigrationService.create_schema()` against the test schema.
- [ ] Assert table names and core structure match the H2 snapshot.

### Task 3: Add data parity coverage

**Files:**
- Create: `tests/integration/test_data_migration.py`

- [ ] Write a test that loads fixture data into PostgreSQL.
- [ ] Compare row counts and representative values against H2 rows.

### Task 4: Expose H2 driver path in the CLI

**Files:**
- Modify: `src/dtrack/cli.py`
- Modify: `tests/unit/test_cli.py`

- [ ] Add `--h2-driver-path` to the relevant commands.
- [ ] Thread the option through `_build_options()`.
- [ ] Extend CLI unit coverage for the new option.

### Task 5: Add end-to-end migrate CLI coverage

**Files:**
- Create: `tests/integration/test_migrate_command.py`

- [ ] Invoke the Typer app with the copied fixture and PostgreSQL container.
- [ ] Assert the CLI exits successfully and prints migration summary text.
- [ ] Verify migrated table names and row counts in PostgreSQL.

### Task 6: Document integration testing

**Files:**
- Modify: `README.md`

- [ ] Add testing notes for the automatic H2 driver download and fixture-based integration flow.
