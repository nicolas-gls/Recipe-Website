from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from app.catalog.models import RecipeSummary, RecipeDetail
from app.catalog.services import list_recipes, get_recipe_by_id

router = APIRouter(prefix="/recipes", tags=["Catalog"])


@router.get("", response_model=List[RecipeSummary])
def get_recipes(q: Optional[str] = Query(None, description="Search recipes by name")):
    return list_recipes(search_query=q)


@router.get("/{recipe_id}", response_model=RecipeDetail)
def get_recipe(
    recipe_id: int,
    servings: Optional[int] = Query(None, description="Target serving size"),
):
    recipe = get_recipe_by_id(recipe_id=recipe_id, target_servings=servings)
    if not recipe:
        raise HTTPException(
            status_code=404, detail=f"Recipe with ID {recipe_id} not found"
        )
    return recipe
