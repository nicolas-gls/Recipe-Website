import sqlite3
from app.config import DB_PATH


def get_connection():
    """Returns a SQLite connection with foreign key support and dict-like row access enabled."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


# Alias for backwards compatibility
get_db_connection = get_connection


def init_db():
    """Initializes the database schema with the 4 required tables."""
    conn = get_connection()
    cursor = conn.cursor()

    cursor.executescript("""
    DROP TABLE IF EXISTS recipe_ingredients;
    DROP TABLE IF EXISTS supermarket_products;
    DROP TABLE IF EXISTS recipes;
    DROP TABLE IF EXISTS ingredients;

    -- 1. Recipes catalog
    CREATE TABLE IF NOT EXISTS recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        prep_time INTEGER,
        cook_time INTEGER,
        difficulty TEXT,
        servings INTEGER,
        steps TEXT, -- Stored as JSON string array
        image_url TEXT
    );

    -- 2. Master list of standardized ingredients
    CREATE TABLE IF NOT EXISTS ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        category TEXT
    );

    -- 3. Recipe ingredient breakdown (Junction table)
    CREATE TABLE IF NOT EXISTS recipe_ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id INTEGER NOT NULL,
        ingredient_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
    );

    -- 4. Supermarket inventory & pricing
    CREATE TABLE IF NOT EXISTS supermarket_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        price REAL NOT NULL,
        package_size REAL,
        package_unit TEXT,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
    );
    """)

    conn.commit()
    conn.close()


if __name__ == "__main__":
    init_db()
    print("Database schema successfully initialized.")
