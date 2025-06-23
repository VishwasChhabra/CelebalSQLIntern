-- Considering Sample Data --

CREATE TABLE BU_Financials (
    BU_Name VARCHAR(100),
    Month DATE,
    Cost DECIMAL(12,2),
    Revenue DECIMAL(12,2)
);

INSERT INTO BU_Financials (BU_Name, Month, Cost, Revenue) VALUES
('BU1', '2024-01-01', 10000, 25000),
('BU1', '2024-02-01', 12000, 30000),
('BU1', '2024-03-01', 13000, 29000),
('BU2', '2024-01-01', 8000, 15000),
('BU2', '2024-02-01', 9500, 18000),
('BU2', '2024-03-01', 10500, 20000),
('BU3', '2024-01-01', 5000, 10000),
('BU3', '2024-02-01', 6000, 11000);

SELECT
    BU_Name,
    FORMAT(Month, 'yyyy-MM') AS Month,
    SUM(Cost) AS Total_Cost,
    SUM(Revenue) AS Total_Revenue,
    ROUND((SUM(Cost) * 100.0 / NULLIF(SUM(Revenue), 0)), 2) AS Cost_to_Revenue_Percentage
FROM
    BU_Financials
GROUP BY
    BU_Name,
    FORMAT(Month, 'yyyy-MM')
ORDER BY
    BU_Name,
    FORMAT(Month, 'yyyy-MM');
