CREATE TABLE Employee (
    Emp_ID INT,
    Name VARCHAR(100),
    Sub_Band VARCHAR(10)
);

INSERT INTO Employee (Emp_ID, Name, Sub_Band) VALUES
(1, 'Alice', 'SB1'),
(2, 'Bob', 'SB1'),
(3, 'Charlie', 'SB2'),
(4, 'David', 'SB2'),
(5, 'Eva', 'SB2'),
(6, 'Frank', 'SB3'),
(7, 'Grace', 'SB1');

SELECT 
    Sub_Band,
    COUNT(*) AS Headcount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage_Of_Total
FROM 
    Employee
GROUP BY 
    Sub_Band;
