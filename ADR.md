## 1. Choice of Python, FastAPI, and Server-Side HTML

Date: 2026-09-25
Status: Decided
Context: The assignment constraints require a minimal single-process, single-container application running on SQLite with low operational complexity. I needed a stack that handles HTTP routing, data processing, and user interfaces without requiring separate background processes or complex build pipelines.
Decision: I selected Python with FastAPI for the backend API/routing and Jinja2 templates for server-side HTML rendering.
Alternatives considered: I considered Django for its battery-included features and because i used it last year, but rejected it because it was unnecessarily complex for a simple single-container app. I also considered using Java or Node.js but chose Python since i have more experience with it and prefered the straightforward data manipulation logic for ingredient unit conversions.
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
Context: Generating a combined shopping list across multiple recipes requires normalizing units (ensuring all of the ingredients are in the same units), aggregating required quantities (how many servings and recipes use the ingredient), and mapping ingredients to store packages to calculate realistic estimated costs.
Decision: I standardized recipe units to base units (g, ml, count) and calculated store purchase requirements using package ceiling logic which forces the code to round up to the nearest whole container (or product)
Alternatives considered: Calculating linear fractional costs per unit (e.g., paying for half a carton of milk or 3 eggs), which does not accurately reflect retail supermarket checkout costs. Additionally I considered using DIV and MOD however I rejected this option as it can make readability worse, and can introduce floating point precision issues (when using non integer quantities). I also considered adding a table with ingredients you already have but decided to finish the core app before adding new features.
Consequences: Delivers accurate real-world cost estimation where full packages must be purchased while seamlessly aggregating ingredient requirements across recipes.
