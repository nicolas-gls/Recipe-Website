| Date/commit | Tool | Prompt | Disposition (Accepted/Modified/Rejected) | What changed & why (if modified) | In my own words, how this works |
|2026-09-25|Gemini|Create a dataset (.csv) for supermarket products with the following columns:

Name (for example water bottle, milk, chicken breast, white sugar, chocolate chips, baking soda, eggs)

Amount (for example 1L, 100g, 6 or 12 (for eggs), 1kg etc)

Price (the price of each product)

I need this dataset to create a recipe and shopping list generator, add all of the typical food products that you will find in a supermarket. |Modified|I later asked it to add new food|This provides me with a data base that i can use for my ingredients and recipes|

|2026-09-25|Gemini|make a list of more products that are missing from typicall recipes and supermarkets, after add it to the original databse file|Accepted|Now it added a lot more products|This is now a list of aprox 150 ingredients that i can mix to make new recipes|

|2026-09-27|Gemini|The gitignore file in my project already has the following code, what else is missing for my project|Accepted|It added 2 extra lines since the code currently runs locally the repo doesn't need local database files|Git will start tracking local database files which it shouldn't|

|2026-09-28|Gemini|I have a database of 146 supermarket ingredients. I need 50 realistic recipes formatted as a single JSON array of objects.

STRICT INGREDIENT CONSTRAINT:
Every ingredient in the "ingredients" array MUST use an exact lowercase string from this list of valid ingredient names:
['active dry yeast', 'all-purpose flour', 'apple cider vinegar', 'apple juice', 'apples', 'avocados', 'bacon strips', 'baking powder', 'baking soda', 'balsamic vinegar', 'bananas', 'basmati rice', 'beef broth', 'beef steak', 'bell peppers', 'black tea bags', 'bottled mineral water', 'bottled water', 'bread flour', 'breadcrumbs', 'broccoli', 'brown rice', 'brown sugar', 'butter croissants', 'buttermilk', 'button mushrooms', 'canned black beans', 'canned cannellini beans', 'canned chickpeas', 'canned kidney beans', 'canned tuna in oil', 'carrots', 'cayenne pepper', 'celery', 'cheddar cheese block', 'chicken breast', 'chicken broth', 'chicken thighs', 'coconut milk', 'coconut oil', 'cod / white fish fillets', 'cornstarch', 'cottage cheese', 'cream cheese', 'cucumbers', 'dark chocolate bar', 'diced tomatoes', 'dijon mustard', 'dried oregano', 'dried rosemary', 'dried thyme', 'extra virgin olive oil', 'feta cheese', 'fine table salt', 'flour tortillas', 'fresh basil', 'fresh cilantro', 'fresh flat-leaf parsley', 'fresh ginger', 'fresh salmon fillet', 'fresh spinach', 'frozen chopped spinach', 'frozen green peas', 'frozen mixed berries', 'frozen mixed vegetables', 'frozen pizza', 'frozen sweet corn', 'garlic', 'garlic powder', 'greek yogurt', 'green onions', 'ground beef', 'ground black pepper', 'ground cinnamon', 'ground cumin', 'ground turkey', 'ground turmeric', 'half-and-half', 'hamburger buns', 'heavy cream', 'hot sauce', 'jalapeño peppers', 'jasmine rice', 'kosher salt', 'large eggs', 'lemons', 'limes', 'maple syrup', 'marinara pasta sauce', 'mayonnaise', 'onion powder', 'orange juice', 'paprika', 'parmesan cheese', 'peanut butter', 'penne pasta', 'pork chops', 'pork sausages', 'pork tenderloin', 'potato chips', 'powdered sugar', 'pure honey', 'raw frozen shrimp', 'red onions', 'red pepper flakes', 'red wine vinegar', 'ricotta cheese', 'rolled oats', 'russet potatoes', 'salted butter', 'sandwich bread', 'semisweet chocolate chips', 'sesame oil', 'shredded mozzarella', 'skim milk', 'smoked paprika', 'sour cream', 'soy sauce', 'spaghetti', 'sparkling water', 'strawberries', 'strawberry jam', 'sweet potatoes', 'tomato ketchup', 'tomato paste', 'tomatoes', 'tortilla chips', 'turkey breast slices', 'unsalted butter', 'unsweetened cocoa powder', 'vanilla extract', 'vanilla ice cream', 'vegetable broth', 'vegetable oil', 'walnut halves', 'white rice', 'white sugar', 'white vinegar', 'whole almonds', 'whole coffee beans', 'whole milk', 'whole wheat bread', 'worcestershire sauce', 'yellow mustard', 'yellow onions', 'zucchini']

UNIT CONVENTIONS TO USE:

- Liquids: "ml"
- Weights & Dry Spices: "g"
- Counts / Cloves: "count", "qty", or "cloves"
- Herbs / Celery: "bunch" or "stalk"

JSON SCHEMA FORMAT:
[
{
"name": "Recipe Name",
"description": "Short description",
"prep_time": 15,
"cook_time": 20,
"difficulty": "Easy",
"servings": 4,
"steps": [
"Step 1...",
"Step 2..."
],
"ingredients": [
{ "name": "spaghetti", "amount": 400, "unit": "g" },
{ "name": "ground beef", "amount": 500, "unit": "g" }
]
}
]

Generate all 50 complete recipes in valid JSON format. Output ONLY raw valid JSON.|Accepted|---|This creates a .json with all of the recipes i will use. i will then write code to divide the information into different relational tables|

|2026-09-30|Gemini|Can I use MOD and DIV instead of the package ceiling logic|Rejected|After writing the code with the current package ceiling logic I considered using MOD and DIV, however it could have potentially caused problems|N/A|

|---|---|---|---|---|---|

|---|---|---|---|---|---|
