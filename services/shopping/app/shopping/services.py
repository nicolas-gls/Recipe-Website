import json
import math
import socket

from typing import List, Dict, Any
from urllib.error import HTTPError, URLError
from urllib.request import urlopen

from fastapi import HTTPException
from sqlalchemy import text

from app.config import CATALOG_URL
from app.database import engine
from app.shopping.models import (
    RecipeSelection,
    ShoppingItem,
    ShoppingListResponse,
)


def normalize_unit_and_amount(amount: float, unit: str) -> tuple[float, str]:
    """Normalize units to standard base units."""

    u = unit.lower().strip()

    if u in ["kg", "kilogram", "kilograms"]:
        return amount * 1000.0, "g"

    if u in ["l", "liter", "liters"]:
        return amount * 1000.0, "ml"

    return amount, u


def get_recipe_from_catalog(
    recipe_id: int,
    target_servings: int,
) -> Dict[str, Any] | None:
    """Retrieve a recipe from the Catalog service over HTTP."""

    if not CATALOG_URL:
        raise HTTPException(
            status_code=503,
            detail="Catalog service URL is not configured.",
        )

    url = (
        f"{CATALOG_URL.rstrip('/')}/recipes/" f"{recipe_id}?servings={target_servings}"
    )

    try:
        with urlopen(url, timeout=5) as response:
            return json.loads(response.read().decode("utf-8"))

    except HTTPError as error:
        if error.code == 404:
            return None

        raise HTTPException(
            status_code=502,
            detail="Catalog service returned an error.",
        ) from error

    except (TimeoutError, socket.timeout) as error:
        raise HTTPException(
            status_code=504,
            detail="Catalog service request timed out.",
        ) from error

    except URLError as error:
        if isinstance(error.reason, (TimeoutError, socket.timeout)):
            raise HTTPException(
                status_code=504,
                detail="Catalog service request timed out.",
            ) from error

        raise HTTPException(
            status_code=503,
            detail="Catalog service is currently unavailable.",
        ) from error

    except (json.JSONDecodeError, UnicodeDecodeError) as error:
        raise HTTPException(
            status_code=502,
            detail="Catalog service returned an invalid response.",
        ) from error


def calculate_shopping_list(
    selections: List[RecipeSelection],
) -> ShoppingListResponse:
    """Aggregate recipe ingredients and calculate estimated product costs."""

    if not selections:
        return ShoppingListResponse(
            items=[],
            total_estimated_cost=0.0,
        )

    aggregated: Dict[int, Dict[str, Any]] = {}

    # Obtain recipe information from Catalog through HTTP.
    for selection in selections:
        if selection.target_servings <= 0:
            continue

        recipe = get_recipe_from_catalog(
            selection.recipe_id,
            selection.target_servings,
        )

        if recipe is None:
            continue

        for ingredient in recipe["ingredients"]:
            ingredient_id = ingredient["id"]

            norm_amount, norm_unit = normalize_unit_and_amount(
                ingredient["amount"],
                ingredient["unit"],
            )

            if ingredient_id in aggregated:
                aggregated[ingredient_id]["total_amount"] += norm_amount
            else:
                aggregated[ingredient_id] = {
                    "id": ingredient_id,
                    "name": ingredient["name"],
                    "category": ingredient.get("category"),
                    "total_amount": norm_amount,
                    "unit": norm_unit,
                }

    # Only access Shopping's own database.
    items: List[ShoppingItem] = []
    total_cost = 0.0

    with engine.connect() as connection:

        for ingredient_id, data in aggregated.items():
            total_amount = round(data["total_amount"], 2)
            unit = data["unit"]

            query = text("""
                SELECT
                    product_name,
                    price,
                    package_size,
                    package_unit
                FROM dbo.supermarket_products
                WHERE ingredient_id = :ingredient_id
                ORDER BY price ASC
            """)

            products = (
                connection.execute(
                    query,
                    {"ingredient_id": ingredient_id},
                )
                .mappings()
                .all()
            )

            product_name = None
            packages_needed = 1
            estimated_price = 0.0

            if products:
                product = products[0]

                product_name = product["product_name"]
                package_size = product["package_size"]
                package_unit = product["package_unit"]
                price = product["price"]

                if package_size and package_size > 0:
                    normalized_package_size, _ = normalize_unit_and_amount(
                        package_size,
                        package_unit if package_unit else unit,
                    )

                    packages_needed = max(
                        1,
                        math.ceil(total_amount / normalized_package_size),
                    )

                    estimated_price = round(
                        packages_needed * price,
                        2,
                    )
                else:
                    estimated_price = round(price, 2)

            total_cost += estimated_price

            items.append(
                ShoppingItem(
                    ingredient_id=ingredient_id,
                    ingredient_name=data["name"],
                    category=data["category"],
                    total_amount=total_amount,
                    unit=unit,
                    suggested_product_name=product_name,
                    packages_needed=packages_needed,
                    estimated_price=estimated_price,
                )
            )

    items.sort(
        key=lambda item: (
            item.category or "",
            item.ingredient_name,
        )
    )

    return ShoppingListResponse(
        items=items,
        total_estimated_cost=round(total_cost, 2),
    )
