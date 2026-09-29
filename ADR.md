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
