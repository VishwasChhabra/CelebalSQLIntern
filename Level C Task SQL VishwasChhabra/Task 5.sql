CREATE TABLE Hackers (
    hacker_id INT,
    name VARCHAR(100)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT,
    hacker_id INT,
    score INT
);


INSERT INTO Hackers VALUES 
(15758, 'Rose'), (20703, 'Angela'), (36396, 'Frank'), 
(38289, 'Patrick'), (44065, 'Lisa'), (53473, 'Kimberly'), 
(62529, 'Bonnie'), (79722, 'Michael');

INSERT INTO Submissions VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50434, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);


WITH Daily_Hacker_Submissions AS (
  SELECT
    submission_date,
    hacker_id,
    COUNT(*) AS submissions
  FROM Submissions
  GROUP BY submission_date, hacker_id
),
Max_Hacker_Per_Day AS (
  SELECT
    submission_date,
    hacker_id
  FROM (
    SELECT
      submission_date,
      hacker_id,
      submissions,
      RANK() OVER (PARTITION BY submission_date ORDER BY submissions DESC, hacker_id ASC) AS rnk
    FROM Daily_Hacker_Submissions
  ) ranked
  WHERE rnk = 1
),
Daily_Unique_Hackers AS (
  SELECT submission_date, COUNT(DISTINCT hacker_id) AS total_unique_hackers
  FROM Submissions
  GROUP BY submission_date
)

SELECT
  m.submission_date,
  d.total_unique_hackers,
  m.hacker_id,
  h.name
FROM Max_Hacker_Per_Day m
JOIN Daily_Unique_Hackers d ON m.submission_date = d.submission_date
JOIN Hackers h ON m.hacker_id = h.hacker_id
ORDER BY m.submission_date;
