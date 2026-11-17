
IF OBJECT_ID('dbo.recipes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.recipes (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX) NULL,
        prep_time INT NULL,
        cook_time INT NULL,
        difficulty NVARCHAR(50) NULL,
        servings INT NULL,
        steps NVARCHAR(MAX) NULL,
        image_url NVARCHAR(2048) NULL
    );
END;



IF OBJECT_ID('dbo.ingredients', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ingredients (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        category NVARCHAR(100) NULL,
        CONSTRAINT UQ_ingredients_name UNIQUE (name)
    );
END;



IF OBJECT_ID('dbo.recipe_ingredients', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.recipe_ingredients (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        recipe_id INT NOT NULL,
        ingredient_id INT NOT NULL,
        amount FLOAT NOT NULL,
        unit NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_recipe_ingredients_recipes
            FOREIGN KEY (recipe_id)
            REFERENCES dbo.recipes(id)
            ON DELETE CASCADE,
        CONSTRAINT FK_recipe_ingredients_ingredients
            FOREIGN KEY (ingredient_id)
            REFERENCES dbo.ingredients(id)
            ON DELETE CASCADE
    );
END;


IF NOT EXISTS (SELECT 1 FROM dbo.recipes)

BEGIN

    SET IDENTITY_INSERT dbo.recipes ON;

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (1, N'Classic Spaghetti Bolognese', N'A rich and savory hearty beef pasta topped with shredded parmesan cheese.', 15, 30, N'Easy', 4, N'["Boil spaghetti in salted water according to package instructions.", "Heat extra virgin olive oil in a skillet and brown the ground beef over medium heat.", "Add diced yellow onions and minced garlic, cooking until translucent.", "Stir in tomato paste, diced tomatoes, dried oregano, fine table salt, and ground black pepper.", "Simmer for 20 minutes and serve over spaghetti topped with parmesan cheese."]', N'/static/uploads/recipe_1.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (2, N'Garlic Butter Pan-Seared Salmon', N'Crispy pan-seared fresh salmon fillets drizzled with garlic butter and lemon.', 10, 12, N'Easy', 2, N'["Season fresh salmon fillets with fine table salt and ground black pepper.", "Melt unsalted butter in a pan over medium-high heat.", "Sear salmon for 4 minutes on each side until golden.", "Add minced garlic, fresh flat-leaf parsley, and fresh lemon juice to pan and spoon butter glaze over salmon."]', N'/static/uploads/recipe_2.jpeg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (3, N'Beef and Broccoli Stir-Fry', N'Tender beef steak strips sautéed with fresh broccoli florets in a savory soy glaze.', 15, 10, N'Medium', 3, N'["Slice beef steak into thin strips.", "Whisk soy sauce, brown sugar, cornstarch, minced garlic, and fresh ginger together.", "Heat vegetable oil in a wok and sear beef strips; remove and set aside.", "Stir-fry broccoli florets until tender-crisp, return beef to pan, pour sauce, and toss until thickened.", "Drizzle with sesame oil before serving."]', N'/static/uploads/recipe_3.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (4, N'Chicken Fried Rice', N'Quick weekday fried rice made with chicken breast, green peas, carrots, and egg.', 10, 15, N'Easy', 4, N'["Dice chicken breast and saut\u00e9 in sesame oil until fully cooked.", "Push chicken aside, scramble large eggs in the pan.", "Stir in carrots, frozen green peas, minced garlic, and cold cooked white rice.", "Pour in soy sauce and toss until everything is heated through.", "Garnish with chopped green onions."]', N'/static/uploads/recipe_4.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (5, N'Fresh Guacamole & Chips', N'Creamy avocado dip mixed with fresh lime juice, cilantro, and red onions.', 15, 0, N'Easy', 4, N'["Mash ripe avocados in a medium mixing bowl.", "Fold in finely diced red onions, jalape\u00f1o peppers, and fresh cilantro.", "Squeeze fresh lime juice over the mixture and sprinkle with kosher salt.", "Serve immediately with crisp tortilla chips."]', N'/static/uploads/recipe_5.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (6, N'Fluffy Butter Pancakes', N'Golden stack of classic homemade pancakes served with sweet maple syrup.', 10, 15, N'Easy', 4, N'["Whisk all-purpose flour, baking powder, fine table salt, and white sugar in a bowl.", "Combine whole milk, large eggs, and melted unsalted butter in a separate jug.", "Pour wet ingredients into dry and gently fold together.", "Ladle batter onto a buttered skillet over medium heat until bubbles form, then flip.", "Serve warm topped with butter and maple syrup."]', N'/static/uploads/recipe_6.jpeg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (7, N'Classic Cinnamon French Toast', N'Thick slices of sandwich bread dipped in spiced egg custard and golden pan-fried.', 5, 10, N'Easy', 2, N'["Whisk large eggs, whole milk, ground cinnamon, and vanilla extract in a flat dish.", "Dip sandwich bread slices into the egg custard, coating both sides.", "Melt unsalted butter in a skillet and cook bread for 3 minutes per side until golden brown.", "Drizzle warm maple syrup on top."]', N'/static/uploads/recipe_7.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (8, N'Chickpea & Spinach Coconut Curry', N'A rich vegetarian chickpea curry simmered in coconut milk and warm spices.', 10, 20, N'Easy', 4, N'["Saut\u00e9 diced yellow onions, garlic, and fresh ginger in vegetable oil.", "Add ground cumin, ground turmeric, and cayenne pepper, stirring for 1 minute.", "Pour in canned chickpeas and coconut milk, simmer for 15 minutes.", "Fold in fresh spinach until wilted, season with fine table salt, and serve."]', N'/static/uploads/recipe_8.jpeg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (9, N'Creamy Tomato Basil Soup', N'Comforting velvety tomato soup infused with garlic and fresh basil.', 10, 25, N'Easy', 4, N'["Melt unsalted butter in a soup pot and saut\u00e9 yellow onions and garlic.", "Add diced tomatoes and vegetable broth, bring to a gentle boil.", "Simmer for 15 minutes, then blend until smooth.", "Stir in heavy cream and fresh basil, adjust seasoning with fine table salt and ground black pepper."]', N'/static/uploads/recipe_9.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (10, N'Loaded Beef Rice Bowl', N'Seasoned ground beef served over fluffy jasmine rice with black beans and corn.', 15, 20, N'Easy', 4, N'["Cook jasmine rice according to package directions.", "Brown ground beef with diced yellow onions, garlic powder, ground cumin, paprika, and fine table salt.", "Warm canned black beans and frozen sweet corn.", "Assemble bowls with rice, spiced beef, black beans, corn, bell peppers, sour cream, and grated cheddar cheese block."]', N'/static/uploads/recipe_10.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (11, N'Oven-Baked Seasoned Pork Chops', N'Juicy pork chops coated in a savory paprika and herb spice rub.', 10, 25, N'Easy', 4, N'["Preheat oven to 200\u00b0C.", "Mix garlic powder, onion powder, smoked paprika, dried thyme, fine table salt, and ground black pepper.", "Coat pork chops with extra virgin olive oil and rub spice mixture on both sides.", "Bake for 20-25 minutes until cooked through."]', N'/static/uploads/recipe_11.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (12, N'Roasted Rosemary Lemon Chicken Thighs', N'Crispy baked chicken thighs seasoned with garlic, dried rosemary, and lemon juice.', 10, 35, N'Easy', 4, N'["Preheat oven to 200\u00b0C.", "Toss chicken thighs with extra virgin olive oil, minced garlic, dried rosemary, dried thyme, kosher salt, and ground black pepper.", "Arrange lemon slices around chicken in a baking dish.", "Roast for 35 minutes until skin is crispy and internal temperature reaches 74\u00b0C."]', N'/static/uploads/recipe_12.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (13, N'Classic Bacon Cheeseburger', N'Juicy beef patties served on toasted buns with melted cheddar and crispy bacon.', 15, 10, N'Easy', 2, N'["Form ground beef into patties, season with fine table salt and ground black pepper.", "Fry bacon strips in a pan until crispy.", "Sear beef patties in the skillet for 4 minutes per side, placing slices of cheddar cheese block on top during the last minute.", "Assemble on hamburger buns with sliced tomatoes, sliced yellow onions, tomato ketchup, and yellow mustard."]', N'/static/uploads/recipe_13.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (14, N'Classic Greek Salad', N'Crisp cucumbers, juicy tomatoes, red onions, and feta cheese tossed in oregano olive oil.', 15, 0, N'Easy', 4, N'["Chop cucumbers, tomatoes, and red onions into thick chunks.", "Combine vegetables in a large bowl and add cubed feta cheese.", "Drizzle with extra virgin olive oil and red wine vinegar.", "Season with dried oregano and fine table salt before gently tossing."]', N'/static/uploads/recipe_14.jpeg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (15, N'Warm Berry & Honey Oatmeal', N'Hearty rolled oats cooked in milk, topped with berries, walnuts, and pure honey.', 5, 8, N'Easy', 2, N'["Simmer rolled oats and whole milk in a small saucepan over medium heat for 5 minutes.", "Stir in ground cinnamon.", "Divide oatmeal into bowls and top with warmed frozen mixed berries and walnut halves.", "Drizzle with pure honey."]', N'/static/uploads/recipe_15.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (16, N'Creamy Garlic Alfredo Penne', N'Penne pasta tossed in a velvety cream, butter, and parmesan garlic sauce.', 5, 15, N'Easy', 4, N'["Boil penne pasta in salted water until al dente.", "Melt unsalted butter in a pan and cook minced garlic for 1 minute.", "Pour in heavy cream and bring to a low boil.", "Stir in parmesan cheese until melted and smooth.", "Toss penne pasta into sauce and garnish with fresh flat-leaf parsley, fine table salt, and ground black pepper."]', N'/static/uploads/recipe_16.jpeg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (17, N'Sizzling Shrimp Fajitas', N'Seared shrimp cooked with colourful bell peppers, onions, and fajita spice.', 15, 10, N'Easy', 3, N'["Toss thawed raw frozen shrimp with paprika, ground cumin, and extra virgin olive oil.", "Saut\u00e9 sliced bell peppers and red onions until tender.", "Add shrimp to skillet and cook for 3-4 minutes until pink.", "Squeeze fresh lime juice over mixture and serve in warm flour tortillas."]', N'/static/uploads/recipe_17.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (18, N'Peanut Butter Banana Smoothie', N'Creamy blend of ripe bananas, greek yogurt, skim milk, and peanut butter.', 5, 0, N'Easy', 2, N'["Add bananas, greek yogurt, skim milk, peanut butter, and pure honey into a blender.", "Blend on high speed until completely smooth.", "Pour into glasses and serve cold."]', N'/static/uploads/recipe_18.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (19, N'Crispy Oven Roasted Potato Wedges', N'Golden crispy potato wedges seasoned with garlic powder and paprika.', 10, 30, N'Easy', 4, N'["Preheat oven to 220\u00b0C.", "Cut russet potatoes into wedges and toss with extra virgin olive oil.", "Season with paprika, garlic powder, fine table salt, and ground black pepper.", "Spread on baking sheet and roast for 30 minutes until golden and crispy."]', N'/static/uploads/recipe_19.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (20, N'Roasted Sweet Potato & Black Bean Bowl', N'Cubed roasted sweet potatoes paired with black beans, cilantro, and lime.', 15, 25, N'Easy', 3, N'["Cube sweet potatoes and toss with extra virgin olive oil, ground cumin, and salt.", "Roast at 200\u00b0C for 25 minutes.", "Warm canned black beans in a pot.", "Combine sweet potatoes and black beans in bowls, garnish with fresh cilantro and a lime juice drizzle."]', N'/static/uploads/recipe_20.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (21, N'Apple Cider Glazed Pork Tenderloin', N'Seared pork tenderloin baked with sweet apple slices and rosemary glaze.', 15, 25, N'Medium', 4, N'["Season pork tenderloin with fine table salt, ground black pepper, and dried rosemary.", "Sear tenderloin in melted unsalted butter over medium heat.", "Add sliced apples, apple cider vinegar, and maple syrup to skillet.", "Transfer to oven at 190\u00b0C and roast for 20 minutes."]', N'/static/uploads/recipe_21.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (22, N'Classic Caprese Salad', N'Fresh tomato slices layered with mozzarella, basil, and balsamic drizzle.', 10, 0, N'Easy', 2, N'["Slice ripe tomatoes into thick discs.", "Arrange tomatoes on a platter with fresh basil leaves and shredded mozzarella.", "Drizzle extra virgin olive oil and balsamic vinegar on top.", "Sprinkle with fine table salt."]', N'/static/uploads/recipe_22.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (23, N'Classic Chocolate Chip Cookies', N'Chewy bakery-style cookies loaded with semisweet chocolate chips.', 15, 12, N'Medium', 6, N'["Preheat oven to 180\u00b0C.", "Cream soft unsalted butter, brown sugar, and white sugar together.", "Beat in large eggs and vanilla extract.", "Whisk all-purpose flour, baking soda, and fine table salt, then mix into wet ingredients.", "Fold in semisweet chocolate chips, drop spoonfuls on pan, and bake for 10-12 minutes."]', N'/static/uploads/recipe_23.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (24, N'Classic Scrambled Eggs & Bacon', N'Soft scrambled eggs cooked in butter alongside crispy smoked bacon strips.', 5, 10, N'Easy', 2, N'["Fry bacon strips in skillet until crispy; drain on paper towels.", "Whisk large eggs, whole milk, fine table salt, and ground black pepper.", "Melt unsalted butter in low heat pan and pour egg mix.", "Gently stir until soft curds form and serve warm with bacon."]', N'/static/uploads/recipe_24.webp');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (25, N'Baked Cod in Italian Tomato Sauce', N'Flaky white fish baked in garlic, herb, and tomato sauce.', 10, 20, N'Easy', 3, N'["Preheat oven to 200\u00b0C.", "In a skillet, cook minced garlic in extra virgin olive oil, then add diced tomatoes and dried oregano.", "Place cod / white fish fillets in a baking dish and pour tomato sauce over top.", "Bake for 15-20 minutes until fish flakes easily with a fork.", "Season with fine table salt and ground black pepper."]', N'/static/uploads/recipe_25.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (26, N'Classic Tuna Salad Sandwich', N'Creamy tuna salad with crunchy celery served on whole wheat bread.', 10, 0, N'Easy', 2, N'["Drain canned tuna in oil and mash in a bowl.", "Mix with mayonnaise, diced celery, diced red onions, and dijon mustard.", "Season with fine table salt and ground black pepper.", "Spread evenly between slices of whole wheat bread."]', N'/static/uploads/recipe_26.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (27, N'Garlic Butter Mashed Potatoes', N'Smooth and fluffy mashed russet potatoes made with rich cream and butter.', 15, 20, N'Easy', 4, N'["Peel and boil russet potatoes in salted water until tender.", "Drain potatoes and mash until smooth.", "Fold in salted butter, heavy cream, garlic powder, fine table salt, and ground black pepper until creamy."]', N'/static/uploads/recipe_27.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (28, N'Homemade Chicken Vegetable Soup', N'Nourishing soup packed with chicken breast, carrots, celery, and chicken broth.', 15, 30, N'Easy', 4, N'["Saut\u00e9 diced yellow onions, carrots, and celery in extra virgin olive oil.", "Add minced garlic and cook for 1 minute.", "Pour in chicken broth and add cubed chicken breast along with dried thyme.", "Simmer for 25 minutes, seasoning with fine table salt and ground black pepper."]', N'/static/uploads/recipe_28.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (29, N'Turkey & Mozzarella Quesadilla', N'Crispy pan-grilled flour tortillas stuffed with turkey breast and mozzarella.', 5, 10, N'Easy', 2, N'["Place sliced turkey breast slices and shredded mozzarella on flour tortillas.", "Top with chopped green onions and fold in half.", "Cook on a dry skillet over medium heat until golden and cheese is melted.", "Slice into triangles and serve with sour cream."]', N'/static/uploads/recipe_29.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (30, N'Roasted Garlic Parmesan Broccoli', N'Oven-roasted broccoli florets tossed with red pepper flakes and parmesan.', 10, 20, N'Easy', 3, N'["Preheat oven to 200\u00b0C.", "Toss broccoli florets with extra virgin olive oil, minced garlic, red pepper flakes, and fine table salt.", "Spread on baking tray and roast for 18-20 minutes.", "Sprinkle parmesan cheese over hot broccoli before serving."]', N'/static/uploads/recipe_30.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (31, N'Mushroom Basmati Rice Pilaf', N'Fragrant basmati rice simmered with sliced button mushrooms and garlic butter.', 10, 20, N'Easy', 4, N'["Melt unsalted butter with extra virgin olive oil and saut\u00e9 sliced button mushrooms and yellow onions.", "Add garlic and basmati rice, stirring for 2 minutes.", "Pour in vegetable broth, cover, and cook on low heat for 15 minutes.", "Fluff with a fork and mix in parmesan cheese."]', N'/static/uploads/recipe_31.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (32, N'Rich Chocolate Milkshake', N'Decadent blended milkshake made with cocoa powder, vanilla ice cream, and dark chocolate.', 5, 0, N'Easy', 2, N'["Combine vanilla ice cream, unsweetened cocoa powder, and whole milk in a blender.", "Blend on high until smooth and thick.", "Grate dark chocolate bar on top as garnish."]', N'/static/uploads/recipe_32.webp');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (33, N'Honey Glazed Carrots', N'Tender carrots tossed in a sweet butter and pure honey glaze.', 10, 15, N'Easy', 3, N'["Slice carrots diagonally into coins.", "Melt unsalted butter in a skillet over medium heat.", "Add carrots, pure honey, and fine table salt.", "Cover and cook for 12 minutes until carrots are tender, then garnish with chopped fresh flat-leaf parsley."]', N'/static/uploads/recipe_33.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (34, N'Pork Sausage & Pepper Skillet', N'Savory pork sausages pan-fried with colorful bell peppers and diced tomatoes.', 10, 20, N'Easy', 4, N'["Slice pork sausages and brown in extra virgin olive oil.", "Add sliced bell peppers, yellow onions, and minced garlic to the skillet.", "Stir in diced tomatoes and dried oregano.", "Simmer for 15 minutes until peppers are soft and sausages fully cooked."]', N'/static/uploads/recipe_34.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (35, N'Spinach & Feta Breakfast Omelet', N'Fluffy egg omelet folded around fresh spinach and salty feta cheese.', 5, 8, N'Easy', 1, N'["Whisk large eggs with fine table salt and ground black pepper.", "Melt unsalted butter in a non-stick pan.", "Pour eggs and allow to set slightly, then top half with fresh spinach and crumbled feta cheese.", "Fold omelet over and cook until cheese is warm."]', N'/static/uploads/recipe_35.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (36, N'Sesame Ginger Turkey Rice Bowl', N'Lean ground turkey sautéed with ginger, garlic, and soy sauce over brown rice.', 10, 15, N'Easy', 3, N'["Cook ground turkey in sesame oil until brown.", "Add minced garlic, fresh ginger, and soy sauce, cooking for 3 minutes.", "Stir in chopped green onions.", "Serve over hot cooked brown rice."]', N'/static/uploads/recipe_36.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (37, N'Strawberry Yogurt Smoothie', N'Refreshing blend of ripe strawberries, greek yogurt, milk, and maple syrup.', 5, 0, N'Easy', 2, N'["Place strawberries, greek yogurt, whole milk, maple syrup, and vanilla extract into blender.", "Blend until completely smooth.", "Pour into chilled glasses."]', N'/static/uploads/recipe_37.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (38, N'Classic BLT Sandwich', N'Crispy bacon strips, ripe tomatoes, and mayonnaise stacked on toasted bread.', 5, 8, N'Easy', 2, N'["Fry bacon strips until extra crispy.", "Toast sandwich bread slices.", "Spread mayonnaise onto toasted bread slices.", "Layer with bacon strips and tomato slices, season with fine table salt and ground black pepper, then close sandwich."]', N'/static/uploads/recipe_38.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (39, N'Garlic Parmesan Toast', N'Crispy toasted bread brushed with garlic butter and topped with dried oregano.', 5, 10, N'Easy', 4, N'["Mix softened unsalted butter with minced garlic, dried oregano, and parmesan cheese.", "Spread mixture evenly on sandwich bread slices.", "Bake at 200\u00b0C for 8-10 minutes until golden and crispy."]', N'/static/uploads/recipe_39.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (40, N'Cottage Cheese & Berry Toast', N'Toasted whole wheat bread topped with fresh cottage cheese, sliced strawberries, and honey.', 5, 2, N'Easy', 2, N'["Toast whole wheat bread slices.", "Spread cottage cheese generously over each toast.", "Arrange sliced fresh strawberries on top.", "Drizzle with pure honey."]', N'/static/uploads/recipe_40.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (41, N'Cinnamon Baked Apples', N'Warm tender apples baked with brown sugar, butter, cinnamon, and walnuts.', 10, 30, N'Easy', 4, N'["Preheat oven to 190\u00b0C.", "Core apples and stand upright in a baking dish.", "Mix brown sugar, ground cinnamon, softened unsalted butter, and chopped walnut halves.", "Spoon mixture into the center of each apple and bake for 30 minutes."]', N'/static/uploads/recipe_41.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (42, N'Cheesy Marinara Pasta Bake', N'Baked penne pasta layered with marinara sauce, ricotta, and melted mozzarella.', 10, 20, N'Easy', 4, N'["Boil penne pasta until al dente.", "Mix pasta with marinara pasta sauce, ricotta cheese, and dried oregano.", "Transfer to a baking dish and cover with shredded mozzarella.", "Bake at 200\u00b0C for 20 minutes until bubbly and golden."]', N'/static/uploads/recipe_42.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (43, N'Quick Black Bean Soup', N'Hearty black bean soup flavored with garlic, cumin, lime juice, and sour cream.', 10, 15, N'Easy', 3, N'["Saut\u00e9 yellow onions and minced garlic in vegetable broth.", "Add canned black beans and ground cumin, then simmer for 10 minutes.", "Blend half the soup for a thicker texture, then stir back in.", "Finish with fresh lime juice and serve with a dollop of sour cream."]', N'/static/uploads/recipe_43.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (44, N'Loaded Baked Potato', N'Oven-baked russet potato packed with cheddar, sour cream, bacon, and green onions.', 5, 50, N'Easy', 2, N'["Prick russet potatoes with a fork and bake at 200\u00b0C for 50 minutes.", "Slice potatoes open down the center and fluff the inside.", "Fill with shredded cheddar cheese block, crispy bacon strips, sour cream, and green onions.", "Season with fine table salt."]', N'/static/uploads/recipe_44.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (45, N'Creamy Mushroom Chicken Thighs', N'Tender chicken thighs in a rich mushroom, heavy cream, and thyme sauce.', 10, 25, N'Medium', 4, N'["Sear chicken thighs in unsalted butter until browned on both sides; remove.", "In the same pan, saut\u00e9 button mushrooms and garlic.", "Pour in chicken broth, heavy cream, and dried thyme.", "Return chicken thighs to pan and simmer for 15 minutes until sauce thickens."]', N'/static/uploads/recipe_45.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (46, N'Crispy Zucchini Fritters', N'Pan-fried shredded zucchini fritters seasoned with green onions and pepper.', 15, 10, N'Medium', 3, N'["Shred zucchini, sprinkle salt, and squeeze out excess moisture.", "Mix zucchini with large eggs, all-purpose flour, chopped green onions, and ground black pepper.", "Heat vegetable oil in a pan, drop spoonfuls of batter, and flatten slightly.", "Fry 3-4 minutes per side until golden brown."]', N'/static/uploads/recipe_46.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (47, N'Lemon Herb Baked Cod Parcels', N'Cod fillets baked with sliced zucchini, bell peppers, and lemon herbs.', 15, 20, N'Easy', 2, N'["Preheat oven to 200\u00b0C.", "Lay cod / white fish fillets on parchment paper along with sliced zucchini and bell peppers.", "Drizzle with extra virgin olive oil and lemon juice, season with dried thyme and fine table salt.", "Fold paper parcels tightly and bake for 20 minutes."]', N'/static/uploads/recipe_47.png');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (48, N'Vanilla Cream Iced Coffee', N'Smooth cold iced coffee sweetened with sugar and splash of half-and-half.', 5, 0, N'Easy', 2, N'["Brew whole coffee beans with bottled water and allow to cool.", "Fill glasses with ice cubes and pour chilled coffee over ice.", "Stir in white sugar until dissolved.", "Top with half-and-half cream."]', N'/static/uploads/recipe_48.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (49, N'Croissant Breakfast Sandwich', N'Warm butter croissants filled with fried egg, cheddar cheese, and bacon.', 5, 10, N'Easy', 2, N'["Slice butter croissants in half and warm in oven.", "Fry bacon strips in a skillet until crispy.", "Fry large eggs in salted butter to desired doneness.", "Layer bacon, fried egg, and cheddar cheese block slices inside croissants."]', N'/static/uploads/recipe_49.jpg');

    INSERT INTO dbo.recipes ([id], [name], [description], [prep_time], [cook_time], [difficulty], [servings], [steps], [image_url]) VALUES (50, N'Creamy Chocolate Avocado Pudding', N'Velvety healthy chocolate pudding made with avocados, cocoa, and maple syrup.', 10, 0, N'Easy', 2, N'["Scoop avocados into a food processor.", "Add unsweetened cocoa powder, maple syrup, vanilla extract, and coconut milk.", "Blend on high until completely smooth and creamy.", "Chill in refrigerator for 30 minutes before serving."]', N'/static/uploads/recipe_50.jpg');

    SET IDENTITY_INSERT dbo.recipes OFF;

END;

IF NOT EXISTS (SELECT 1 FROM dbo.ingredients)

BEGIN

    SET IDENTITY_INSERT dbo.ingredients ON;

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (1, N'whole milk', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (2, N'skim milk', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (3, N'heavy cream', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (4, N'sour cream', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (5, N'unsalted butter', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (6, N'salted butter', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (7, N'large eggs', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (8, N'cheddar cheese block', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (9, N'shredded mozzarella', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (10, N'greek yogurt', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (11, N'parmesan cheese', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (12, N'cream cheese', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (13, N'cottage cheese', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (14, N'bananas', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (15, N'apples', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (16, N'tomatoes', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (17, N'yellow onions', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (18, N'red onions', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (19, N'garlic', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (20, N'russet potatoes', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (21, N'carrots', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (22, N'fresh spinach', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (23, N'lemons', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (24, N'limes', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (25, N'avocados', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (26, N'bell peppers', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (27, N'broccoli', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (28, N'cucumbers', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (29, N'strawberries', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (30, N'button mushrooms', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (31, N'fresh cilantro', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (32, N'fresh basil', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (33, N'zucchini', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (34, N'chicken breast', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (35, N'chicken thighs', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (36, N'ground beef', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (37, N'pork chops', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (38, N'bacon strips', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (39, N'fresh salmon fillet', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (40, N'canned tuna in oil', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (41, N'pork sausages', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (42, N'turkey breast slices', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (43, N'all-purpose flour', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (44, N'white sugar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (45, N'brown sugar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (46, N'powdered sugar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (47, N'white rice', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (48, N'brown rice', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (49, N'spaghetti', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (50, N'penne pasta', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (51, N'rolled oats', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (52, N'extra virgin olive oil', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (53, N'vegetable oil', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (54, N'sesame oil', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (55, N'apple cider vinegar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (56, N'white vinegar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (57, N'pure honey', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (58, N'maple syrup', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (59, N'baking soda', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (60, N'baking powder', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (61, N'active dry yeast', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (62, N'vanilla extract', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (63, N'semisweet chocolate chips', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (64, N'unsweetened cocoa powder', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (65, N'cornstarch', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (66, N'breadcrumbs', N'Baking');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (67, N'canned black beans', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (68, N'canned chickpeas', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (69, N'diced tomatoes', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (70, N'tomato paste', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (71, N'chicken broth', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (72, N'vegetable broth', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (73, N'coconut milk', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (74, N'peanut butter', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (75, N'strawberry jam', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (76, N'marinara pasta sauce', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (77, N'fine table salt', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (78, N'ground black pepper', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (79, N'garlic powder', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (80, N'onion powder', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (81, N'paprika', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (82, N'ground cumin', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (83, N'ground cinnamon', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (84, N'dried oregano', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (85, N'soy sauce', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (86, N'hot sauce', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (87, N'tomato ketchup', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (88, N'yellow mustard', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (89, N'mayonnaise', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (90, N'sandwich bread', N'Bakery');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (91, N'whole wheat bread', N'Bakery');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (92, N'hamburger buns', N'Bakery');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (93, N'flour tortillas', N'Bakery');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (94, N'butter croissants', N'Bakery');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (95, N'frozen green peas', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (96, N'frozen mixed vegetables', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (97, N'frozen mixed berries', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (98, N'raw frozen shrimp', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (99, N'frozen pizza', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (100, N'vanilla ice cream', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (101, N'bottled mineral water', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (102, N'bottled water', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (103, N'orange juice', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (104, N'apple juice', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (105, N'whole coffee beans', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (106, N'black tea bags', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (107, N'sparkling water', N'Beverages');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (108, N'potato chips', N'Snacks');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (109, N'tortilla chips', N'Snacks');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (110, N'whole almonds', N'Snacks');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (111, N'walnut halves', N'Snacks');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (112, N'dark chocolate bar', N'Snacks');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (113, N'fresh ginger', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (114, N'celery', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (115, N'green onions', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (116, N'jalapeño peppers', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (117, N'fresh flat-leaf parsley', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (118, N'sweet potatoes', N'Produce');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (119, N'dijon mustard', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (120, N'worcestershire sauce', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (121, N'kosher salt', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (122, N'red pepper flakes', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (123, N'smoked paprika', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (124, N'cayenne pepper', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (125, N'ground turmeric', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (126, N'dried thyme', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (127, N'dried rosemary', N'Condiments & Spices');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (128, N'red wine vinegar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (129, N'balsamic vinegar', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (130, N'jasmine rice', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (131, N'basmati rice', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (132, N'bread flour', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (133, N'coconut oil', N'Pantry');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (134, N'beef broth', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (135, N'canned kidney beans', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (136, N'canned cannellini beans', N'Canned Goods');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (137, N'ground turkey', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (138, N'beef steak', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (139, N'pork tenderloin', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (140, N'cod / white fish fillets', N'Meat & Seafood');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (141, N'buttermilk', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (142, N'half-and-half', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (143, N'ricotta cheese', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (144, N'feta cheese', N'Dairy & Eggs');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (145, N'frozen sweet corn', N'Frozen');

    INSERT INTO dbo.ingredients ([id], [name], [category]) VALUES (146, N'frozen chopped spinach', N'Frozen');

    SET IDENTITY_INSERT dbo.ingredients OFF;

END;

IF NOT EXISTS (SELECT 1 FROM dbo.recipe_ingredients)

BEGIN

    SET IDENTITY_INSERT dbo.recipe_ingredients ON;

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (1, 1, 49, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (2, 1, 36, 500, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (3, 1, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (4, 1, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (5, 1, 69, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (6, 1, 70, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (7, 1, 52, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (8, 1, 84, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (9, 1, 77, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (10, 1, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (11, 1, 11, 50, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (12, 2, 39, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (13, 2, 5, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (14, 2, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (15, 2, 117, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (16, 2, 23, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (17, 2, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (18, 2, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (19, 3, 138, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (20, 3, 27, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (21, 3, 85, 45, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (22, 3, 45, 20, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (23, 3, 65, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (24, 3, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (25, 3, 113, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (26, 3, 53, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (27, 3, 54, 10, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (28, 4, 47, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (29, 4, 34, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (30, 4, 95, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (31, 4, 21, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (32, 4, 7, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (33, 4, 85, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (34, 4, 54, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (35, 4, 115, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (36, 4, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (37, 5, 25, 3, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (38, 5, 24, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (39, 5, 18, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (40, 5, 31, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (41, 5, 116, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (42, 5, 121, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (43, 5, 109, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (44, 6, 43, 250, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (45, 6, 60, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (46, 6, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (47, 6, 44, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (48, 6, 1, 300, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (49, 6, 7, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (50, 6, 5, 50, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (51, 6, 58, 100, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (52, 7, 90, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (53, 7, 7, 3, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (54, 7, 1, 100, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (55, 7, 83, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (56, 7, 62, 5, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (57, 7, 5, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (58, 7, 58, 60, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (59, 8, 68, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (60, 8, 22, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (61, 8, 73, 400, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (62, 8, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (63, 8, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (64, 8, 113, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (65, 8, 82, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (66, 8, 125, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (67, 8, 124, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (68, 8, 53, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (69, 9, 69, 800, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (70, 9, 72, 500, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (71, 9, 3, 100, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (72, 9, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (73, 9, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (74, 9, 5, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (75, 9, 32, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (76, 9, 77, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (77, 9, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (78, 10, 36, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (79, 10, 130, 250, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (80, 10, 67, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (81, 10, 145, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (82, 10, 26, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (83, 10, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (84, 10, 82, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (85, 10, 81, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (86, 10, 79, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (87, 10, 77, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (88, 10, 4, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (89, 10, 8, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (90, 11, 37, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (91, 11, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (92, 11, 79, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (93, 11, 80, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (94, 11, 123, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (95, 11, 126, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (96, 11, 77, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (97, 11, 78, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (98, 12, 35, 600, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (99, 12, 23, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (100, 12, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (101, 12, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (102, 12, 127, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (103, 12, 126, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (104, 12, 121, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (105, 12, 78, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (106, 13, 36, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (107, 13, 92, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (108, 13, 8, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (109, 13, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (110, 13, 16, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (111, 13, 38, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (112, 13, 87, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (113, 13, 88, 15, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (114, 13, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (115, 13, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (116, 14, 28, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (117, 14, 16, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (118, 14, 18, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (119, 14, 144, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (120, 14, 52, 45, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (121, 14, 128, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (122, 14, 84, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (123, 14, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (124, 15, 51, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (125, 15, 1, 350, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (126, 15, 97, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (127, 15, 57, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (128, 15, 83, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (129, 15, 111, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (130, 16, 50, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (131, 16, 3, 250, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (132, 16, 11, 80, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (133, 16, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (134, 16, 5, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (135, 16, 117, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (136, 16, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (137, 16, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (138, 17, 98, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (139, 17, 26, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (140, 17, 18, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (141, 17, 24, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (142, 17, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (143, 17, 82, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (144, 17, 81, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (145, 17, 93, 6, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (146, 18, 14, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (147, 18, 10, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (148, 18, 2, 250, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (149, 18, 57, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (150, 18, 74, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (151, 19, 20, 800, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (152, 19, 52, 45, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (153, 19, 81, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (154, 19, 79, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (155, 19, 77, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (156, 19, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (157, 20, 118, 500, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (158, 20, 67, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (159, 20, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (160, 20, 82, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (161, 20, 24, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (162, 20, 31, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (163, 21, 139, 500, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (164, 21, 15, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (165, 21, 55, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (166, 21, 58, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (167, 21, 5, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (168, 21, 127, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (169, 21, 77, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (170, 21, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (171, 22, 16, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (172, 22, 9, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (173, 22, 32, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (174, 22, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (175, 22, 129, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (176, 22, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (177, 23, 43, 280, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (178, 23, 59, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (179, 23, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (180, 23, 5, 170, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (181, 23, 45, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (182, 23, 44, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (183, 23, 7, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (184, 23, 62, 5, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (185, 23, 63, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (186, 24, 7, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (187, 24, 1, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (188, 24, 5, 15, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (189, 24, 38, 6, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (190, 24, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (191, 24, 78, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (192, 25, 140, 450, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (193, 25, 69, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (194, 25, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (195, 25, 52, 20, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (196, 25, 84, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (197, 25, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (198, 25, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (199, 26, 40, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (200, 26, 89, 45, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (201, 26, 114, 2, N'stalk');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (202, 26, 18, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (203, 26, 119, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (204, 26, 91, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (205, 26, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (206, 26, 78, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (207, 27, 20, 800, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (208, 27, 6, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (209, 27, 3, 80, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (210, 27, 79, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (211, 27, 77, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (212, 27, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (213, 28, 34, 350, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (214, 28, 71, 1000, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (215, 28, 21, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (216, 28, 114, 2, N'stalk');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (217, 28, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (218, 28, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (219, 28, 126, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (220, 28, 52, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (221, 28, 77, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (222, 28, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (223, 29, 93, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (224, 29, 42, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (225, 29, 9, 120, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (226, 29, 115, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (227, 29, 4, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (228, 30, 27, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (229, 30, 52, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (230, 30, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (231, 30, 122, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (232, 30, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (233, 30, 11, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (234, 31, 131, 250, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (235, 31, 30, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (236, 31, 72, 500, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (237, 31, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (238, 31, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (239, 31, 5, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (240, 31, 52, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (241, 31, 11, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (242, 32, 100, 300, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (243, 32, 64, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (244, 32, 1, 200, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (245, 32, 112, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (246, 33, 21, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (247, 33, 5, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (248, 33, 57, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (249, 33, 117, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (250, 33, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (251, 34, 41, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (252, 34, 26, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (253, 34, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (254, 34, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (255, 34, 69, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (256, 34, 84, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (257, 34, 52, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (258, 35, 7, 3, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (259, 35, 22, 50, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (260, 35, 144, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (261, 35, 5, 15, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (262, 35, 77, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (263, 35, 78, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (264, 36, 137, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (265, 36, 85, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (266, 36, 113, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (267, 36, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (268, 36, 115, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (269, 36, 54, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (270, 36, 48, 250, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (271, 37, 29, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (272, 37, 10, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (273, 37, 1, 200, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (274, 37, 58, 20, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (275, 37, 62, 3, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (276, 38, 90, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (277, 38, 38, 6, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (278, 38, 16, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (279, 38, 89, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (280, 38, 77, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (281, 38, 78, 1, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (282, 39, 90, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (283, 39, 5, 50, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (284, 39, 19, 3, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (285, 39, 84, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (286, 39, 11, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (287, 40, 91, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (288, 40, 13, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (289, 40, 29, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (290, 40, 57, 15, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (291, 41, 15, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (292, 41, 45, 50, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (293, 41, 83, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (294, 41, 5, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (295, 41, 111, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (296, 42, 50, 350, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (297, 42, 76, 400, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (298, 42, 9, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (299, 42, 143, 100, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (300, 42, 84, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (301, 43, 67, 800, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (302, 43, 72, 400, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (303, 43, 17, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (304, 43, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (305, 43, 82, 5, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (306, 43, 24, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (307, 43, 4, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (308, 44, 20, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (309, 44, 38, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (310, 44, 8, 80, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (311, 44, 4, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (312, 44, 115, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (313, 44, 77, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (314, 45, 35, 600, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (315, 45, 30, 200, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (316, 45, 3, 150, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (317, 45, 71, 100, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (318, 45, 19, 2, N'cloves');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (319, 45, 5, 25, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (320, 45, 126, 4, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (321, 46, 33, 400, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (322, 46, 7, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (323, 46, 43, 60, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (324, 46, 115, 1, N'bunch');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (325, 46, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (326, 46, 78, 2, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (327, 46, 53, 30, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (328, 47, 140, 350, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (329, 47, 33, 150, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (330, 47, 26, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (331, 47, 52, 20, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (332, 47, 23, 1, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (333, 47, 77, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (334, 47, 126, 3, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (335, 48, 105, 30, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (336, 48, 102, 400, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (337, 48, 142, 60, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (338, 48, 44, 20, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (339, 49, 94, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (340, 49, 7, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (341, 49, 8, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (342, 49, 38, 4, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (343, 49, 6, 10, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (344, 50, 25, 2, N'qty');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (345, 50, 64, 40, N'g');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (346, 50, 58, 60, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (347, 50, 62, 5, N'ml');

    INSERT INTO dbo.recipe_ingredients ([id], [recipe_id], [ingredient_id], [amount], [unit]) VALUES (348, 50, 73, 60, N'ml');

    SET IDENTITY_INSERT dbo.recipe_ingredients OFF;

END;
