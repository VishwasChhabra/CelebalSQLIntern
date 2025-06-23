CREATE TABLE Projects (
    Task_ID INT,
    Start_Date DATE,
    End_Date DATE
);

INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-01', '2015-10-02'),
(2, '2015-10-02', '2015-10-03'),
(3, '2015-10-03', '2015-10-04'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31');

WITH OrderedProjects AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        LAG(End_Date) OVER (ORDER BY Start_Date) AS Prev_End
    FROM Projects
),
GroupFlags AS (
    SELECT *,
        CASE 
            WHEN Prev_End IS NULL OR Start_Date > Prev_End THEN 1
            ELSE 0
        END AS Is_New_Group
    FROM OrderedProjects
),
GroupIDs AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        SUM(Is_New_Group) OVER (ORDER BY Start_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS GroupID
    FROM GroupFlags
),
ProjectRanges AS (
    SELECT 
        MIN(Start_Date) AS ProjectStart,
        MAX(End_Date) AS ProjectEnd,
        DATEDIFF(MAX(End_Date), MIN(Start_Date)) AS Duration
    FROM GroupIDs
    GROUP BY GroupID
)
SELECT 
    ProjectStart,
    ProjectEnd
FROM ProjectRanges
ORDER BY 
    Duration ASC,
    ProjectStart ASC;