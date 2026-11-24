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

## OpenAPI and CI

The service contracts are committed as generated OpenAPI 3.1 documents:

- `services/catalog/openapi.yaml`
- `services/shopping/openapi.yaml`

The root `system.yaml` describes the UI, service paths, environment variables,
cross-service call, and planned Azure resources. It is validated against
`system.schema.json` together with both OpenAPI documents.

Generate the service documents locally with:

```bash
DATABASE_URL='mssql+pymssql://user:pass@localhost:1433/catalog_db' \
  PYTHONPATH=services/catalog python scripts/generate_openapi.py catalog
DATABASE_URL='mssql+pymssql://user:pass@localhost:1433/shopping_db' \
  PYTHONPATH=services/shopping python scripts/generate_openapi.py shopping
```

The GitHub Actions workflow in `.github/workflows/ci.yml` runs on pushes and
pull requests. It lints Python sources, validates the generated specifications,
initializes a SQL Server service container and runs migration/health smoke
checks, runs both service suites with separate 70% coverage gates, and builds
both Docker images.

## Azure infrastructure setup

Azure resources must be created in the Azure for Students subscription and in
one of that subscription's allowed regions. The current subscription policy
allows `switzerlandnorth`, `swedencentral`, `germanywestcentral`,
`francecentral`, and `italynorth`. The selected region is `francecentral`, the
closest allowed region to Spain and therefore the expected lowest-latency option
for this deployment. Use it consistently.

The Azure CLI on macOS can be selected explicitly with:

```bash
export PATH="/opt/homebrew/bin:$PATH"
az version
```

### Set local deployment variables

Replace `YOUR_AZURE_SUBSCRIPTION_ID` locally with the subscription ID shown by
`az account list`; do not commit the real value:

```bash
export AZ_SUBSCRIPTION_ID="YOUR_AZURE_SUBSCRIPTION_ID"
export AZ_REGION="francecentral"
export AZ_PREFIX="ndgrass-ieu2024"
export AZ_RESOURCE_GROUP="rg-ndgrass-ieu2024"
export AZ_STORAGE_ACCOUNT="ndgrassieu2024ui"
export AZ_SQL_SERVER="ndgrass-ieu2024-sql"
export AZ_CONTAINER_ENV="ndgrass-ieu2024-env"
export AZ_IDENTITY="ndgrass-ieu2024-github"
```

### Sign in and select the subscription

```bash
az login --use-device-code
az account list -o table
az account set --subscription "$AZ_SUBSCRIPTION_ID"
az account show -o table
```

### Confirm the allowed region

```bash
az account list-locations --query "[].{name:name,displayName:displayName}" -o table
az policy assignment list \
  --scope "/subscriptions/$AZ_SUBSCRIPTION_ID" \
  --query "[].{name:displayName,scope:scope,parameters:parameters}" -o json
```

### Register providers and create the resource group

```bash
az account set --subscription "$AZ_SUBSCRIPTION_ID"
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Sql
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.ManagedIdentity
```

Create the assignment resource group:

```bash
az group create --name "$AZ_RESOURCE_GROUP" --location "$AZ_REGION"
```

Create the StorageV2 account for the static UI and enable static website
hosting:

```bash
az storage account create \
  --name "$AZ_STORAGE_ACCOUNT" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --location "$AZ_REGION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --https-only true \
  --min-tls-version TLS1_2
az storage blob service-properties update \
  --account-name "$AZ_STORAGE_ACCOUNT" \
  --auth-mode login \
  --static-website \
  --index-document index.html \
  --404-document index.html
az storage account show \
  --name "$AZ_STORAGE_ACCOUNT" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --query "{name:name,location:primaryLocation,webEndpoint:primaryEndpoints.web}" \
  -o table
```

The SQL server creation command is documented separately because its
administrator password must be supplied interactively and must never be written
to this repository. Run these commands one at a time in your own terminal.

1. Start a hidden password prompt:

```zsh
read -r -s "SQL_ADMIN_PASSWORD?SQL administrator password: "
```

2. When the prompt appears, type your SQL administrator password and press
   **Enter**. Nothing will appear while you type. Do not add a trailing `\` to
   the command. Do not send this password in chat or put it in a file. Azure requires a strong password; do not use
   `sqladmin` or the server name inside it.

3. Move to a new terminal line:

```bash
echo
```

4. Create the logical SQL server. This command reads the password from the
   temporary shell variable; it does not print the password:

```bash
az sql server create --name "$AZ_SQL_SERVER" --resource-group "$AZ_RESOURCE_GROUP" --location "$AZ_REGION" --admin-user sqladmin --admin-password "$SQL_ADMIN_PASSWORD"
```

5. Remove the password from the current shell after the command succeeds:

```bash
unset SQL_ADMIN_PASSWORD
```

Create the two serverless General Purpose Gen5 databases on the logical server.
The Azure SQL free offer allows the free limit on one database per subscription;
the second database remains serverless with the same 0.5-1 vCore bounds and
locally redundant backups:

```bash
az sql db create \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --server "$AZ_SQL_SERVER" \
  --name "${AZ_PREFIX}-catalog-db" \
  --edition GeneralPurpose \
  --family Gen5 \
  --capacity 1 \
  --compute-model Serverless \
  --min-capacity 0.5 \
  --auto-pause-delay 60 \
  --backup-storage-redundancy Local \
  --max-size 32GB \
  --use-free-limit \
  --free-limit-exhaustion-behavior AutoPause
az sql db create \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --server "$AZ_SQL_SERVER" \
  --name "${AZ_PREFIX}-shopping-db" \
  --edition GeneralPurpose \
  --family Gen5 \
  --capacity 1 \
  --compute-model Serverless \
  --min-capacity 0.5 \
  --auto-pause-delay 60 \
  --backup-storage-redundancy Local \
  --max-size 32GB
```

Allow Azure services to reach the SQL server. Add a temporary personal IP
firewall rule only when administering the database, then remove it afterwards:

```bash
az sql server firewall-rule create \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --server "$AZ_SQL_SERVER" \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

For local SQL administration, temporarily allow your current public IP and
remove this rule immediately after creating the service logins:

```zsh
export AZ_ADMIN_IP="$(curl -s https://api.ipify.org)"
az sql server firewall-rule create \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --server "$AZ_SQL_SERVER" \
  --name TemporaryAdminIP \
  --start-ip-address "$AZ_ADMIN_IP" \
  --end-ip-address "$AZ_ADMIN_IP"
```

Create one SQL login per service. Use the hidden prompts below and do not send
any of these passwords in chat. Avoid apostrophes in the two service passwords
because they are inserted into SQL string literals:

```zsh
read -r -s "SQL_ADMIN_PASSWORD?SQL administrator password: "
echo
read -r -s "CATALOG_DB_PASSWORD?Catalog database password: "
echo
read -r -s "SHOPPING_DB_PASSWORD?Shopping database password: "
echo
```

Create the two server-level logins while connected to `master`. The database
users are created in separate connections because Azure SQL Database does not
support switching databases with `USE` in one connection:

```zsh
cat <<'SQL' | docker run --platform linux/amd64 --rm -i \
  --entrypoint /opt/mssql-tools18/bin/sqlcmd \
  mcr.microsoft.com/mssql/server:2022-latest \
  -S "${AZ_SQL_SERVER}.database.windows.net" \
  -d master \
  -U sqladmin \
  -P "$SQL_ADMIN_PASSWORD" \
  -C -b \
  -v CATALOG_DB_PASSWORD="$CATALOG_DB_PASSWORD" \
     SHOPPING_DB_PASSWORD="$SHOPPING_DB_PASSWORD" \
  -i /dev/stdin
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'catalog_user')
BEGIN
    CREATE LOGIN [catalog_user] WITH PASSWORD = '$(CATALOG_DB_PASSWORD)';
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'shopping_user')
BEGIN
    CREATE LOGIN [shopping_user] WITH PASSWORD = '$(SHOPPING_DB_PASSWORD)';
END
GO
SQL
```

Create the Catalog database user with a new connection:

```zsh
cat <<'SQL' | docker run --platform linux/amd64 --rm -i \
  --entrypoint /opt/mssql-tools18/bin/sqlcmd \
  mcr.microsoft.com/mssql/server:2022-latest \
  -S "${AZ_SQL_SERVER}.database.windows.net" \
  -d "ndgrass-ieu2024-catalog-db" \
  -U sqladmin \
  -P "$SQL_ADMIN_PASSWORD" \
  -C -b \
  -i /dev/stdin
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'catalog_user')
    CREATE USER [catalog_user] FOR LOGIN [catalog_user];
IF IS_ROLEMEMBER(N'db_datareader', N'catalog_user') <> 1 ALTER ROLE db_datareader ADD MEMBER [catalog_user];
IF IS_ROLEMEMBER(N'db_datawriter', N'catalog_user') <> 1 ALTER ROLE db_datawriter ADD MEMBER [catalog_user];
IF IS_ROLEMEMBER(N'db_ddladmin', N'catalog_user') <> 1 ALTER ROLE db_ddladmin ADD MEMBER [catalog_user];
GO
SQL
```

Create the Shopping database user with a new connection:

```zsh
cat <<'SQL' | docker run --platform linux/amd64 --rm -i \
  --entrypoint /opt/mssql-tools18/bin/sqlcmd \
  mcr.microsoft.com/mssql/server:2022-latest \
  -S "${AZ_SQL_SERVER}.database.windows.net" \
  -d "ndgrass-ieu2024-shopping-db" \
  -U sqladmin \
  -P "$SQL_ADMIN_PASSWORD" \
  -C -b \
  -i /dev/stdin
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'shopping_user')
    CREATE USER [shopping_user] FOR LOGIN [shopping_user];
IF IS_ROLEMEMBER(N'db_datareader', N'shopping_user') <> 1 ALTER ROLE db_datareader ADD MEMBER [shopping_user];
IF IS_ROLEMEMBER(N'db_datawriter', N'shopping_user') <> 1 ALTER ROLE db_datawriter ADD MEMBER [shopping_user];
IF IS_ROLEMEMBER(N'db_ddladmin', N'shopping_user') <> 1 ALTER ROLE db_ddladmin ADD MEMBER [shopping_user];
GO
SQL
```

Delete the temporary firewall rule after all three commands succeed:

```zsh
az sql server firewall-rule delete \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --server "$AZ_SQL_SERVER" \
  --name TemporaryAdminIP
```

Then clear the password variables:

```zsh
unset SQL_ADMIN_PASSWORD CATALOG_DB_PASSWORD SHOPPING_DB_PASSWORD AZ_ADMIN_IP
```

Create the Consumption-plan Container Apps environment. Azure creates the
associated Log Analytics workspace as part of this operation:

```bash
az containerapp env create \
  --name "$AZ_CONTAINER_ENV" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --location "$AZ_REGION" \
  --enable-workload-profiles false
```

Create the user-assigned managed identity used by GitHub Actions, grant it
Contributor only on this resource group, and trust only the `main` branch of
this repository through OpenID Connect:

```bash
az identity create \
  --name "$AZ_IDENTITY" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --location "$AZ_REGION"
AZ_IDENTITY_CLIENT_ID="$(az identity show --name "$AZ_IDENTITY" --resource-group "$AZ_RESOURCE_GROUP" --query clientId -o tsv)"
AZ_IDENTITY_PRINCIPAL_ID="$(az identity show --name "$AZ_IDENTITY" --resource-group "$AZ_RESOURCE_GROUP" --query principalId -o tsv)"
az role assignment create \
  --assignee-object-id "$AZ_IDENTITY_PRINCIPAL_ID" \
  --assignee-principal-type ServicePrincipal \
  --role Contributor \
  --scope "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_RESOURCE_GROUP"
az identity federated-credential create \
  --name github-main \
  --identity-name "$AZ_IDENTITY" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --issuer https://token.actions.githubusercontent.com \
  --subject repo:nicolas-gls/Recipe-Website:ref:refs/heads/main \
  --audiences api://AzureADTokenExchange
```

### GitHub Actions deployment secrets

The CD workflow uses GitHub OIDC and does not store an Azure password. Add
these repository secrets after authenticating the GitHub CLI. The commands pipe
values directly into GitHub and do not place them in the repository:

```zsh
gh auth login
az identity show \
  --name "$AZ_IDENTITY" \
  --resource-group "$AZ_RESOURCE_GROUP" \
  --query clientId -o tsv | gh secret set AZURE_CLIENT_ID --repo nicolas-gls/Recipe-Website
az account show --query tenantId -o tsv | gh secret set AZURE_TENANT_ID --repo nicolas-gls/Recipe-Website
printf '%s' "$AZ_SUBSCRIPTION_ID" | gh secret set AZURE_SUBSCRIPTION_ID --repo nicolas-gls/Recipe-Website
```

After creating the `catalog_user` and `shopping_user` logins, enter those same
service passwords again through hidden prompts and store them as repository
secrets:

```zsh
read -r -s "CATALOG_DB_PASSWORD?Catalog database password: "
echo
printf '%s' "$CATALOG_DB_PASSWORD" | gh secret set CATALOG_DB_PASSWORD --repo nicolas-gls/Recipe-Website
unset CATALOG_DB_PASSWORD
read -r -s "SHOPPING_DB_PASSWORD?Shopping database password: "
echo
printf '%s' "$SHOPPING_DB_PASSWORD" | gh secret set SHOPPING_DB_PASSWORD --repo nicolas-gls/Recipe-Website
unset SHOPPING_DB_PASSWORD
```

The CD workflow in `.github/workflows/cd.yml` builds SHA-tagged `linux/amd64`
images, pushes them to GHCR, signs in to Azure through OIDC, deploys each
Container Apps revision with database URLs stored as Container Apps secrets,
probes the revision health endpoints, switches 100% traffic only after a
successful probe, generates `ui/config.js`, uploads the static UI, and runs
post-deployment health checks. GHCR packages must be public so Azure can pull
the images without storing registry credentials in Container Apps.

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
