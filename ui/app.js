const config = window.APP_CONFIG || {};
const catalogUrl = (config.catalogUrl || "").replace(/\/$/, "");
const shoppingUrl = (config.shoppingUrl || "").replace(/\/$/, "");
const CART_KEY = "recipe_cart";

function getCart() {
  try {
    const cart = JSON.parse(localStorage.getItem(CART_KEY) || "[]");
    return Array.isArray(cart) ? cart : [];
  } catch (_error) { return []; }
}

function saveCart(cart) {
  localStorage.setItem(CART_KEY, JSON.stringify(cart));
  updateCartCount();
}

function updateCartCount() {
  const count = getCart().length;
  document.querySelectorAll("#cart-count").forEach((element) => { element.textContent = count ? `(${count})` : ""; });
}

function escapeHtml(value) {
  return String(value ?? "").replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#039;");
}

function formatAmount(value) {
  const number = Number(value);
  return Number.isInteger(number) ? String(number) : number.toFixed(2).replace(/0+$/, "").replace(/\.$/, "");
}

function formatUnit(unit) {
  return ["qty", "qty.", "count", "pcs", "piece", "pieces"].includes(String(unit || "").toLowerCase()) ? "" : unit || "";
}

function imageUrl(imagePath) {
  if (!imagePath) return "";
  if (/^https?:\/\//i.test(imagePath)) return imagePath;
  return `${catalogUrl}/${String(imagePath).replace(/^\//, "")}`;
}

function showMessage(elementId, message, kind = "error") {
  const element = document.getElementById(elementId);
  if (!element) return;
  element.className = `message ${kind}`;
  element.textContent = message;
}

async function requestJson(url, options = {}) {
  const response = await fetch(url, options);
  let body = null;
  try { body = await response.json(); } catch (_error) { /* status is still useful */ }
  if (!response.ok) {
    if (response.status === 503) {
      throw new Error("Service is starting up, please wait a moment and try again.");
    }
    throw new Error(body?.detail || `Request failed with status ${response.status}.`);
  }
  return body;
}

function addRecipe(recipeId, servings) {
  const amount = Number.parseInt(servings, 10);
  if (!Number.isInteger(amount) || amount <= 0) return;
  const cart = getCart();
  const existing = cart.find((item) => item.id === recipeId);
  if (existing) existing.servings = amount;
  else cart.push({ id: recipeId, servings: amount });
  saveCart(cart);
  showMessage("catalog-message", "Recipe added to your shopping list.", "success");
}

async function loadCatalog() {
  const searchForm = document.getElementById("search-form");
  const searchInput = document.getElementById("search-input");
  const grid = document.getElementById("recipe-grid");

  async function render() {
    const query = searchInput.value.trim();
    const url = `${catalogUrl}/recipes${query ? `?q=${encodeURIComponent(query)}` : ""}`;
    try {
      const recipes = await requestJson(url);
      grid.innerHTML = recipes.length ? recipes.map((recipe) => `
        <article class="recipe-card"><img class="recipe-image" src="${escapeHtml(imageUrl(recipe.image_url))}" alt="${escapeHtml(recipe.name)}" />
          <div class="card-content"><h2>${escapeHtml(recipe.name)}</h2><p>${escapeHtml(recipe.description || "Delicious homemade recipe.")}</p>
            <div class="recipe-meta"><span>${recipe.prep_time + recipe.cook_time} mins</span><span>${escapeHtml(recipe.difficulty)}</span><span>${recipe.servings} servings</span></div>
            <div class="card-actions"><a class="btn-secondary" href="recipe.html?id=${recipe.id}">View recipe</a><input class="servings-input" type="number" min="1" max="50" value="${recipe.servings}" aria-label="Servings for ${escapeHtml(recipe.name)}" /><button class="btn add-button" data-recipe-id="${recipe.id}">Add</button></div>
          </div>
        </article>`).join("") : "<p>No recipes found.</p>";
      grid.querySelectorAll(".add-button").forEach((button) => button.addEventListener("click", () => addRecipe(Number(button.dataset.recipeId), button.previousElementSibling.value)));
    } catch (error) { showMessage("catalog-message", `Catalog is unavailable: ${error.message}`); }
  }

  searchForm.addEventListener("submit", (event) => { event.preventDefault(); render(); });
  render();
}

async function loadRecipe() {
  const params = new URLSearchParams(window.location.search);
  const recipeId = params.get("id");
  const target = document.getElementById("recipe-detail");
  if (!recipeId) { showMessage("recipe-message", "No recipe was selected."); return; }
  try {
    const servings = params.get("servings");
    const suffix = servings ? `?servings=${encodeURIComponent(servings)}` : "";
    const recipe = await requestJson(`${catalogUrl}/recipes/${encodeURIComponent(recipeId)}${suffix}`);
    target.innerHTML = `<div class="detail-grid"><div><h1>${escapeHtml(recipe.name)}</h1><p class="lead">${escapeHtml(recipe.description || "")}</p><div class="recipe-meta"><span>Prep: ${recipe.prep_time} mins</span><span>Cook: ${recipe.cook_time} mins</span><span>${escapeHtml(recipe.difficulty)}</span></div><label for="detail-servings"><strong>Servings:</strong></label> <input id="detail-servings" class="servings-input" type="number" min="1" max="50" value="${recipe.servings}" /> <button id="scale-recipe" class="btn-secondary">Scale recipe</button> <button id="detail-add" class="btn">Add to shopping list</button></div><img class="detail-image" src="${escapeHtml(imageUrl(recipe.image_url))}" alt="${escapeHtml(recipe.name)}" /></div><div class="detail-sections"><section><h2>Ingredients</h2><ul class="ingredient-list">${recipe.ingredients.map((ingredient) => `<li>${formatAmount(ingredient.amount)} ${escapeHtml(formatUnit(ingredient.unit))} <strong>${escapeHtml(ingredient.name)}</strong></li>`).join("")}</ul></section><section><h2>Instructions</h2><ol>${recipe.steps.map((step) => `<li>${escapeHtml(step)}</li>`).join("")}</ol></section></div>`;
    document.getElementById("detail-add").addEventListener("click", () => addRecipe(Number(recipe.id), document.getElementById("detail-servings").value));
    document.getElementById("scale-recipe").addEventListener("click", () => { window.location.href = `recipe.html?id=${recipe.id}&servings=${document.getElementById("detail-servings").value}`; });
  } catch (error) { showMessage("recipe-message", `Recipe could not be loaded: ${error.message}`); }
}

async function renderSelectedRecipes() {
  const target = document.getElementById("selected-recipes");
  const cart = getCart();
  if (!cart.length) { target.innerHTML = '<p>Your shopping list is empty. <a href="index.html">Browse the catalog</a> to add recipes.</p>'; return; }

  const namedCart = await Promise.all(cart.map(async (item) => {
    try {
      const recipe = await requestJson(`${catalogUrl}/recipes/${encodeURIComponent(item.id)}`);
      return { ...item, name: recipe.name };
    } catch (_error) {
      return { ...item, name: `Recipe #${item.id}` };
    }
  }));

  target.innerHTML = `<h2>Selected recipes</h2><div class="selected-list">${namedCart.map((item) => `<div class="selected-item"><span>${escapeHtml(item.name)}</span><label>Servings <input class="servings-input selected-servings" data-id="${item.id}" type="number" min="1" max="50" value="${item.servings}" /></label><button class="link-button remove-recipe" data-id="${item.id}">Remove</button></div>`).join("")}</div><button id="refresh-shopping" class="btn">Update shopping list</button>`;
  target.querySelectorAll(".remove-recipe").forEach((button) => button.addEventListener("click", () => { saveCart(cart.filter((item) => item.id !== Number(button.dataset.id))); renderSelectedRecipes(); loadShoppingResults(); }));
  document.getElementById("refresh-shopping").addEventListener("click", () => { saveCart([...target.querySelectorAll(".selected-servings")].map((input) => ({ id: Number(input.dataset.id), servings: Number(input.value) }))); loadShoppingResults(); });
}

async function loadShoppingResults() {
  const target = document.getElementById("shopping-results");
  const cart = getCart();
  if (!cart.length) { target.innerHTML = ""; return; }
  try {
    const result = await requestJson(`${shoppingUrl}/shopping-list`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ recipes: cart.map((item) => ({ recipe_id: item.id, target_servings: item.servings })) }) });
    target.innerHTML = `<h2>Required supermarket products</h2><div class="table-wrapper"><table><thead><tr><th>Category</th><th>Ingredient</th><th>Needed</th><th>Product</th><th>Packages</th><th>Estimated cost</th></tr></thead><tbody>${result.items.map((item) => `<tr><td>${escapeHtml(item.category || "General")}</td><td><strong>${escapeHtml(item.ingredient_name)}</strong></td><td>${formatAmount(item.total_amount)} ${escapeHtml(formatUnit(item.unit))}</td><td>${escapeHtml(item.suggested_product_name || "N/A")}</td><td>${item.packages_needed}</td><td>€${Number(item.estimated_price).toFixed(2)}</td></tr>`).join("")}</tbody></table></div><p class="total-box">Total estimated cost: <strong>€${Number(result.total_estimated_cost).toFixed(2)}</strong></p>`;
  } catch (error) { showMessage("shopping-message", `Shopping service is unavailable: ${error.message}`); }
}

document.addEventListener("DOMContentLoaded", () => {
  updateCartCount();
  const page = document.body.dataset.page;
  if (page === "catalog") loadCatalog();
  if (page === "recipe") loadRecipe();
  if (page === "shopping") { renderSelectedRecipes(); loadShoppingResults(); }
});
