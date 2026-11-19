# Recipe Hub

A recipe catalog and shopping-list web app built with FastAPI, SQLite, and
server-rendered Jinja2 templates. Browse and search recipes, scale ingredient
quantities by servings, and combine ingredients from multiple recipes into a
shopping list with estimated package-based prices.

## Features

- Browse recipes and search by recipe name or ingredient.
- View recipe details and adjust ingredient quantities for a target serving size.
- Add recipes to a shopping list and combine shared ingredients across selected
  recipes.
- Estimate costs using whole supermarket packages and the lowest-priced product
  option available for each ingredient.

The app does not currently track ingredients users already have at home or
provide a full workflow for creating and editing recipes.

## Requirements

- Python 3.10 or newer
- pip

Install the dependencies:

```bash
python -m pip install -r requirements.txt
```

## Run the split application with Docker Compose

The Assignment 2 stack runs SQL Server, an idempotent database-initialization
service, the Catalog service, the Shopping service, and the static UI served by
Nginx. The UI is not a third application service; it is the same static content
that will later be uploaded to Azure Storage static website hosting.

Create local-only database credentials from the example file:

```bash
cp .env.example .env
```

Do not commit `.env`. On Apple Silicon, enable Rosetta emulation in Docker
Desktop because the SQL Server image is published for `linux/amd64`.

Start the complete stack:

```bash
docker compose up --build
```

The local endpoints are:

- UI: <http://localhost:8080>
- Catalog API: <http://localhost:8001>
- Shopping API: <http://localhost:8002>
- Catalog health: <http://localhost:8001/health>
- Shopping health: <http://localhost:8002/health>

The `init-db` Compose service creates `catalog_db`, `shopping_db`, and their
separate logins by running `db/init.sql`. The script is idempotent. The
application services then run their own versioned migrations. SQL Server data
is kept in the `mssql-data` Docker volume, so restarting the stack does not
reseed or recreate the databases.

To test the cross-service failure behavior, stop Catalog while the rest of the
stack is running:

```bash
docker compose stop catalog
```

Shopping continues to serve its own `/health` endpoint, while a shopping-list
request returns a controlled service-unavailable response because its Catalog
HTTP call cannot complete. Restart Catalog with:

```bash
docker compose start catalog
```

Stop the stack when finished:

```bash
docker compose down
```

## Assignment 2 service tests

The Assignment 2 coverage and test results come only from the new split-service
tests. They are kept with their respective services:

- `services/catalog/tests/` tests the Catalog service logic.
- `services/shopping/tests/test_services.py` tests Shopping service logic.
- `services/shopping/tests/test_cross_seam_integration.py` tests Shopping calling
  Catalog over HTTP.

The original `tests/` directory is retained temporarily as Assignment 1
regression coverage. It tests the old monolith and SQLite implementation, is
not included in the Assignment 2 service coverage figures, and is planned for
deletion when the unused monolithic application is removed. It is run only to
confirm that the migration has not accidentally damaged the reference
implementation.

Run the split-service tests with:

```bash
DATABASE_URL='mssql+pymssql://test:test@localhost:1433/catalog_db' \
PYTHONPATH=services/catalog \
python -m pytest -q services/catalog/tests \
  --cov=app.catalog.services \
  --cov-report=term-missing \
  --cov-fail-under=70

DATABASE_URL='mssql+pymssql://test:test@localhost:1433/shopping_db' \
CATALOG_URL='http://127.0.0.1:9' \
PYTHONPATH=services/shopping \
python -m pytest -q services/shopping/tests \
  --cov=app.shopping.services \
  --cov-report=term-missing \
  --cov-fail-under=70
```

The service tests replace database connections with deterministic fakes. The
cross-seam integration test starts a local HTTP Catalog stub and verifies that
Shopping calls it over HTTP before using Shopping's own product database. It
does not require Azure or a live SQL Server.

## Run locally

Start the application from the repository root:

```bash
python app.py
```

The development server is available at <http://0.0.0.0:8000>. The port can be
changed with the `PORT` environment variable, for example:

```bash
PORT=8080 python app.py
```

On startup, the app creates the SQLite schema if it does not exist. If the
database has no recipes, it seeds the database from `data/recipes.json` and
`data/supermarket_products.csv`. The database is stored at `data/app.db`.

> **Warning:** Running `python -m app.seed` manually resets and repopulates the
> database. This removes existing database data before reseeding.

## Using the application

- Web interface: <http://0.0.0.0:8000/>
- Health check: <http://0.0.0.0:8000/health>
- Interactive API documentation: <http://0.0.0.0:8000/docs>

The shopping-list page uses the browser's local storage to retain the selected
recipes in that browser.

## API

The FastAPI documentation at `/docs` describes the request and response models.
The primary endpoints are:

| Method | Endpoint                   | Purpose                                                  |
| ------ | -------------------------- | -------------------------------------------------------- |
| `GET`  | `/api/recipes`             | List recipes; optionally filter with `?q=search-term`.   |
| `GET`  | `/api/recipes/{recipe_id}` | Get recipe details; optionally scale with `?servings=4`. |
| `POST` | `/api/shopping-list`       | Calculate aggregated ingredients and estimated prices.   |
| `GET`  | `/health`                  | Check application and database health.                   |

Example shopping-list request:

```json
{
  "recipes": [
    { "recipe_id": 1, "target_servings": 4 },
    { "recipe_id": 2, "target_servings": 2 }
  ]
}
```

## Data model

SQLite stores recipes and ingredients as a many-to-many relationship through
`recipe_ingredients`, which records the amount and unit used by each recipe.
`supermarket_products` associates product/package options and prices with shared
ingredient records. This lets the shopping-list logic aggregate requirements
across recipes and estimate the cost of purchasing whole packages.

The source data is in `data/recipes.json` and
`data/supermarket_products.csv`. Recipe images uploaded through the interface
are stored under `app/static/uploads/`.

## Automated business-logic tests

Tests focus on the catalog and shopping service logic rather than framework
routing. They cover recipe search, serving-size scaling, unit normalization,
ingredient aggregation, package selection, estimated pricing, and relevant
empty or invalid input cases. Database-dependent tests use a temporary SQLite
database.

Run tests and measure coverage with:

```bash
python -m pytest -q --cov=app.catalog.services --cov=app.shopping.services --cov-report=term-missing --cov-fail-under=70
```

Latest verified result: **17 passed**; **99.03% combined coverage** (catalog
service: **100%**, shopping service: **98%**). The command requires `pytest` and
`pytest-cov`, both listed in `requirements.txt`.

## Project layout

```text
Recipe-Website/
├── app.py
├── requirements.txt
├── ADR.md
├── AI_USAGE.md
├── README.md
├── assignment_1.md
├── data/
│   ├── supermarket_products.csv
│   ├── recipes.json
│   └── app.db
├── app/
│   ├── __init__.py
│   ├── config.py
│   ├── database.py
│   ├── seed.py
│   ├── main.py
│   ├── catalog/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── services.py
│   │   └── routes.py
│   ├── shopping/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── services.py
│   │   └── routes.py
│   ├── templates/
│   │   ├── base.html
│   │   ├── recipes.html
│   │   ├── recipe_detail.html
│   │   └── shopping_list.html
│   └── static/
│       ├── uploads/
│       └── style.css
└── tests/
    ├── __init__.py
    └── test_domain_services.py
```
