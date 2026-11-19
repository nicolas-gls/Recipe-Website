import os


os.environ.setdefault(
    "DATABASE_URL",
    "mssql+pymssql://test:test@localhost:1433/catalog_db",
)
