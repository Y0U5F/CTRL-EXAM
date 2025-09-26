------------------------------Moaaz&Yossef------------------------------
-- 1) All branches for the current Manager
CREATE OR ALTER VIEW dbo.v_Manager_Branches
AS
SELECT 
    b.BranchID,
    b.BranchName,
    b.BranchEmail,
    b.BranchPhone,
    tm.FirstName + ' ' + tm.LastName AS ManagerName
FROM dbo.Branches b
JOIN dbo.TrainingManager tm ON b.TrainingManagerID = tm.TrainingManagerID
JOIN dbo.Users u ON tm.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- 2) All students in the current Manager’s branches
CREATE OR ALTER VIEW dbo.v_Manager_Students
AS
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.Email,
    s.Phone,
    b.BranchName
FROM dbo.Students s
JOIN dbo.BranchIntakeTrack bit ON s.BranchIntakeTrackID = bit.BranchIntakeTrackID
JOIN dbo.Branches b ON bit.BranchID = b.BranchID
JOIN dbo.TrainingManager tm ON b.TrainingManagerID = tm.TrainingManagerID
JOIN dbo.Users u ON tm.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- 3) All courses in the current Manager’s branches
CREATE OR ALTER VIEW dbo.v_Manager_Courses
AS
SELECT 
    c.CourseID,
    c.CourseName,
    c.CourseDescription,
    c.MaxDegree,
    c.MinDegree,
    c.CourseHours,
    i.FirstName + ' ' + i.LastName AS InstructorName,
    b.BranchName
FROM dbo.Courses c
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
JOIN dbo.BranchIntakeTrack bit ON i.BranchIntakeTrackID = bit.BranchIntakeTrackID
JOIN dbo.Branches b ON bit.BranchID = b.BranchID
JOIN dbo.TrainingManager tm ON b.TrainingManagerID = tm.TrainingManagerID
JOIN dbo.Users u ON tm.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- 4) All exams in the current Manager’s branches
CREATE OR ALTER VIEW dbo.v_Manager_Exams
AS
SELECT 
    e.ExamID,
    e.ExamTitle,
    e.ExamType,
    e.TotalDegrees,
    e.ExamDuration,
    e.StartDateTime,
    e.EndDateTime,
    c.CourseName,
    i.FirstName + ' ' + i.LastName AS InstructorName,
    b.BranchName
FROM dbo.Exams e
JOIN dbo.Courses c ON e.CourseID = c.CourseID
JOIN dbo.Instructors i ON e.InstructorID = i.InstructorID
JOIN dbo.BranchIntakeTrack bit ON e.BranchIntakeTrackID = bit.BranchIntakeTrackID
JOIN dbo.Branches b ON bit.BranchID = b.BranchID
JOIN dbo.TrainingManager tm ON b.TrainingManagerID = tm.TrainingManagerID
JOIN dbo.Users u ON tm.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO


-----------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE sec.sp_ManagerAddBranch
    @BranchName VARCHAR(100),
    @BranchEmail VARCHAR(100),
    @BranchPhone VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ManagerID INT;


    SELECT @ManagerID = tm.TrainingManagerID
    FROM dbo.TrainingManager tm
    JOIN dbo.Users u ON tm.UserID = u.UserID
    WHERE u.Username = SUSER_SNAME();

    INSERT INTO dbo.Branches (BranchName, BranchEmail, BranchPhone, TrainingManagerID)
    VALUES (@BranchName, @BranchEmail, @BranchPhone, @ManagerID);
END;
GO

---------------------------------------------------------------------





CREATE OR ALTER PROCEDURE sec.sp_ManagerAddIntake
    @IntakeName VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @IntakeYear INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Intakes (IntakeName, StartDate, EndDate, IntakeYear)
    VALUES (@IntakeName, @StartDate, @EndDate, @IntakeYear);
END;
GO


----------------------------------------------------------------------------------



CREATE OR ALTER PROCEDURE sec.sp_ManagerAddDepartment
    @DepartmentName VARCHAR(50),
    @TrackID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Department (DepartmentName, TrackID)
    VALUES (@DepartmentName, @TrackID);
END;
GO



----------------------------------------------------------------------------

GRANT SELECT ON dbo.v_Manager_Branches TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Students TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Courses TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Exams TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddBranch TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerDeleteBranch TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddIntake TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddDepartment TO role_TrainingManager;

-----------------------------------------------------------------------------


CREATE OR ALTER PROCEDURE sec.sp_ManagerDeleteBranch

    @BranchID INT

AS

BEGIN

    SET NOCOUNT ON;
 
    DECLARE @ManagerID INT;

    DECLARE @UserType VARCHAR(50);
 
    SELECT 

        @ManagerID = tm.TrainingManagerID,

        @UserType = u.UserType

    FROM dbo.Users u

    LEFT JOIN dbo.TrainingManager tm ON tm.UserID = u.UserID

    WHERE u.Username = SUSER_SNAME();
 
    IF @UserType = 'Admin'

    BEGIN

        DELETE FROM dbo.Branches WHERE BranchID = @BranchID;

        RETURN;

    END
    IF EXISTS (SELECT 1 FROM dbo.Branches WHERE BranchID = @BranchID AND TrainingManagerID = @ManagerID)

    BEGIN

        DELETE FROM dbo.Branches WHERE BranchID = @BranchID;

    END

    ELSE

        RAISERROR('You do not have permission to delete this branch.', 16, 1);

END;

GO

 