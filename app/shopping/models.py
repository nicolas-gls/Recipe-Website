from pydantic import BaseModel
from typing import List, Optional


class RecipeSelection(BaseModel):
    recipe_id: int
    target_servings: int


class ShoppingItem(BaseModel):
    ingredient_id: int
    ingredient_name: str
    category: Optional[str] = None
    total_amount: float
    unit: str
    suggested_product_name: Optional[str] = None
    packages_needed: int = 1
    estimated_price: float = 0.0


class ShoppingListRequest(BaseModel):
    recipes: List[RecipeSelection]


class ShoppingListResponse(BaseModel):
    items: List[ShoppingItem]
    total_estimated_cost: float
