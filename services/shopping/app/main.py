from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.database import init_db
from app.shopping.routes import router as shopping_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(
    title="Shopping List Service",
    description="Creates shopping lists and estimates product costs.",
    version="1.0.0",
    lifespan=lifespan,
)

app.include_router(shopping_router)


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "shopping",
    }
