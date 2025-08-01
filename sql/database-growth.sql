-- database-growth.sql
-- Snapshot of current DB sizes to log growth over time (run daily to track)

USE master;
GO

SELECT
    db.name AS database_name,
    SUM(size * 8 / 1024) AS size_MB
FROM sys.master_files mf
JOIN sys.databases db ON db.database_id = mf.database_id
WHERE db.state_desc = 'ONLINE'
GROUP BY db.name
ORDER BY size_MB DESC;
