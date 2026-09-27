## 1. Choice of Python, FastAPI, and Server-Side HTML

Date: 2026-09-25
Status: Decided
Context: The assignment constraints require a minimal single-process, single-container application running on SQLite with low operational complexity. I needed a stack that handles HTTP routing, data processing, and user interfaces without requiring separate background processes or complex build pipelines.
Decision: I selected Python with FastAPI for the backend API/routing and Jinja2 templates for server-side HTML rendering.
Alternatives considered: I considered Django for its battery-included features and because i used it last year, but rejected it because it was unnecessarily complex for a simple single-container app. I also considered using Java or Node.js but chose Python since i have more experience with it and prefered the straightforward data manipulation logic for ingredient unit conversions.
Consequences: This keeps third-party dependencies under the 12-package soft cap and ensures fast execution in a single container. However, server-side template rendering requires full page reloads for UI updates unless lightweight JavaScript is added later.
