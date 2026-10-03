import os
from pathlib import Path

# Base directories
BASE_DIR = Path(__file__).resolve().parent.parent

env_data_dir = os.getenv("DATA_DIR")
DATA_DIR = Path(env_data_dir) if env_data_dir else BASE_DIR / "data"

# Paths
CSV_PATH = DATA_DIR / "supermarket_products.csv"
JSON_PATH = DATA_DIR / "recipes.json"
DB_PATH = DATA_DIR / "app.db"

PORT = int(os.getenv("PORT", 8000))
