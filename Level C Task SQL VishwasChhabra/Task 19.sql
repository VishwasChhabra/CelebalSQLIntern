SELECT 
    CEIL(AVG(Salary) - AVG(CAST(REPLACE(Salary, '0', '') AS UNSIGNED))) AS Difference
FROM 
    EMPLOYEES;
