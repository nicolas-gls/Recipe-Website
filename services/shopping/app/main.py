import logging
import os
import time

from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.database import wait_for_database, check_read_write
from app.migrations import run_migrations
from app.shopping.routes import router as shopping_router

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s - %(message)s",
)

logger = logging.getLogger("shopping.requests")
VERSION = os.getenv("GIT_SHA", "unknown")


@asynccontextmanager
async def lifespan(app: FastAPI):
    wait_for_database()
    run_migrations()
    yield


app = FastAPI(
    title="Shopping List Service",
    description="Generates shopping lists and estimates product costs.",
    version="1.0.0",
    lifespan=lifespan,
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.perf_counter()

    try:
        response = await call_next(request)
    except Exception:
        logger.exception(
            "%s %s failed",
            request.method,
            request.url.path,
        )
        raise

    duration = (time.perf_counter() - start_time) * 1000

    logger.info(
        "%s %s - %s - %.2f ms",
        request.method,
        request.url.path,
        response.status_code,
        duration,
    )

    return response


app.include_router(shopping_router)


@app.get("/health")
def health_check():
    try:
        check_read_write()
        return {"status": "ok", "db": "ok", "version": VERSION}

    except Exception:
        logger.exception("Shopping database health check failed")

        return JSONResponse(
            status_code=503,
            content={
                "status": "error",
                "db": "unavailable",
                "version": VERSION,
            },
        )
