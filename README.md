# DTrack Migration CLI

This repository now includes a Python-based CLI for migrating schema and data from H2 into PostgreSQL.

## Quick start

Install dependencies with `uv sync` or `task init` and run the CLI via:

```bash
uv run python -m dtrack --help
```

## Available commands

- `data` – copy data rows into PostgreSQL

Example:

```bash
uv run python -m dtrack \
    --h2-jdbc-url jdbc:h2:./tests/integration/fixtures/db \
    --postgres-url postgresql+psycopg://dtrack:dtrack@localhost:5432/dtrack \
    --h2-driver-path vendors/h2.jar
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

## Step to migrate from DTrack 4.x to 5.x

### Prepare PostgreSQL DB for DTrack 4.x

Start empty PostgreSQL DB via:

```bash
docker compose -f compose.yaml up -d db
```

The schema will be created automatically, which is compatible with DTrack 4.x.

Then run the migration CLI to copy data from H2 to PostgreSQL:

```bash
docker compose run --build cli task db -- \
    --h2-jdbc-url=jdbc:h2:/data/db \
    --h2-driver-path=/app/vendors/h2.jar \
    --postgres-url=postgresql+psycopg://dtrack:dtrack@db:5432/dtrack
```

### Migrate PostgreSQL DB from DTrack 4.x to 5.x

Set alias for the PostgreSQL DB container:

```bash
alias v4-migrator='docker run --rm -it --network=host dependencytrack/v4-migrator:5.0.2'
```

Then apply the Dtrack 5.x schema via:

```bash
v4-migrator bootstrap \
  --target-url 'jdbc:postgresql://localhost:5432/dtrack_v5' \
  --target-user dtrack \
  --target-pass dtrack
```

Verify the target

```bash
v4-migrator verify \
  --target-url 'jdbc:postgresql://localhost:5432/dtrack_v5' \
  --target-user dtrack \
  --target-pass dtrack
```

Run dry-run to see what will be migrated:

```bash
v4-migrator run \
  --source-url 'jdbc:postgresql://localhost:5432/dtrack' --source-user dtrack --source-pass dtrack \
  --target-url 'jdbc:postgresql://localhost:5432/dtrack_v5' --target-user dtrack --target-pass dtrack \
  --metrics-retention-days 90 \
  --dry-run
```

Extract-Transform-Load (ETL) the data from DTrack 4.x to 5.x:

```bash
v4-migrator run \
  --source-url 'jdbc:postgresql://localhost:5432/dtrack' --source-user dtrack --source-pass dtrack \
  --target-url 'jdbc:postgresql://localhost:5432/dtrack_v5' --target-user dtrack --target-pass dtrack \
  --metrics-retention-days 90
```

## What to do after the migration

- [ ] Start the v5 API server and let it run the post-load reconciliation tasks (metrics, policy evaluation). See Deploying to production for the baseline runtime posture. Everything below requires the API server to be running.
- [ ] Re-enable every migrated notification rule after reviewing its configuration. See Configuring notification alerts.
- [ ] Re-enter repository, analyzer, and vulnerability-source credentials through the v5 secret manager, and turn the affected repositories back on. See Managing secrets and Configuring secret management. Managing secrets requires the new SECRET_MANAGEMENT permission (granted automatically during migration to principals that held SYSTEM_CONFIGURATION in v4; see v5-only permissions granted from v4 equivalents).
- [ ] Reconcile every user whose username got a -CONFLICT-LDAP or -CONFLICT-OIDC suffix (delete genuine duplicates, rename legitimate external identities back to their original username).
- [ ] Wait a few hours, then verify that v5 has populated the EPSS table from the upstream feed.
