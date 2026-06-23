---
name: Python Code Style
applyTo: '**/*.py'
description: This file describes the Python code style for the project.
---

# Python Coding Rules

- **Type Hints**: Explicit type hints are MANDATORY on all function signatures and return types.
- **Async/Await**: Use async endpoints by default for API routes. Keep service layers synchronous unless performing I/O bound tasks.
- **Formatting**: Strictly follow Ruff styling. Do not manually format code spacing.
- **Error Handling**: Never use bare `except:`. Catch explicit exceptions and map them to HTTP status codes via standard exception handlers.
- **Database**: Always use the active database session context manager (`db: AsyncSession`). Never write raw SQL strings; use SQLAlchemy ORM or expression builder.
