
IF OBJECT_ID('dbo.supermarket_products', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.supermarket_products (
        id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        ingredient_id INT NOT NULL,
        product_name NVARCHAR(255) NOT NULL,
        price FLOAT NOT NULL,
        package_size FLOAT NULL,
        package_unit NVARCHAR(100) NULL
    );
END;


IF NOT EXISTS (SELECT 1 FROM dbo.supermarket_products)

BEGIN

    SET IDENTITY_INSERT dbo.supermarket_products ON;

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (1, 1, N'Whole Milk', 1.49, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (2, 2, N'Skim Milk', 1.3899999999999999, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (3, 3, N'Heavy Cream', 2.29, 250, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (4, 4, N'Sour Cream', 1.79, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (5, 5, N'Unsalted Butter', 2.9900000000000002, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (6, 6, N'Salted Butter', 2.9900000000000002, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (7, 7, N'Large Eggs', 3.4900000000000002, 12, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (8, 7, N'Large Eggs', 1.99, 6, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (9, 8, N'Cheddar Cheese Block', 2.8900000000000001, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (10, 9, N'Shredded Mozzarella', 2.4900000000000002, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (11, 10, N'Greek Yogurt (Plain)', 2.9900000000000002, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (12, 11, N'Parmesan Cheese (Grated)', 2.79, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (13, 12, N'Cream Cheese', 2.1899999999999999, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (14, 13, N'Cottage Cheese', 2.3900000000000001, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (15, 14, N'Bananas', 1.5900000000000001, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (16, 15, N'Apples (Gala)', 2.9900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (17, 16, N'Tomatoes', 2.4900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (18, 17, N'Yellow Onions', 1.29, 4, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (19, 18, N'Red Onions', 1.1899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (20, 19, N'Garlic', 1.49, 30, N'cloves');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (21, 20, N'Russet Potatoes', 3.29, 2, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (22, 21, N'Carrots', 1.1899999999999999, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (23, 22, N'Fresh Spinach', 1.99, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (24, 23, N'Lemons', 1.79, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (25, 24, N'Limes', 1.8899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (26, 25, N'Avocados', 2.9900000000000002, 3, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (27, 26, N'Bell Peppers (Mixed)', 2.79, 3, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (28, 27, N'Broccoli', 1.8899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (29, 28, N'Cucumbers', 0.89000000000000001, 300, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (30, 29, N'Strawberries', 3.4900000000000002, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (31, 30, N'Button Mushrooms', 1.6899999999999999, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (32, 31, N'Fresh Cilantro', 0.98999999999999999, 1, N'bunch');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (33, 32, N'Fresh Basil', 1.49, 30, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (34, 33, N'Zucchini', 1.3899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (35, 34, N'Chicken Breast (Boneless)', 8.9900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (36, 35, N'Chicken Thighs (Skinless)', 6.9900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (37, 36, N'Ground Beef (80/20)', 4.9900000000000002, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (38, 37, N'Pork Chops', 4.4900000000000002, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (39, 38, N'Bacon Strips', 3.29, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (40, 39, N'Fresh Salmon Fillet', 9.4900000000000002, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (41, 40, N'Canned Tuna in Oil', 1.5900000000000001, 160, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (42, 41, N'Pork Sausages', 3.79, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (43, 42, N'Turkey Breast Slices', 2.9900000000000002, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (44, 43, N'All-Purpose Flour', 1.1899999999999999, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (45, 44, N'White Sugar', 1.29, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (46, 45, N'Brown Sugar', 1.49, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (47, 46, N'Powdered Sugar', 1.3899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (48, 47, N'White Rice (Long Grain)', 1.8899999999999999, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (49, 48, N'Brown Rice', 2.1899999999999999, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (50, 49, N'Spaghetti', 1.0900000000000001, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (51, 50, N'Penne Pasta', 1.0900000000000001, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (52, 51, N'Rolled Oats', 2.29, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (53, 52, N'Extra Virgin Olive Oil', 8.9900000000000002, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (54, 53, N'Vegetable Oil', 2.79, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (55, 54, N'Sesame Oil', 3.4900000000000002, 250, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (56, 55, N'Apple Cider Vinegar', 2.1899999999999999, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (57, 56, N'White Vinegar', 1.1899999999999999, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (58, 57, N'Pure Honey', 4.9900000000000002, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (59, 58, N'Maple Syrup', 5.4900000000000002, 250, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (60, 59, N'Baking Soda', 0.98999999999999999, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (61, 60, N'Baking Powder', 1.29, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (62, 61, N'Active Dry Yeast', 1.49, 50, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (63, 62, N'Vanilla Extract', 3.9900000000000002, 50, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (64, 63, N'Semisweet Chocolate Chips', 2.6899999999999999, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (65, 64, N'Unsweetened Cocoa Powder', 2.4900000000000002, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (66, 65, N'Cornstarch', 1.1899999999999999, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (67, 66, N'Breadcrumbs', 1.29, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (68, 67, N'Canned Black Beans', 0.98999999999999999, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (69, 68, N'Canned Chickpeas', 0.98999999999999999, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (70, 69, N'Diced Tomatoes', 0.89000000000000001, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (71, 70, N'Tomato Paste', 0.79000000000000004, 150, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (72, 71, N'Chicken Broth', 1.99, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (73, 72, N'Vegetable Broth', 1.99, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (74, 73, N'Coconut Milk', 1.6899999999999999, 400, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (75, 74, N'Peanut Butter', 3.29, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (76, 75, N'Strawberry Jam', 2.4900000000000002, 350, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (77, 76, N'Marinara Pasta Sauce', 2.29, 680, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (78, 77, N'Fine Table Salt', 0.68999999999999995, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (79, 78, N'Ground Black Pepper', 2.1899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (80, 79, N'Garlic Powder', 1.79, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (81, 80, N'Onion Powder', 1.79, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (82, 81, N'Paprika', 1.8899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (83, 82, N'Ground Cumin', 1.99, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (84, 83, N'Ground Cinnamon', 1.8899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (85, 84, N'Dried Oregano', 1.49, 50, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (86, 85, N'Soy Sauce', 1.99, 250, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (87, 86, N'Hot Sauce', 2.1899999999999999, 150, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (88, 87, N'Tomato Ketchup', 2.29, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (89, 88, N'Yellow Mustard', 1.49, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (90, 89, N'Mayonnaise', 2.8900000000000001, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (91, 90, N'Sandwich Bread (White)', 1.6899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (92, 91, N'Whole Wheat Bread', 1.99, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (93, 92, N'Hamburger Buns', 1.8899999999999999, 6, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (94, 93, N'Flour Tortillas', 1.99, 8, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (95, 94, N'Butter Croissants', 2.9900000000000002, 4, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (96, 95, N'Frozen Green Peas', 1.49, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (97, 96, N'Frozen Mixed Vegetables', 1.5900000000000001, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (98, 97, N'Frozen Mixed Berries', 3.29, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (99, 98, N'Raw Frozen Shrimp', 6.9900000000000002, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (100, 99, N'Frozen Pizza (Margherita)', 3.4900000000000002, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (101, 100, N'Vanilla Ice Cream', 3.9900000000000002, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (102, 101, N'Bottled Mineral Water', 0.58999999999999997, 1.5, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (103, 102, N'Bottled Water (6-Pack)', 2.9900000000000002, 9, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (104, 103, N'Orange Juice (100%)', 2.4900000000000002, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (105, 104, N'Apple Juice', 2.1899999999999999, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (106, 105, N'Whole Coffee Beans', 6.9900000000000002, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (107, 106, N'Black Tea Bags', 3.29, 100, N'count');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (108, 107, N'Sparkling Water', 0.79000000000000004, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (109, 108, N'Potato Chips', 1.79, 150, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (110, 109, N'Tortilla Chips', 1.99, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (111, 110, N'Whole Almonds', 3.4900000000000002, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (112, 111, N'Walnut Halves', 3.8900000000000001, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (113, 112, N'Dark Chocolate Bar (70%)', 1.6899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (114, 113, N'Fresh Ginger', 1.29, 150, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (115, 114, N'Celery', 1.49, 1, N'stalk');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (116, 115, N'Green Onions (Scallions)', 0.98999999999999999, 1, N'bunch');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (117, 116, N'Jalapeño Peppers', 1.1899999999999999, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (118, 117, N'Fresh Flat-Leaf Parsley', 0.98999999999999999, 1, N'bunch');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (119, 118, N'Sweet Potatoes', 2.4900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (120, 119, N'Dijon Mustard', 1.99, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (121, 120, N'Worcestershire Sauce', 2.4900000000000002, 290, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (122, 121, N'Kosher Salt', 1.49, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (123, 122, N'Red Pepper Flakes', 1.8899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (124, 123, N'Smoked Paprika', 1.99, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (125, 124, N'Cayenne Pepper', 1.8899999999999999, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (126, 125, N'Ground Turmeric', 1.99, 100, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (127, 126, N'Dried Thyme', 1.49, 50, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (128, 127, N'Dried Rosemary', 1.49, 50, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (129, 128, N'Red Wine Vinegar', 2.29, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (130, 129, N'Balsamic Vinegar', 3.4900000000000002, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (131, 130, N'Jasmine Rice', 2.4900000000000002, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (132, 131, N'Basmati Rice', 2.79, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (133, 132, N'Bread Flour', 1.49, 1, N'kg');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (134, 133, N'Coconut Oil', 4.4900000000000002, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (135, 134, N'Beef Broth', 1.99, 1, N'L');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (136, 135, N'Canned Kidney Beans', 0.98999999999999999, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (137, 136, N'Canned Cannellini Beans', 0.98999999999999999, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (138, 137, N'Ground Turkey', 4.29, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (139, 138, N'Beef Steak (Ribeye or Sirloin)', 7.9900000000000002, 300, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (140, 139, N'Pork Tenderloin', 5.4900000000000002, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (141, 140, N'Cod / White Fish Fillets', 6.4900000000000002, 400, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (142, 141, N'Buttermilk', 1.49, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (143, 142, N'Half-and-Half', 1.99, 500, N'ml');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (144, 143, N'Ricotta Cheese', 2.4900000000000002, 250, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (145, 144, N'Feta Cheese', 2.6899999999999999, 200, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (146, 145, N'Frozen Sweet Corn', 1.3899999999999999, 500, N'g');

    INSERT INTO dbo.supermarket_products ([id], [ingredient_id], [product_name], [price], [package_size], [package_unit]) VALUES (147, 146, N'Frozen Chopped Spinach', 1.49, 450, N'g');

    SET IDENTITY_INSERT dbo.supermarket_products OFF;

END;
