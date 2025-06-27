CREATE TABLE StudentDetails (
    StudentId INT PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA FLOAT,
    Branch VARCHAR(10),
    Section VARCHAR(5)
);

INSERT INTO StudentDetails VALUES 
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');


CREATE TABLE StudentPreference (
    StudentId INT,
    SubjectId VARCHAR(10),
    Preference INT,
    PRIMARY KEY(StudentId, Preference)
);

INSERT INTO StudentPreference VALUES
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5),
(159103037, 'PO1491', 1),
(159103037, 'PO1492', 2),
(159103037, 'PO1493', 3),
(159103037, 'PO1494', 4),
(159103037, 'PO1495', 5),
(159103038, 'PO1491', 1),
(159103038, 'PO1492', 2),
(159103038, 'PO1493', 3),
(159103038, 'PO1494', 4),
(159103038, 'PO1495', 5),
(159103039, 'PO1491', 1),
(159103039, 'PO1492', 2),
(159103039, 'PO1493', 3),
(159103039, 'PO1494', 4),
(159103039, 'PO1495', 5),
(159103040, 'PO1491', 1),
(159103040, 'PO1492', 2),
(159103040, 'PO1493', 3),
(159103040, 'PO1494', 4),
(159103040, 'PO1495', 5),
(159103041, 'PO1491', 1),
(159103041, 'PO1492', 2),
(159103041, 'PO1493', 3),
(159103041, 'PO1494', 4),
(159103041, 'PO1495', 5);


CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(10) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

INSERT INTO SubjectDetails VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);


CREATE TABLE Allotments (
    SubjectId VARCHAR(10),
    StudentId INT
);

CREATE TABLE UnallotedStudents (
    StudentId INT
);


DELIMITER $$

CREATE PROCEDURE AllotSubjects()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE student_id INT;
    DECLARE gpa FLOAT;

    DECLARE pref INT;
    DECLARE sub_id VARCHAR(10);
    DECLARE subject_found BOOLEAN;

    DECLARE cur CURSOR FOR 
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    student_loop: LOOP
        FETCH cur INTO student_id;
        IF done THEN
            LEAVE student_loop;
        END IF;

        SET pref = 1;
        SET subject_found = FALSE;

        pref_loop: WHILE pref <= 5 DO
            SELECT SubjectId INTO sub_id
            FROM StudentPreference 
            WHERE StudentId = student_id AND Preference = pref;

            IF EXISTS (
                SELECT 1 FROM SubjectDetails 
                WHERE SubjectId = sub_id AND RemainingSeats > 0
            ) THEN
                INSERT INTO Allotments VALUES (sub_id, student_id);
                UPDATE SubjectDetails 
                SET RemainingSeats = RemainingSeats - 1 
                WHERE SubjectId = sub_id;
                SET subject_found = TRUE;
                LEAVE pref_loop;
            END IF;

            SET pref = pref + 1;
        END WHILE;

        IF subject_found = FALSE THEN
            INSERT INTO UnallotedStudents VALUES (student_id);
        END IF;

    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;

CALL AllotSubjects();

SELECT * FROM Allotments;
SELECT * FROM UnallotedStudents;
