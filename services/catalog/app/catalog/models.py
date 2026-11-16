from pydantic import BaseModel
from typing import List, Optional


class IngredientDetail(BaseModel):
    id: int
    name: str
    category: Optional[str] = None
    amount: float
    unit: str


class RecipeSummary(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    prep_time: int
    cook_time: int
    difficulty: str
    servings: int
    image_url: Optional[str] = None


class RecipeDetail(RecipeSummary):
    steps: List[str]
    ingredients: List[IngredientDetail]
