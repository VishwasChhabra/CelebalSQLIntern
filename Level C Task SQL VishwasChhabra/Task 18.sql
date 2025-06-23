CREATE TABLE Employee_Costs (
    BU_Name VARCHAR(100),
    Month DATE,
    Sub_Band VARCHAR(50),
    Headcount INT,
    Cost_Per_Employee DECIMAL(10, 2)
);

INSERT INTO Employee_Costs VALUES
('BU1', '2024-01-01', 'SB1', 10, 50000),
('BU1', '2024-01-01', 'SB2', 5, 60000),
('BU1', '2024-02-01', 'SB1', 12, 52000),
('BU1', '2024-02-01', 'SB2', 6, 62000),
('BU2', '2024-01-01', 'SB1', 8, 48000),
('BU2', '2024-01-01', 'SB3', 4, 55000);

SELECT
    BU_Name,
    DATE_FORMAT(Month, '%Y-%m') AS Month,
    ROUND(SUM(Cost_Per_Employee * Headcount) / SUM(Headcount), 2) AS Weighted_Avg_Cost
FROM 
    Employee_Costs
GROUP BY 
    BU_Name, DATE_FORMAT(Month, '%Y-%m')
ORDER BY 
    BU_Name, Month;
