IF COL_LENGTH('dbo.supermarket_products', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.supermarket_products
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_supermarket_products_is_active DEFAULT (1)
        WITH VALUES;
END;