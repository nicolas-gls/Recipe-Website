from contextlib import contextmanager

import pytest

from app.shopping import services
from app.shopping.models import RecipeSelection


class FakeResult:
    def __init__(self, rows):
        self.rows = rows

    def mappings(self):
        return self

    def all(self):
        return list(self.rows)


class FakeConnection:
    def __init__(self, products):
        self.products = products

    def execute(self, _query, _parameters=None):
        ingredient_id = _parameters["ingredient_id"]
        return FakeResult(self.products.get(ingredient_id, []))


class FakeEngine:
    def __init__(self, products):
        self.connection = FakeConnection(products)

    @contextmanager
    def connect(self):
        yield self.connection


@pytest.mark.parametrize(
    ("amount", "unit", "expected"),
    [(1.5, " KG ", (1500, "g")), (0.75, "liter", (750, "ml")), (3, " Tbsp ", (3, "tbsp"))],
)
def test_normalize_unit_and_amount(amount, unit, expected):
    assert services.normalize_unit_and_amount(amount, unit) == expected


def test_calculate_shopping_list_aggregates_and_prices(monkeypatch):
    monkeypatch.setattr(
        services,
        "get_recipe_from_catalog",
        lambda recipe_id, target_servings: {
            "ingredients": [
                {"id": 1, "name": "Flour", "category": "Pantry", "amount": 100, "unit": "g"},
                {"id": 2, "name": "Milk", "category": "Dairy", "amount": 0.5, "unit": "l"},
            ]
            if recipe_id == 1
            else [],
        },
    )
    monkeypatch.setattr(
        services,
        "engine",
        FakeEngine(
            {
                1: [{"product_name": "Flour 250g", "price": 2.0, "package_size": 250, "package_unit": "g"}],
                2: [{"product_name": "Milk 500ml", "price": 1.5, "package_size": 0.5, "package_unit": "l"}],
            }
        ),
    )

    result = services.calculate_shopping_list(
        [RecipeSelection(recipe_id=1, target_servings=2)]
    )

    assert [(item.ingredient_name, item.packages_needed) for item in result.items] == [
        ("Milk", 1),
        ("Flour", 1),
    ]
    assert result.total_estimated_cost == 3.5


def test_calculate_shopping_list_handles_empty_and_missing_recipes(monkeypatch):
    monkeypatch.setattr(services, "get_recipe_from_catalog", lambda *_args: None)
    monkeypatch.setattr(services, "engine", FakeEngine({}))

    assert services.calculate_shopping_list([]).items == []
    result = services.calculate_shopping_list(
        [RecipeSelection(recipe_id=999, target_servings=2)]
    )
    assert result.items == []
    assert result.total_estimated_cost == 0


def test_catalog_unavailable_returns_controlled_error(monkeypatch):
    monkeypatch.setattr(services, "CATALOG_URL", "http://127.0.0.1:9")

    with pytest.raises(services.HTTPException) as error:
        services.get_recipe_from_catalog(1, 2)

    assert error.value.status_code == 503
