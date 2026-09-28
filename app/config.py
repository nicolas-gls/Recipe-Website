from pathlib import Path

# Base directories
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"

# Paths
CSV_PATH = DATA_DIR / "supermarket_products.csv"
JSON_PATH = DATA_DIR / "recipes.json"
DB_PATH = DATA_DIR / "app.db"
