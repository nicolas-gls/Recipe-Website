import json

import pytest

from app import database
from app.catalog.services import (
    get_recipe_by_id,
    list_recipes,
    scale_ingredient_amount,
)
from app.shopping.models import RecipeSelection
from app.shopping.services import calculate_shopping_list, normalize_unit_and_amount


@pytest.fixture
def recipe_database(tmp_path, monkeypatch):
    monkeypatch.setattr(database, "DB_PATH", tmp_path / "recipes.db")
    database.init_db()

    conn = database.get_connection()
    conn.executemany(
        """
        INSERT INTO recipes
            (id, name, description, prep_time, cook_time, difficulty, servings, steps, image_url)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        [
            (1, "Pasta Primavera", "A quick pasta dish", 10, 20, "Easy", 2,
             json.dumps(["Boil pasta", "Add vegetables"]), None),
            (2, "Hearty Soup", "A filling soup", 15, 30, "Medium", 4,
             json.dumps(["Simmer ingredients"]), "https://example.com/soup.jpg"),
            (3, "Zero-Serving Recipe", None, 0, 0, "Easy", 0, None, None),
        ],
    )
    conn.executemany(
        "INSERT INTO ingredients (id, name, category) VALUES (?, ?, ?)",
        [
            (1, "Flour", "Pantry"),
            (2, "Milk", "Dairy"),
            (3, "Salt", "Pantry"),
            (4, "Pepper", "Spices"),
        ],
    )
    conn.executemany(
        """
        INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount, unit)
        VALUES (?, ?, ?, ?)
        """,
        [
            (1, 1, 100, "g"),
            (1, 2, 0.5, "l"),
            (1, 3, 1, "tsp"),
            (1, 4, 2, "pinch"),
            (2, 1, 0.2, "kg"),
            (3, 1, 50, "g"),
        ],
    )
    conn.executemany(
        """
        INSERT INTO supermarket_products
            (ingredient_id, product_name, price, package_size, package_unit)
        VALUES (?, ?, ?, ?, ?)
        """,
        [
            (1, "Flour 250g", 2.0, 250, "g"),
            (1, "Flour 500g", 3.5, 500, "g"),
            (2, "Milk 500ml", 1.5, 0.5, "l"),
            (3, "Salt pack", 0.75, None, None),
        ],
    )
    conn.commit()
    conn.close()


@pytest.mark.parametrize(
    ("amount", "default_servings", "target_servings", "expected"),
    [
        (1.25, 2, 3, 1.88),
        (7, 0, 4, 7),
        (7, 4, 0, 7),
    ],
)
def test_scale_ingredient_amount(amount, default_servings, target_servings, expected):
    assert (
        scale_ingredient_amount(amount, default_servings, target_servings) == expected
    )


def test_list_recipes_filters_titles_and_ingredients_and_uses_image_fallback(
    recipe_database,
):
    recipes = list_recipes()
    assert [recipe.name for recipe in recipes] == [
        "Pasta Primavera",
        "Hearty Soup",
        "Zero-Serving Recipe",
    ]
    assert recipes[0].image_url.startswith("https://images.unsplash.com/")

    assert [recipe.name for recipe in list_recipes("  pasta  ")] == [
        "Pasta Primavera"
    ]
    assert [recipe.name for recipe in list_recipes("flour")] == [
        "Pasta Primavera",
        "Hearty Soup",
        "Zero-Serving Recipe",
    ]
    assert len(list_recipes("   ")) == 3


def test_get_recipe_by_id_scales_ingredients_and_parses_steps(recipe_database):
    recipe = get_recipe_by_id(1, target_servings=4)

    assert recipe.servings == 4
    assert recipe.steps == ["Boil pasta", "Add vegetables"]
    assert [(ingredient.name, ingredient.amount) for ingredient in recipe.ingredients] == [
        ("Flour", 200),
        ("Milk", 1),
        ("Salt", 2),
        ("Pepper", 4),
    ]
    assert recipe.image_url.startswith("https://images.unsplash.com/")


@pytest.mark.parametrize("target_servings", [None, 0, -2])
def test_get_recipe_uses_default_servings_for_invalid_target(
    recipe_database, target_servings
):
    recipe = get_recipe_by_id(2, target_servings=target_servings)
    assert recipe.servings == 4
    assert recipe.image_url == "https://example.com/soup.jpg"
    assert recipe.steps == ["Simmer ingredients"]


def test_get_recipe_handles_zero_default_servings_and_missing_recipe(recipe_database):
    recipe = get_recipe_by_id(3, target_servings=5)
    assert recipe.servings == 5
    assert recipe.ingredients[0].amount == 50
    assert recipe.steps == []
    assert get_recipe_by_id(999) is None


@pytest.mark.parametrize(
    ("amount", "unit", "expected_amount", "expected_unit"),
    [
        (1.5, " KG ", 1500, "g"),
        (2, "kilograms", 2000, "g"),
        (0.75, "liter", 750, "ml"),
        (2, " LITERS ", 2000, "ml"),
        (3, " Tbsp ", 3, "tbsp"),
    ],
)
def test_normalize_unit_and_amount(amount, unit, expected_amount, expected_unit):
    assert normalize_unit_and_amount(amount, unit) == (expected_amount, expected_unit)


def test_calculate_shopping_list_scales_aggregates_prices_and_sorts(recipe_database):
    result = calculate_shopping_list(
        [
            RecipeSelection(recipe_id=1, target_servings=4),
            RecipeSelection(recipe_id=2, target_servings=2),
        ]
    )
    items = {item.ingredient_name: item for item in result.items}

    assert [(item.category, item.ingredient_name) for item in result.items] == [
        ("Dairy", "Milk"),
        ("Pantry", "Flour"),
        ("Pantry", "Salt"),
        ("Spices", "Pepper"),
    ]
    assert (items["Flour"].total_amount, items["Flour"].unit) == (300, "g")
    assert items["Flour"].suggested_product_name == "Flour 250g"
    assert items["Flour"].packages_needed == 2
    assert items["Flour"].estimated_price == 4
    assert (items["Milk"].total_amount, items["Milk"].unit) == (1000, "ml")
    assert items["Milk"].packages_needed == 2
    assert items["Milk"].estimated_price == 3
    assert items["Salt"].packages_needed == 1
    assert items["Salt"].estimated_price == 0.75
    assert items["Pepper"].suggested_product_name is None
    assert items["Pepper"].estimated_price == 0
    assert result.total_estimated_cost == 7.75


def test_calculate_shopping_list_skips_invalid_selections_and_empty_input(
    recipe_database,
):
    assert calculate_shopping_list([]).items == []
    result = calculate_shopping_list(
        [
            RecipeSelection(recipe_id=1, target_servings=0),
            RecipeSelection(recipe_id=999, target_servings=2),
        ]
    )
    assert result.items == []
    assert result.total_estimated_cost == 0


def test_calculate_shopping_list_uses_unscaled_amount_for_zero_default_servings(
    recipe_database,
):
    result = calculate_shopping_list(
        [RecipeSelection(recipe_id=3, target_servings=2)]
    )
    assert len(result.items) == 1
    assert result.items[0].total_amount == 50
