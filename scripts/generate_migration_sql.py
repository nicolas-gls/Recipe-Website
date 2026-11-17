import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DB = ROOT / "data" / "app.db"

CATALOG_MIGRATIONS = ROOT / "services" / "catalog" / "migrations"
SHOPPING_MIGRATIONS = ROOT / "services" / "shopping" / "migrations"


def sql_value(value):
    """Convert a SQLite value into a SQL Server literal."""
    if value is None:
        return "NULL"

    if isinstance(value, bool):
        return "1" if value else "0"

    if isinstance(value, int):
        return str(value)

    if isinstance(value, float):
        return format(value, ".17g")

    if isinstance(value, str):
        return "N'" + value.replace("'", "''") + "'"

    raise TypeError(f"Unsupported SQLite value: {type(value)}")


def insert_statements(cursor, table, columns):
    """Generate guarded INSERT statements while preserving original IDs."""
    quoted_columns = ", ".join(f"[{column}]" for column in columns)

    rows = cursor.execute(
        f'SELECT {", ".join(columns)} FROM "{table}" ORDER BY id'
    ).fetchall()

    statements = [
        f"IF NOT EXISTS (SELECT 1 FROM dbo.{table})",
        "BEGIN",
        f"    SET IDENTITY_INSERT dbo.{table} ON;",
    ]

    for row in rows:
        values = ", ".join(sql_value(value) for value in row)
        statements.append(
            f"    INSERT INTO dbo.{table} ({quoted_columns}) " f"VALUES ({values});"
        )

    statements.extend(
        [
            f"    SET IDENTITY_INSERT dbo.{table} OFF;",
            "END;",
        ]
    )

    return statements


def write_migration(path, statements):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n\n".join(statements) + "\n",
        encoding="utf-8",
    )
    print(f"Generated {path.relative_to(ROOT)}")


def generate_catalog(cursor):
    statements = [
        """
IF OBJECT_ID('dbo.recipes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.recipes (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX) NULL,
        prep_time INT NULL,
        cook_time INT NULL,
        difficulty NVARCHAR(50) NULL,
        servings INT NULL,
        steps NVARCHAR(MAX) NULL,
        image_url NVARCHAR(2048) NULL
    );
END;
""",
        """
IF OBJECT_ID('dbo.ingredients', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ingredients (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        category NVARCHAR(100) NULL,
        CONSTRAINT UQ_ingredients_name UNIQUE (name)
    );
END;
""",
        """
IF OBJECT_ID('dbo.recipe_ingredients', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.recipe_ingredients (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        recipe_id INT NOT NULL,
        ingredient_id INT NOT NULL,
        amount FLOAT NOT NULL,
        unit NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_recipe_ingredients_recipes
            FOREIGN KEY (recipe_id)
            REFERENCES dbo.recipes(id)
            ON DELETE CASCADE,
        CONSTRAINT FK_recipe_ingredients_ingredients
            FOREIGN KEY (ingredient_id)
            REFERENCES dbo.ingredients(id)
            ON DELETE CASCADE
    );
END;
""",
    ]

    statements += insert_statements(
        cursor,
        "recipes",
        [
            "id",
            "name",
            "description",
            "prep_time",
            "cook_time",
            "difficulty",
            "servings",
            "steps",
            "image_url",
        ],
    )

    statements += insert_statements(
        cursor,
        "ingredients",
        ["id", "name", "category"],
    )

    statements += insert_statements(
        cursor,
        "recipe_ingredients",
        ["id", "recipe_id", "ingredient_id", "amount", "unit"],
    )

    write_migration(
        CATALOG_MIGRATIONS / "001_init.sql",
        statements,
    )


def generate_shopping(cursor):
    statements = [
        """
IF OBJECT_ID('dbo.supermarket_products', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.supermarket_products (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ingredient_id INT NOT NULL,
        product_name NVARCHAR(255) NOT NULL,
        price FLOAT NOT NULL,
        package_size FLOAT NULL,
        package_unit NVARCHAR(100) NULL
    );
END;
""",
    ]

    statements += insert_statements(
        cursor,
        "supermarket_products",
        [
            "id",
            "ingredient_id",
            "product_name",
            "price",
            "package_size",
            "package_unit",
        ],
    )

    write_migration(
        SHOPPING_MIGRATIONS / "001_init.sql",
        statements,
    )


def main():
    if not SOURCE_DB.exists():
        raise FileNotFoundError(f"Original database not found: {SOURCE_DB}")

    connection = sqlite3.connect(
        f"file:{SOURCE_DB}?mode=ro",
        uri=True,
    )

    try:
        cursor = connection.cursor()
        generate_catalog(cursor)
        generate_shopping(cursor)
    finally:
        connection.close()


if __name__ == "__main__":
    main()
