import math
from typing import List, Dict, Any
from app.database import get_connection
from app.shopping.models import RecipeSelection, ShoppingItem, ShoppingListResponse


def normalize_unit_and_amount(amount: float, unit: str) -> tuple[float, str]:
    """Normalizes units to standard base units (g, ml, count, etc.)."""
    u = unit.lower().strip()
    if u in ["kg", "kilogram", "kilograms"]:
        return amount * 1000.0, "g"
    if u in ["l", "liter", "liters"]:
        return amount * 1000.0, "ml"
    return amount, u


def calculate_shopping_list(selections: List[RecipeSelection]) -> ShoppingListResponse:
    """Aggregates ingredients across multiple recipes and calculates package-based retail pricing."""
    if not selections:
        return ShoppingListResponse(items=[], total_estimated_cost=0.0)

    conn = get_connection()
    cursor = conn.cursor()

    aggregated: Dict[int, Dict[str, Any]] = {}

    for selection in selections:
        if selection.target_servings <= 0:
            continue

        cursor.execute(
            "SELECT servings FROM recipes WHERE id = ?", (selection.recipe_id,)
        )
        r_row = cursor.fetchone()
        if not r_row:
            continue

        default_servings = r_row["servings"]
        scale_factor = (
            selection.target_servings / default_servings
            if default_servings > 0
            else 1.0
        )

        cursor.execute(
            """
            SELECT i.id, i.name, i.category, ri.amount, ri.unit
            FROM recipe_ingredients ri
            JOIN ingredients i ON ri.ingredient_id = i.id
            WHERE ri.recipe_id = ?
        """,
            (selection.recipe_id,),
        )
        ing_rows = cursor.fetchall()

        for ing in ing_rows:
            ing_id = ing["id"]
            scaled_amt = ing["amount"] * scale_factor
            norm_amt, norm_unit = normalize_unit_and_amount(scaled_amt, ing["unit"])

            if ing_id in aggregated:
                aggregated[ing_id]["total_amount"] += norm_amt
            else:
                aggregated[ing_id] = {
                    "id": ing_id,
                    "name": ing["name"],
                    "category": ing["category"],
                    "total_amount": norm_amt,
                    "unit": norm_unit,
                }

    items: List[ShoppingItem] = []
    total_cost = 0.0

    for ing_id, data in aggregated.items():
        total_amt = round(data["total_amount"], 2)
        unit = data["unit"]

        cursor.execute(
            """
            SELECT product_name, price, package_size, package_unit
            FROM supermarket_products
            WHERE ingredient_id = ?
            ORDER BY price ASC
        """,
            (ing_id,),
        )
        products = cursor.fetchall()

        product_name = None
        packages_needed = 1
        est_price = 0.0

        if products:
            p = products[0]
            product_name = p["product_name"]
            pkg_size = p["package_size"]
            pkg_unit = p["package_unit"]
            price = p["price"]

            if pkg_size and pkg_size > 0:
                norm_pkg_size, _ = normalize_unit_and_amount(
                    pkg_size, pkg_unit if pkg_unit else unit
                )
                packages_needed = math.ceil(total_amt / norm_pkg_size)
                if packages_needed < 1:
                    packages_needed = 1
                est_price = round(packages_needed * price, 2)
            else:
                est_price = round(price, 2)

        total_cost += est_price
        items.append(
            ShoppingItem(
                ingredient_id=ing_id,
                ingredient_name=data["name"],
                category=data["category"],
                total_amount=total_amt,
                unit=unit,
                suggested_product_name=product_name,
                packages_needed=packages_needed,
                estimated_price=est_price,
            )
        )

    conn.close()

    items.sort(key=lambda x: (x.category or "", x.ingredient_name))

    return ShoppingListResponse(items=items, total_estimated_cost=round(total_cost, 2))
