from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.database import init_db
from app.catalog.routes import router as catalog_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(
    title="Recipe Catalog Service",
    description="Manages recipes and their ingredients.",
    version="1.0.0",
    lifespan=lifespan,
)

app.include_router(catalog_router)


@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "catalog"}
