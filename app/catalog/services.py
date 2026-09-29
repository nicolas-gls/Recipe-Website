import json
from typing import List, Optional
from app.database import get_connection
from app.catalog.models import RecipeSummary, RecipeDetail, IngredientDetail


def scale_ingredient_amount(
    base_amount: float, default_servings: int, target_servings: int
) -> float:
    """Scales ingredient quantity proportionally based on target servings."""
    if default_servings <= 0 or target_servings <= 0:
        return base_amount
    scale_factor = target_servings / default_servings
    return round(base_amount * scale_factor, 2)


def list_recipes(search_query: Optional[str] = None) -> List[RecipeSummary]:
    """Retrieves all recipes from the database with optional search filtering."""
    conn = get_connection()
    cursor = conn.cursor()

    if search_query:
        query = "SELECT id, name, description, prep_time, cook_time, difficulty, servings FROM recipes WHERE name LIKE ?"
        cursor.execute(query, (f"%{search_query.strip()}%",))
    else:
        query = "SELECT id, name, description, prep_time, cook_time, difficulty, servings FROM recipes"
        cursor.execute(query)

    rows = cursor.fetchall()
    conn.close()

    return [
        RecipeSummary(
            id=row["id"],
            name=row["name"],
            description=row["description"],
            prep_time=row["prep_time"],
            cook_time=row["cook_time"],
            difficulty=row["difficulty"],
            servings=row["servings"],
        )
        for row in rows
    ]


def get_recipe_by_id(
    recipe_id: int, target_servings: Optional[int] = None
) -> Optional[RecipeDetail]:
    """Retrieves a single recipe with ingredients scaled to target servings if specified."""
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT id, name, description, prep_time, cook_time, difficulty, servings, steps FROM recipes WHERE id = ?",
        (recipe_id,),
    )
    recipe_row = cursor.fetchone()
    if not recipe_row:
        conn.close()
        return None

    default_servings = recipe_row["servings"]
    effective_servings = (
        target_servings
        if (target_servings and target_servings > 0)
        else default_servings
    )

    cursor.execute(
        """
        SELECT i.id, i.name, i.category, ri.amount, ri.unit
        FROM recipe_ingredients ri
        JOIN ingredients i ON ri.ingredient_id = i.id
        WHERE ri.recipe_id = ?
    """,
        (recipe_id,),
    )
    ing_rows = cursor.fetchall()
    conn.close()

    ingredients = []
    for ing in ing_rows:
        scaled_qty = scale_ingredient_amount(
            ing["amount"], default_servings, effective_servings
        )
        ingredients.append(
            IngredientDetail(
                id=ing["id"],
                name=ing["name"],
                category=ing["category"],
                amount=scaled_qty,
                unit=ing["unit"],
            )
        )

    steps_list = json.loads(recipe_row["steps"]) if recipe_row["steps"] else []

    return RecipeDetail(
        id=recipe_row["id"],
        name=recipe_row["name"],
        description=recipe_row["description"],
        prep_time=recipe_row["prep_time"],
        cook_time=recipe_row["cook_time"],
        difficulty=recipe_row["difficulty"],
        servings=effective_servings,
        steps=steps_list,
        ingredients=ingredients,
    )
