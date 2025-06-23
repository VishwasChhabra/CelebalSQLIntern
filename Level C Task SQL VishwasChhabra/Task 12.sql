SELECT 
    JobFamily,
    ROUND(SUM(CASE WHEN Country = 'India' THEN Cost ELSE 0 END) * 100.0 / SUM(Cost), 2) AS India_Percentage,
    ROUND(SUM(CASE WHEN Country != 'India' THEN Cost ELSE 0 END) * 100.0 / SUM(Cost), 2) AS International_Percentage
FROM 
    JobFamilyCosts
GROUP BY 
    JobFamily;
