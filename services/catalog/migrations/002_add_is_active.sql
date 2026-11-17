IF COL_LENGTH('dbo.recipes', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.recipes
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_recipes_is_active DEFAULT (1)
        WITH VALUES;
END;