CREATE TABLE Employee (
    Emp_ID INT,
    A INT,
    B INT
);

-- For Numeric Columns --
UPDATE Employee
SET A = A + B,
    B = A - B,
    A = A - B;

-- For String Columns --
UPDATE Employee
SET A = CONCAT(A, B),
    B = SUBSTRING(A, 1, LENGTH(A) - LENGTH(B)),
    A = SUBSTRING(A, LENGTH(B) + 1);
