import os


os.environ.setdefault(
    "DATABASE_URL",
    "mssql+pymssql://test:test@localhost:1433/shopping_db",
)
os.environ.setdefault("CATALOG_URL", "http://127.0.0.1:9")
