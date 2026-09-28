import csv
import json
import re
import sqlite3
from app.config import DB_PATH, CSV_PATH, JSON_PATH
from app.database import init_db, get_connection


def parse_amount(amt_str: str):
    """Splits an amount string like '250g' or '12 count' into numeric size and unit string."""
    if not amt_str or not isinstance(amt_str, str):
        return None, None
    amt_str = amt_str.strip()
    match = re.match(r"^([\d\.]+)\s*([a-zA-Z]+)$", amt_str)
    if match:
        size = float(match.group(1))
        unit = match.group(2)
        return size, unit
    return None, None


def seed_database():
    # 1. Reset and initialize database schema
    init_db()
    conn = get_connection()
    cursor = conn.cursor()

    # 2. Parse CSV and seed ingredients & supermarket_products
    if not CSV_PATH.exists():
        raise FileNotFoundError(f"CSV file not found at {CSV_PATH}")

    ingredient_map = {}  # name -> ingredient_id
    total_csv_rows = 0

    with open(CSV_PATH, mode="r", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        rows = list(reader)
        total_csv_rows = len(rows)

        # First pass: collect unique ingredients and categories
        for row in rows:
            clean_name = row["Ingredient_Name"].strip().lower()
            category = row["Category"].strip()
            if clean_name not in ingredient_map:
                cursor.execute(
                    "INSERT INTO ingredients (name, category) VALUES (?, ?)",
                    (clean_name, category),
                )
                ingredient_map[clean_name] = cursor.lastrowid

        # Second pass: populate supermarket_products
        for row in rows:
            clean_name = row["Ingredient_Name"].strip().lower()
            ing_id = ingredient_map[clean_name]
            product_name = row["Name"].strip()
            price = float(row["Price"])
            pkg_size, pkg_unit = parse_amount(row["Amount"])

            cursor.execute(
                """
                INSERT INTO supermarket_products 
                (ingredient_id, product_name, price, package_size, package_unit)
                VALUES (?, ?, ?, ?, ?)
                """,
                (ing_id, product_name, price, pkg_size, pkg_unit),
            )

    # 3. Read JSON and seed recipes & recipe_ingredients
    if not JSON_PATH.exists():
        raise FileNotFoundError(f"Recipes JSON file not found at {JSON_PATH}")

    with open(JSON_PATH, mode="r", encoding="utf-8") as file:
        recipes_data = json.load(file)

    for recipe in recipes_data:
        steps_json = json.dumps(recipe["steps"])
        cursor.execute(
            """
            INSERT INTO recipes (name, description, prep_time, cook_time, difficulty, servings, steps)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (
                recipe["name"],
                recipe.get("description", ""),
                recipe["prep_time"],
                recipe["cook_time"],
                recipe["difficulty"],
                recipe["servings"],
                steps_json,
            ),
        )
        recipe_id = cursor.lastrowid

        for ing in recipe["ingredients"]:
            ing_name = ing["name"].strip().lower()
            if ing_name not in ingredient_map:
                raise ValueError(
                    f"Recipe ingredient '{ing_name}' in recipe '{recipe['name']}' "
                    f"does not exist in the ingredients database."
                )

            ingredient_id = ingredient_map[ing_name]
            cursor.execute(
                """
                INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit)
                VALUES (?, ?, ?, ?)
                """,
                (recipe_id, ingredient_id, float(ing["amount"]), ing["unit"]),
            )

    conn.commit()

    # 4. Verification & Assertions
    cursor.execute("SELECT COUNT(*) FROM ingredients")
    db_ingredients_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM supermarket_products")
    db_products_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM recipes")
    db_recipes_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM recipe_ingredients")
    db_recipe_ing_count = cursor.fetchone()[0]

    conn.close()

    print("\n--- Seeding Summary & Verification ---")
    print(f"Unique Ingredients: {db_ingredients_count}")
    print(f"Supermarket Products: {db_products_count} (Expected: {total_csv_rows})")
    print(f"Recipes: {db_recipes_count} (Expected: {len(recipes_data)})")
    print(f"Recipe Ingredient Junction Rows: {db_recipe_ing_count}")

    # Integrity Assertions
    assert db_ingredients_count == len(ingredient_map), "Ingredients count mismatch!"
    assert (
        db_products_count == total_csv_rows
    ), f"Expected {total_csv_rows} store products, found {db_products_count}"
    assert db_recipes_count == len(
        recipes_data
    ), f"Expected {len(recipes_data)} recipes, found {db_recipes_count}"
    assert db_recipe_ing_count > 0, "No recipe ingredients populated!"

    print("\nAll database seeding checks passed successfully!")


if __name__ == "__main__":
    seed_database()
