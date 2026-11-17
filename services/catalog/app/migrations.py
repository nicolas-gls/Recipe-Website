from pathlib import Path

from sqlalchemy import text

from app.database import engine

MIGRATIONS_DIR = Path(__file__).resolve().parents[1] / "migrations"


def run_migrations() -> None:
    """Apply pending Catalog database migrations."""

    with engine.begin() as connection:

        # Create the migration history table if necessary.
        connection.execute(text("""
            IF OBJECT_ID('dbo.schema_migrations', 'U') IS NULL
            BEGIN
                CREATE TABLE dbo.schema_migrations (
                    version VARCHAR(255) PRIMARY KEY,
                    applied_at DATETIME2 NOT NULL
                        DEFAULT SYSUTCDATETIME()
                );
            END
        """))

        migration_files = sorted(MIGRATIONS_DIR.glob("*.sql"))

        for migration_file in migration_files:
            version = migration_file.name

            already_applied = connection.execute(
                text("""
                    SELECT COUNT(*)
                    FROM dbo.schema_migrations
                    WHERE version = :version
                """),
                {"version": version},
            ).scalar_one()

            if already_applied:
                print(f"Catalog migration already applied: {version}")
                continue

            print(f"Applying Catalog migration: {version}")

            sql = migration_file.read_text(encoding="utf-8")

            # SQL migration files must not contain standalone GO commands.
            connection.exec_driver_sql(sql)

            connection.execute(
                text("""
                    INSERT INTO dbo.schema_migrations (version)
                    VALUES (:version)
                """),
                {"version": version},
            )

            print(f"Catalog migration completed: {version}")
