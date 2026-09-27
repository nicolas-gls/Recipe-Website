import os

PORT = int(os.getenv("PORT", "8000"))
DATA_DIR = os.getenv("DATA_DIR", "data")
DB_PATH = os.path.join(DATA_DIR, "app.db")
CSV_PATH = os.path.join(DATA_DIR, "supermarket_products.csv")
