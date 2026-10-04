## 1. Choice of Python, FastAPI, and Server-Side HTML

Date: 2026-09-25
Status: Decided
Context: The assignment requires a minimal single-process, single-container application running on SQLite with low operational complexity. I needed a stack that handles HTTP routing, data processing, and user interfaces without requiring separate background processes or complex build pipelines.
Decision: I selected Python with FastAPI for the backend API/routing and Jinja2 templates for server-side HTML rendering.
Alternatives considered: I considered Django for its features and because I used it last year, but rejected this decision because it was unnecessarily complex for a simple single-container app. I also considered using Java or Node.js but chose Python since i have more experience with it and prefered the straightforward data manipulation logic for ingredient unit conversions.
Consequences: This keeps third-party dependencies under the 12-package soft cap and ensures fast execution in a single container. However, server-side template rendering requires full page reloads for UI updates unless lightweight JavaScript is added later.

## 2. Domain Scoping & Modular Seams

Date: 2026-09-29
Status: Decided
Context: The application needs to separate recipe management from shopping list generation and pricing logic to maintain clear architectural boundaries and testability.
Decision: I created modular files inside the "catalog" folder and "shopping" folder, isolating domain queries and ingredient scaling calculations within service modules like "services.py"
Alternatives considered: Placing all route handlers and database queries inside a monolithic "main.py" file, this was rejected because it would make the code messy and hard to maintain/read.
Consequences: Improves maintainability, allows domain logic unit testing without external HTTP runtime overhead, and simplifies future domain expansion as well as adding new features.

## 3. Database Schema & Shopping List Pricing Calculation

Date: 2026-09-30
Status: Decided
Context: The catalog stores recipe details and ingredient quantities, while the shopping domain combines requirements across recipes and matches them to supermarket products to estimate checkout costs. The data model needs to represent these relationships without duplicating ingredient records.
Decision: In SQLite, I modeled recipes and ingredients as a many-to-many relationship through the "recipe_ingredients" junction table, which stores each recipe's amount and unit for an ingredient. Both domains share the "ingredients" table, "recipe_ingredients" links ingredients to recipes, while "supermarket_products" links one or more product and package-price options to an ingredient. For shopping calculations, I normalize the different units to base units (kg to g and L to ml) before aggregation, then round required quantities up to whole packages when estimating cost.
Alternatives considered: Duplicating ingredient names and details inside each recipe would make cross-recipe aggregation and product matching less reliable. Storing only one supermarket product directly on each ingredient would prevent an ingredient from having multiple product options. I also considered calculating fractional package costs (e.g., paying for half a carton of milk or 3 eggs), but that does not what would happen in real life. I also considered using DIV and MOD, but rejected in favor of the clearer package-ceiling calculation. I also considered adding a table with ingredients you already have but decided to finish the core app before adding new features.
Consequences: The shared ingredient records provide a consistent join point between both domains, while the junction table supports recipe-specific quantities and units. Multiple product records per ingredient allow the shopping logic to select the lowest-priced option and calculate whole packages needed, producing more realistic estimated costs.

## 4. Core Business-Logic Test Coverage

Date: 2026-10-03
Status: Decided
Context: The assignment requires automated tests for the core business logic of both domains and at least 70% coverage measured with a standard coverage tool. The catalog domain handles recipe search and serving-size scaling, while the shopping domain normalizes and aggregates ingredient quantities and estimates package-based prices.
Decision: I used pytest and pytest-cov to test the catalog and shopping service modules directly. Tests prioritize the main domain behaviors and meaningful branches, including title and ingredient search, valid and invalid serving targets, unit conversions, aggregation across recipes, package rounding, missing products, and empty or invalid selections. Test data is loaded into a temporary SQLite database so service behavior is exercised without depending on the application database.
Alternatives considered: I considered prioritizing HTTP endpoint and template tests, but those would have focused on framework integration rather than the requested actual logic.
Consequences: The measured combined coverage of the two service modules is 99.03% (catalog: 100%; shopping: 98%). Routing, templates, and some infrastructure behavior such as database initialization are covered more lightly because they are not the core business logic. The exact pytest-cov command and measured result are recorded in the README (as well as instructions to run the tests)

## 5. One thing you deliberately chose not to build and why - Home Inventory Tracking

Date: 2026-10-03
Status: Decided
Context: A shopping list could be more useful if it accounted for ingredients the user already has at home. This would require tracking household inventory and comparing it with the quantities needed for selected recipes.
Decision: I chose not to build a fridge inventory feature in this version. The application generates a shopping list from recipe requirements without subtracting items the user already owns. It does take into account if multiple recipes have the same ingredients
Alternatives considered: I considered adding a list of items already at home and reducing the shopping quantities accordingly. I also considered supporting inventory amounts and units, but that would require additional tracking and matching behavior beyond generating a recipe-based shopping list. Another feature that can be added later on is editing and creating new recipes.
Consequences: The application remains focused on recipe based shopping list generation and package/product cost calculations, with less data entry and complexity. Users may see items on the list that they already have and inventory tracking can be added later as a separate feature.
