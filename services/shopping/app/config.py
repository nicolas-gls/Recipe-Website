import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[1]

DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(parents=True, exist_ok=True)

DB_PATH = DATA_DIR / "shopping.db"

# Address of the Catalog service, provided through an environment variable.
CATALOG_URL = os.getenv("CATALOG_URL")
