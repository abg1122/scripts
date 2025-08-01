-- backup-history.sql
-- Shows the most recent backups for all databases over the last 7 days

USE msdb;
GO

SELECT
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.type AS backup_type,
    CASE bs.type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Transaction Log'
        ELSE bs.type
    END AS backup_type_desc,
    bs.backup_size / 1024 / 1024 AS size_MB,
    bmf.physical_device_name
FROM backupset bs
INNER JOIN backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE bs.backup_start_date > DATEADD(DAY, -7, GETDATE())
ORDER BY bs.backup_finish_date DESC;
