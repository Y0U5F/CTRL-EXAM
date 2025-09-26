-------------------------Moaaz-----------------------------------

CREATE TABLE dbo.ManagerLog (
    LogID         INT IDENTITY(1,1) PRIMARY KEY,
    ManagerID     INT,               -- TrainingManagerID
    TableName     SYSNAME,
    ActionType    VARCHAR(10),
    ActionDate    DATETIME DEFAULT GETDATE(),
    Description   VARCHAR(200) NULL
);


CREATE TABLE dbo.AuditLog (
    LogID       INT IDENTITY(1,1) PRIMARY KEY,
    TableName   SYSNAME,
    ActionType  VARCHAR(10),
    PerformedBy SYSNAME,
    ActionDate  DATETIME DEFAULT GETDATE()
);

---------------------------------------------------------

go
-------------------------Asmaa-----------------------------------

---Students
CREATE or ALTER TRIGGER trg_Students_Audit
ON dbo.Students
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action VARCHAR(10);
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE IF EXISTS (SELECT 1 FROM deleted)
        SET @action = 'DELETE';

    INSERT INTO dbo.AuditLog(TableName, ActionType, PerformedBy)
    VALUES ('Students', @action, SUSER_SNAME());

    PRINT ' Operation logged in AuditLog table.';
END;
go
-------------------------Esraa-----------------------------------

CREATE or ALTER TRIGGER trg_Exams_Audit
ON dbo.Exams
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action VARCHAR(10);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE IF EXISTS (SELECT 1 FROM deleted)
        SET @action = 'DELETE';

    INSERT INTO dbo.AuditLog(TableName, ActionType, PerformedBy)
    VALUES ('Exams', @action, SUSER_SNAME());

    PRINT ' Operation logged in AuditLog table.';
END;
--SELECT * FROM dbo.AuditLog ORDER BY LogID DESC;


-------------------------Ahmed----------------------------------

go
CREATE TRIGGER dbo.trg_Manager_Branches
ON dbo.Branches
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @action    VARCHAR(10);
    DECLARE @managerId INT;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE
        SET @action = 'DELETE';


    SELECT TOP (1) @managerId = TrainingManagerID FROM inserted;
    IF @managerId IS NULL
        SELECT TOP (1) @managerId = TrainingManagerID FROM deleted;

    INSERT INTO dbo.ManagerLog (ManagerID, TableName, ActionType, Description)
    VALUES (@managerId, 'Branches', @action, 'Manager changed branch info');

    PRINT ' Manager action logged in ManagerLog table';
END;
GO


-------------------------Yossef-----------------------------------

CREATE or ALTER TRIGGER trg_Manager_Tracks
ON dbo.Tracks
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action VARCHAR(10);
    DECLARE @managerId INT;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE IF EXISTS (SELECT 1 FROM deleted)
        SET @action = 'DELETE';


    SET @managerId = NULL;

    INSERT INTO dbo.ManagerLog(ManagerID, TableName, ActionType, Description)
    VALUES(@managerId, 'Tracks', @action, 'Manager changed track info');
END;
GO

CREATE or ALTER TRIGGER trg_Manager_Intakes
ON dbo.Intakes
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action VARCHAR(10);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SET @action = 'INSERT';
    ELSE IF EXISTS (SELECT 1 FROM deleted)
        SET @action = 'DELETE';

    INSERT INTO dbo.ManagerLog(ManagerID, TableName, ActionType, Description)
    VALUES(NULL, 'Intakes', @action, 'Manager changed intake info')
END;
GO


SELECT 
    L.LogID, 
    L.ActionDate, 
    TM.FirstName + ' ' + TM.LastName AS ManagerName,
    L.TableName,
    L.ActionType,
    L.Description
FROM dbo.ManagerLog L
LEFT JOIN dbo.TrainingManager TM ON L.ManagerID = TM.TrainingManagerID
ORDER BY L.LogID DESC


go
-------------------------Bishoy-----------------------------------

CREATE OR ALTER TRIGGER dbo.TRG_Exams_AutoEndTime
ON dbo.Exams
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH NewVals AS (
        SELECT e.ExamID,
               NewEnd = DATEADD(MINUTE, e.ExamDuration, e.StartDateTime)
        FROM dbo.Exams e
        JOIN inserted i ON i.ExamID = e.ExamID
    )
    UPDATE e
    SET e.EndDateTime = n.NewEnd
    FROM dbo.Exams e
    JOIN NewVals n ON n.ExamID = e.ExamID
    WHERE e.EndDateTime <> n.NewEnd;   
END
GO
-----------------------------------------------------------------------
DECLARE @CourseID INT, @InstructorID INT, @BIT INT;

SELECT TOP (1)
       @CourseID = c.CourseID,
       @InstructorID = c.InstructorID,
       @BIT = i.BranchIntakeTrackID
FROM dbo.Courses c
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
ORDER BY c.CourseID;   

INSERT INTO dbo.Exams
(ExamTitle, ExamType, TotalDegrees, ExamDuration, StartDateTime, EndDateTime,
 IsRandomOrder, QuestionsNumbers, CourseID, InstructorID, BranchIntakeTrackID, ExamMark)
VALUES
('Test Auto End', 'Final', 100, 75,
 '2025-12-01T10:00:00',
 DATEADD(MINUTE, 75, '2025-12-01T10:00:00'),
 0, 3, @CourseID, @InstructorID, @BIT, 100);

