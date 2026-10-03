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

By default, the database is stored at `data/app.db`. You can override the directory using the `DATA_DIR` environment variable, for example:

```bash
DATA_DIR=/custom/path python app.py
```

> **Warning:** Running `python -m app.seed` manually resets and repopulates the
> database. This removes existing database data before reseeding.

## Using the application

- Web interface: <http://localhost:8000/>
- Health check: <http://localhost:8000/health>
- Interactive API documentation: <http://localhost:8000/docs>

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
