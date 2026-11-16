import sqlite3

from app.config import DB_PATH


def get_connection():
    """Create a connection to the Shopping service database."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


def init_db():
    """Create Shopping-owned tables if they do not exist."""
    conn = get_connection()

    conn.executescript("""
        CREATE TABLE IF NOT EXISTS supermarket_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ingredient_id INTEGER NOT NULL,
            product_name TEXT NOT NULL,
            price REAL NOT NULL,
            package_size REAL,
            package_unit TEXT
        );
    """)

    conn.commit()
    conn.close()
