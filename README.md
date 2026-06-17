# Dependency Track v5 Migration

## Context

Migration

## Database migration

### Backup h2 database before migration

 ```psql
pg_dump -F c -U <username> -h <host> -d <database_name> -f backup_20260615.dump
 ```

 ✏️ Note
 - The custom format (`-F -c`) compresses the file size and allows for flexible, multi-threaded restoration via the `pg_restore` utility
 - We do **not** start `apiserver` yet. The v5 `apiserver` seeds tables on first boot that the migrator must populate from v4, so starting it before the migration would corrupt the destination.
### Aliasing the migrator

DTrack shipped migrator as container image. So that, we just need to run migrator via `docker`:

Bootstrapping the v5 schema

```bash
docker run --rm -it ghcr.io/dependencytrack/v4-migrator:5.0.1 \
  --target-url 'jdbc:postgresql://<host>:<port>/<database_name>' \
  --target-user '<user>' \
  --target-pass '<password>'

## Expected output:
# Applying v5 Flyway schema up to 202605111028
# ...
# Bootstrap complete. Flyway head = 202605111028. Run 'extract' or 'run' next.
```
