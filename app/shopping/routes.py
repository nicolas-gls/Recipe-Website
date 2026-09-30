from fastapi import APIRouter
from app.shopping.models import ShoppingListRequest, ShoppingListResponse
from app.shopping.services import calculate_shopping_list

router = APIRouter(prefix="/shopping-list", tags=["Shopping List"])


@router.post("", response_model=ShoppingListResponse)
def generate_shopping_list(payload: ShoppingListRequest):
    return calculate_shopping_list(payload.recipes)
