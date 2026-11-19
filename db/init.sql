/*
   Local-only database bootstrap.
   The Compose init-db service runs this script once per `docker compose up`.
   Every statement is idempotent so restarting the stack does not recreate data.
*/

IF DB_ID(N'catalog_db') IS NULL
    CREATE DATABASE [catalog_db];
GO

IF DB_ID(N'shopping_db') IS NULL
    CREATE DATABASE [shopping_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'catalog_user'
)
    CREATE LOGIN [catalog_user]
        WITH PASSWORD = '$(CATALOG_DB_PASSWORD)';
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_principals
    WHERE name = N'shopping_user'
)
    CREATE LOGIN [shopping_user]
        WITH PASSWORD = '$(SHOPPING_DB_PASSWORD)';
GO

USE [catalog_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'catalog_user'
)
    CREATE USER [catalog_user] FOR LOGIN [catalog_user];
GO

IF ISNULL(IS_ROLEMEMBER(N'db_owner', N'catalog_user'), 0) <> 1
    ALTER ROLE [db_owner] ADD MEMBER [catalog_user];
GO

USE [shopping_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'shopping_user'
)
    CREATE USER [shopping_user] FOR LOGIN [shopping_user];
GO

IF ISNULL(IS_ROLEMEMBER(N'db_owner', N'shopping_user'), 0) <> 1
    ALTER ROLE [db_owner] ADD MEMBER [shopping_user];
GO
