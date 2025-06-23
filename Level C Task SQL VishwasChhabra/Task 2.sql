CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Friends (
    ID INT,
    Friend_ID INT
);

CREATE TABLE Packages (
    ID INT,
    Salary FLOAT
);

INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julia'),
(4, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 1);

INSERT INTO Packages (ID, Salary) VALUES
(1, 15.20),
(2, 10.06),
(3, 11.55),
(4, 12.12);

SELECT 
    s.Name
FROM 
    Students s
JOIN 
    Friends f ON s.ID = f.ID
JOIN 
    Packages sp ON s.ID = sp.ID
JOIN 
    Packages fp ON f.Friend_ID = fp.ID
WHERE 
    fp.Salary > sp.Salary
ORDER BY 
    fp.Salary DESC;
