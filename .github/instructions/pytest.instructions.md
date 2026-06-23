---
name: Pytest Testing Guidelines
applyTo: '**/tests/**/*.py'
description: This file describes the guidelines for writing tests using Pytest in the project.
---

# Pytest Testing Guidelines

- **Framework**: Always use `pytest` with the Arrange-Act-Assert structure.
- **Coverage**: Every new endpoint or service function must include a corresponding unit test.
- **Integration**: For critical paths, include integration tests that cover interactions between components via `testcontainers`.
- **Execution**: Run the relevant test file after generating code changes to verify functionality.
