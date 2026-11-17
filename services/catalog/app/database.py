import logging
import time

import uuid

from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.engine import Engine

from app.config import (
    DATABASE_URL,
    DB_MAX_RETRIES,
    DB_RETRY_DELAY,
    DB_MAX_RETRY_DELAY,
)

logger = logging.getLogger(__name__)

engine: Engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=10,
)


def is_azure_sql_cold_start_error(error: Exception) -> bool:
    """Check whether the SQL Server error is Azure SQL error 40613."""
    current: Exception | None = error
    seen: set[int] = set()

    while current is not None and id(current) not in seen:
        seen.add(id(current))
        if "40613" in str(current):
            return True

        current = getattr(current, "orig", None)

    return False


def check_connection() -> bool:
    """Check that Catalog can connect to its database."""
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
    return True


def check_read_write() -> bool:
    """Check that Catalog can read and write to its database."""
    with engine.connect() as connection:
        transaction = connection.begin()
        try:
            connection.execute(text("SELECT 1"))
            connection.execute(
                text("""
                    INSERT INTO dbo.schema_migrations (version)
                    VALUES (:version)
                """),
                {"version": f"health-check-{uuid.uuid4()}"},
            )
        finally:
            transaction.rollback()
    return True


def wait_for_database() -> None:
    """Retry database connections with exponential backoff."""
    delay = DB_RETRY_DELAY

    for attempt in range(1, DB_MAX_RETRIES + 1):
        try:
            check_connection()
            logger.info("Catalog database connection established.")
            return

        except SQLAlchemyError as error:
            if not is_azure_sql_cold_start_error(error):
                raise

            if attempt == DB_MAX_RETRIES:
                logger.exception(
                    "Catalog database unavailable after %s attempts.",
                    DB_MAX_RETRIES,
                )
                raise

            logger.warning(
                "Catalog database is starting up. "
                "Attempt %s/%s. Retrying in %s seconds.",
                attempt,
                DB_MAX_RETRIES,
                delay,
            )

            time.sleep(delay)
            delay = min(delay * 2, DB_MAX_RETRY_DELAY)
