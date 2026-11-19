import json
from contextlib import contextmanager

import pytest

from app.catalog import services


class FakeResult:
    def __init__(self, rows):
        self.rows = rows

    def mappings(self):
        return self

    def all(self):
        return list(self.rows)

    def first(self):
        return self.rows[0] if self.rows else None


class FakeConnection:
    def __init__(self, recipes, ingredients, summaries):
        self.recipes = recipes
        self.ingredients = ingredients
        self.summaries = summaries

    def execute(self, query, _parameters=None):
        statement = str(query)
        if "SELECT DISTINCT" in statement:
            return FakeResult(self.summaries)
        if "FROM dbo.recipes" in statement and "WHERE" in statement:
            recipe_id = _parameters["recipe_id"]
            return FakeResult([self.recipes[recipe_id]] if recipe_id in self.recipes else [])
        if "FROM dbo.recipes" in statement:
            return FakeResult(self.summaries)
        return FakeResult(self.ingredients)

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        return False


class FakeEngine:
    def __init__(self, connection):
        self.connection = connection

    @contextmanager
    def connect(self):
        yield self.connection


@pytest.fixture
def fake_catalog_engine(monkeypatch):
    summaries = [
        {
            "id": 1,
            "name": "Pasta Primavera",
            "description": "A quick pasta dish",
            "prep_time": 10,
            "cook_time": 20,
            "difficulty": "Easy",
            "servings": 2,
            "image_url": None,
        },
        {
            "id": 2,
            "name": "Soup",
            "description": "A warm soup",
            "prep_time": 15,
            "cook_time": 30,
            "difficulty": "Medium",
            "servings": 4,
            "image_url": "https://example.com/soup.jpg",
        },
    ]
    recipes = {
        1: {
            **summaries[0],
            "steps": json.dumps(["Boil pasta", "Add vegetables"]),
        }
    }
    ingredients = [
        {"id": 1, "name": "Flour", "category": "Pantry", "amount": 100, "unit": "g"},
        {"id": 2, "name": "Milk", "category": "Dairy", "amount": 0.5, "unit": "l"},
    ]
    connection = FakeConnection(recipes, ingredients, summaries)
    monkeypatch.setattr(services, "engine", FakeEngine(connection))


@pytest.mark.parametrize(
    ("amount", "default", "target", "expected"),
    [(1.25, 2, 3, 1.88), (7, 0, 4, 7), (7, 4, 0, 7)],
)
def test_scale_ingredient_amount(amount, default, target, expected):
    assert services.scale_ingredient_amount(amount, default, target) == expected


def test_list_recipes_returns_summaries_with_image_fallback(fake_catalog_engine):
    recipes = services.list_recipes("pasta")

    assert recipes[0].name == "Pasta Primavera"
    assert recipes[0].image_url.startswith("https://images.unsplash.com/")


def test_get_recipe_scales_ingredients_and_parses_steps(fake_catalog_engine):
    recipe = services.get_recipe_by_id(1, target_servings=4)

    assert recipe.name == "Pasta Primavera"
    assert recipe.servings == 4
    assert recipe.steps == ["Boil pasta", "Add vegetables"]
    assert [(item.name, item.amount, item.unit) for item in recipe.ingredients] == [
        ("Flour", 200, "g"),
        ("Milk", 1, "l"),
    ]


def test_get_recipe_returns_none_for_missing_recipe(fake_catalog_engine):
    assert services.get_recipe_by_id(999) is None
