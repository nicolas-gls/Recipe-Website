import shutil
from pathlib import Path
from fastapi import FastAPI, Request, Query, UploadFile, File, Form
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, RedirectResponse

from app.database import get_connection, init_db
from app.catalog.routes import router as catalog_router
from app.shopping.routes import router as shopping_router
from app.catalog.services import list_recipes, get_recipe_by_id
from app.shopping.services import calculate_shopping_list
from app.shopping.models import RecipeSelection

app = FastAPI(title="Recipe & Shopping List App")

from contextlib import asynccontextmanager
import shutil
from pathlib import Path
from fastapi import FastAPI, Request, Query, UploadFile, File, Form
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, RedirectResponse, JSONResponse

from app.database import get_connection, init_db
from app.catalog.routes import router as catalog_router
from app.shopping.routes import router as shopping_router
from app.catalog.services import list_recipes, get_recipe_by_id
from app.shopping.services import calculate_shopping_list
from app.shopping.models import RecipeSelection


# --- Lifespan Manager (Modern FastAPI Startup/Shutdown) ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 1. Safe Schema Check: Creates tables ONLY IF they do not exist
    init_db()

    # 2. Database Health Verification
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM recipes")
        recipe_count = cursor.fetchone()[0]
        conn.close()
        print(
            f"Startup DB Health Check: Connected successfully. Total recipes: {recipe_count}"
        )

        # 3. Seed ONLY if the database is 100% empty (0 recipes)
        if recipe_count == 0:
            print("Database is empty. Populating initial seed data...")
            from app.seed import seed_database

            seed_database()

    except Exception as e:
        print(f"Startup DB Health Warning: {e}")

    yield  # Application runs here


app = FastAPI(title="Recipe & Shopping List App", lifespan=lifespan)


# --- Database Health Check Endpoint ---
@app.get("/health")
def health_check():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.execute("SELECT COUNT(*) FROM recipes")
        count = cursor.fetchone()[0]
        conn.close()
        return {"status": "healthy", "database": "connected", "total_recipes": count}
    except Exception as e:
        return JSONResponse(
            status_code=500, content={"status": "unhealthy", "database_error": str(e)}
        )


BASE_DIR = Path(__file__).resolve().parent
UPLOAD_DIR = BASE_DIR / "static" / "uploads"
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")
templates = Jinja2Templates(directory=BASE_DIR / "templates")


# --- Jinja Custom Formatting Filters ---
def format_amount(value):
    if value is None:
        return ""
    try:
        val = float(value)
        if val.is_integer():
            return str(int(val))
        return f"{val:.2f}".rstrip("0").rstrip(".")
    except (ValueError, TypeError):
        return str(value)


def format_unit(unit):
    if not unit:
        return ""
    clean_unit = str(unit).strip().lower()
    if clean_unit in ["qty", "qty.", "count", "pcs", "piece", "pieces"]:
        return ""
    return unit


templates.env.filters["format_amount"] = format_amount
templates.env.filters["format_unit"] = format_unit

# Mount API Routers
app.include_router(catalog_router, prefix="/api")
app.include_router(shopping_router, prefix="/api")


# HTML Web Interface Routes
@app.get("/", response_class=HTMLResponse)
def read_recipes_page(request: Request, q: str = Query(None)):
    recipes = list_recipes(search_query=q)
    return templates.TemplateResponse(
        "recipes.html",
        {"request": request, "recipes": recipes, "search_query": q or ""},
    )


@app.get("/recipes/{recipe_id}", response_class=HTMLResponse)
def read_recipe_detail_page(
    request: Request, recipe_id: int, servings: int = Query(None)
):
    recipe = get_recipe_by_id(recipe_id=recipe_id, target_servings=servings)
    if not recipe:
        return HTMLResponse(content="<h1>404 Recipe Not Found</h1>", status_code=404)
    return templates.TemplateResponse(
        "recipe_detail.html", {"request": request, "recipe": recipe}
    )


@app.post("/recipes/{recipe_id}/upload-image")
async def upload_recipe_image(recipe_id: int, image: UploadFile = File(...)):
    raw_ext = Path(image.filename or "").suffix.lower()
    file_extension = (
        raw_ext if raw_ext in [".jpg", ".jpeg", ".png", ".webp"] else ".jpg"
    )

    # Remove any old uploads for this recipe ID regardless of previous extension
    for old_file in UPLOAD_DIR.glob(f"recipe_{recipe_id}.*"):
        try:
            old_file.unlink()
        except OSError:
            pass

    file_name = f"recipe_{recipe_id}{file_extension}"
    save_path = UPLOAD_DIR / file_name

    with open(save_path, "wb") as buffer:
        shutil.copyfileobj(image.file, buffer)

    image_url = f"/static/uploads/{file_name}"
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE recipes SET image_url = ? WHERE id = ?", (image_url, recipe_id)
    )
    conn.commit()
    conn.close()

    return RedirectResponse(url=f"/recipes/{recipe_id}", status_code=303)


@app.post("/recipes/{recipe_id}/edit-name")
async def edit_recipe_name(recipe_id: int, name: str = Form(...)):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE recipes SET name = ? WHERE id = ?", (name, recipe_id))
    conn.commit()
    conn.close()

    return RedirectResponse(url=f"/recipes/{recipe_id}", status_code=303)


@app.get("/shopping", response_class=HTMLResponse)
def read_shopping_list_page(request: Request, r: list[str] = Query([])):
    selections = []
    cart_recipes = []

    for item in r:
        if ":" in item:
            parts = item.split(":")
            try:
                recipe_id = int(parts[0])
                servings = int(parts[1])
                selections.append(
                    RecipeSelection(recipe_id=recipe_id, target_servings=servings)
                )
                recipe = get_recipe_by_id(recipe_id=recipe_id)
                if recipe:
                    cart_recipes.append(
                        {"id": recipe.id, "name": recipe.name, "servings": servings}
                    )
            except ValueError:
                pass

    shopping_data = calculate_shopping_list(selections)

    return templates.TemplateResponse(
        "shopping_list.html",
        {
            "request": request,
            "shopping_data": shopping_data,
            "cart_recipes": cart_recipes,
        },
    )
