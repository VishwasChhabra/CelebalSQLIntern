CREATE TABLE Employee (
    Emp_ID INT,
    Name VARCHAR(100),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employee (Emp_ID, Name, Salary) VALUES
(1, 'Alice', 90000),
(2, 'Bob', 85000),
(3, 'Charlie', 95000),
(4, 'David', 88000),
(5, 'Eva', 92000),
(6, 'Frank', 86000),
(7, 'Grace', 91000);

SELECT Emp_ID, Name, Salary
FROM (
    SELECT *, RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM Employee
) AS ranked
WHERE rnk <= 5;
