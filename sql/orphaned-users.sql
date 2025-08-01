-- orphaned-users.sql
-- Find database users not linked to any SQL Server login

USE [YourDatabaseName];
GO

SELECT dp.name AS orphaned_user
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE dp.type IN ('S', 'U')
  AND sp.sid IS NULL
  AND dp.authentication_type_desc <> 'DATABASE_ROLE'
  AND dp.name NOT IN ('guest', 'INFORMATION_SCHEMA', 'sys');
