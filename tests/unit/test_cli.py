from typer.testing import CliRunner

from dtrack.cli import app


def test_data_command_emits_summary(monkeypatch) -> None:
    class StubbedMigrationService:
        def __init__(self, *_args, **_kwargs):
            pass

        def load_data(self, options):
            return type("Report", (), {"success": True, "tables": [], "warnings": [], "errors": []})()

    monkeypatch.setattr("dtrack.cli.MigrationService", StubbedMigrationService)

    runner = CliRunner()
    result = runner.invoke(app, ["--h2-jdbc-url", "jdbc:h2:mem:test", "--postgres-url", "postgresql://test"])

    assert result.exit_code == 0
    assert "Data load completed" in result.stdout


def test_data_command_passes_h2_driver_path(monkeypatch) -> None:
    class StubbedMigrationService:
        def __init__(self, *_args, **_kwargs):
            self.last_options = None

        def load_data(self, options):
            self.last_options = options
            return type("Report", (), {"success": True, "tables": [], "warnings": [], "errors": []})()

    service = StubbedMigrationService()
    monkeypatch.setattr("dtrack.cli.MigrationService", lambda *args, **kwargs: service)

    runner = CliRunner()
    result = runner.invoke(
        app,
        [
            "--h2-jdbc-url",
            "jdbc:h2:mem:test",
            "--postgres-url",
            "postgresql://test",
            "--h2-driver-path",
            "/tmp/driver.jar",
        ],
    )

    assert result.exit_code == 0
    assert service.last_options is not None
    assert service.last_options.h2_driver_path == "/tmp/driver.jar"
