import os

DATABASE_URL = os.getenv("DATABASE_URL")
CATALOG_URL = os.getenv("CATALOG_URL")
UI_ORIGIN = os.getenv("CORS_ORIGINS", os.getenv("UI_ORIGIN", "http://localhost:8080"))
UI_ORIGINS = [origin.strip().rstrip("/") for origin in UI_ORIGIN.split(",") if origin.strip()]

if not DATABASE_URL:
    raise RuntimeError(
        "DATABASE_URL environment variable is not configured for Shopping."
    )

# Number of connection attempts during startup.
DB_MAX_RETRIES = 9

# Initial delay between retries, in seconds.
DB_RETRY_DELAY = 1

# Maximum delay between retries, in seconds.
DB_MAX_RETRY_DELAY = 15
