import os

DATABASE_URL = os.getenv("DATABASE_URL")
CATALOG_URL = os.getenv("CATALOG_URL")

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
