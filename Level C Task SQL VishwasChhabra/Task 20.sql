INSERT INTO TargetTable (ID, Name, Salary)  -- Replace columns as needed
SELECT ID, Name, Salary
FROM SourceTable
WHERE ID NOT IN (SELECT ID FROM TargetTable);
