-------------------------Bishoy&Esraa-----------------------------------
---- Exams available to the student
CREATE OR ALTER VIEW v_Student_Exams
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
    i.FirstName + ' ' + i.LastName AS InstructorName
FROM dbo.Exams e
JOIN dbo.Courses c ON e.CourseID = c.CourseID
JOIN dbo.Instructors i ON e.InstructorID = i.InstructorID
JOIN dbo.StudentsExam se ON e.ExamID = se.ExamID
JOIN dbo.Students s ON se.StudentID = s.StudentID
JOIN dbo.Users u ON s.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

---- Exam questions intended for the student
CREATE OR ALTER VIEW v_Student_ExamQuestions
AS
SELECT 
    qe.ExamID,
    q.QuestionID,
    q.QuestionText,
    q.QuestionType,
    qc.ChoiceLetter,
    qc.ChoiceTextQ
FROM dbo.QuestionsExam qe
JOIN dbo.Questions q ON qe.QuestionID = q.QuestionID
LEFT JOIN dbo.QuestionChoices qc ON q.QuestionID = qc.QuestionID
JOIN dbo.Exams e ON qe.ExamID = e.ExamID
JOIN dbo.StudentsExam se ON e.ExamID = se.ExamID
JOIN dbo.Students s ON se.StudentID = s.StudentID
JOIN dbo.Users u ON s.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

--Student answers only
CREATE OR ALTER VIEW v_Student_Answers
AS
SELECT 
    sa.AnswerID,
    sa.ExamID,
    sa.StudentID,
    q.QuestionText,
    sa.StudentAnswer,
    sa.IsCorrect,
    sa.MarksObtained
FROM dbo.StudentAnswers sa
JOIN dbo.Questions q ON sa.QuestionID = q.QuestionID
JOIN dbo.Students s ON sa.StudentID = s.StudentID
JOIN dbo.Users u ON s.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- Fullmark (Transcript)
CREATE OR ALTER VIEW v_Student_CourseGrades
AS
SELECT 
    sc.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    c.CourseName,
    sc.TotalScore,
    sc.FinalGrade
FROM dbo.StudentCourse sc
JOIN dbo.Students s ON sc.StudentID = s.StudentID
JOIN dbo.Users u ON s.UserID = u.UserID
JOIN dbo.Courses c ON sc.CourseID = c.CourseID
WHERE u.Username = SUSER_SNAME();
GO

-- Exams assigned to the student (Assignments)
CREATE OR ALTER VIEW v_Student_AssignedExams
AS
SELECT 
    se.ExamID,
    se.StudentID,
    se.AssignedDate,
    se.StartDateTime,
    se.EndDateTime,
    se.StudentMark
FROM dbo.StudentsExam se
JOIN dbo.Students s ON se.StudentID = s.StudentID
JOIN dbo.Users u ON s.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO


--------------------------------------

-- The student answers a question
CREATE OR ALTER PROCEDURE sp_StudentSubmitAnswer
    @ExamID INT,
    @QuestionID INT,
    @StudentAnswer NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentID INT;

    -- Retrieve StudentID from current user
    SELECT @StudentID = s.StudentID
    FROM dbo.Students s
    JOIN dbo.Users u ON s.UserID = u.UserID
    WHERE u.Username = SUSER_SNAME();

    -- insert the answer
    INSERT INTO dbo.StudentAnswers (ExamID, StudentID, QuestionID, StudentAnswer, IsCorrect, MarksObtained)
    VALUES (@ExamID, @StudentID, @QuestionID, @StudentAnswer, 0, 0); 
END;
GO

-- Views
GRANT SELECT ON v_Student_Exams TO role_Student;
GRANT SELECT ON v_Student_ExamQuestions TO role_Student;
GRANT SELECT ON v_Student_Answers TO role_Student;
GRANT SELECT ON v_Student_CourseGrades TO role_Student;
GRANT SELECT ON v_Student_AssignedExams TO role_Student;

-- Procedures
GRANT EXECUTE ON sp_StudentSubmitAnswer TO role_Student;
--GRANT EXECUTE ON sp_AssignExamToStudent TO role_Student;


REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.Exams TO role_Student;
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.Questions TO role_Student;
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.QuestionChoices TO role_Student;
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.StudentAnswers TO role_Student;
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.StudentsExam TO role_Student;


-- Friendly student-assigned-exams view (per current login)
CREATE OR ALTER VIEW dbo.v_Student_AssignedExams_Friendly
AS
SELECT
    e.ExamID,
    e.ExamTitle,
    c.CourseName,
    se.AssignedDate,
    se.StartDateTime,
    se.EndDateTime,
    se.StudentMark,
    -- Friendly time message
    CASE 
        WHEN e.StartDateTime > SYSDATETIME() THEN
            N'Starts in ' 
            + CAST(DATEDIFF(DAY, SYSDATETIME(), e.StartDateTime) AS NVARCHAR(10)) + N' '
            + CASE WHEN DATEDIFF(DAY, SYSDATETIME(), e.StartDateTime) = 1 THEN N'day' ELSE N'days' END
        WHEN e.EndDateTime < SYSDATETIME() THEN
            N'Finished ' 
            + CAST(DATEDIFF(DAY, e.EndDateTime, SYSDATETIME()) AS NVARCHAR(10)) + N' '
            + CASE WHEN DATEDIFF(DAY, e.EndDateTime, SYSDATETIME()) = 1 THEN N'day' ELSE N'days' END
            + N' ago'
        ELSE
            CASE 
                WHEN DATEDIFF(MINUTE, SYSDATETIME(), e.EndDateTime) >= 60 THEN
                    N'In progress — '
                    + CAST(DATEDIFF(HOUR, SYSDATETIME(), e.EndDateTime) AS NVARCHAR(10)) + N' '
                    + CASE WHEN DATEDIFF(HOUR, SYSDATETIME(), e.EndDateTime) = 1 THEN N'hour' ELSE N'hours' END
                    + N' left'
                ELSE
                    N'In progress — '
                    + CAST(DATEDIFF(MINUTE, SYSDATETIME(), e.EndDateTime) AS NVARCHAR(10)) + N' '
                    + CASE WHEN DATEDIFF(MINUTE, SYSDATETIME(), e.EndDateTime) = 1 THEN N'minute' ELSE N'minutes' END
                    + N' left'
            END
    END AS TimeMessage,
    CASE 
        WHEN e.StartDateTime > SYSDATETIME() THEN 'Upcoming'
        WHEN e.EndDateTime   < SYSDATETIME() THEN 'Finished'
        ELSE 'In Progress'
    END AS ExamStatus
FROM dbo.StudentsExam se
JOIN dbo.Students    s  ON s.StudentID = se.StudentID
JOIN dbo.Users       u  ON u.UserID    = s.UserID
JOIN dbo.Exams       e  ON e.ExamID    = se.ExamID
JOIN dbo.Courses     c  ON c.CourseID  = e.CourseID
WHERE u.Username = SUSER_SNAME();  
GO

GRANT SELECT ON dbo.v_Student_AssignedExams_Friendly TO role_Student;
GO
-----------------------------------------------------------------------------------------------------------------------------------
-------------------------Ahmed&Asmaa-----------------------------------
-- Courses assigned to the current Instructor
CREATE OR ALTER VIEW v_Instructor_Courses
AS
SELECT 
    c.CourseID,
    c.CourseName,
    c.CourseDescription,
    c.CourseHours,
    c.MaxDegree,
    c.MinDegree,
    c.IsActive,
    t.TrackName,
    i.FirstName + ' ' + i.LastName AS InstructorName
FROM dbo.Courses c
JOIN dbo.Tracks t ON c.TrackID = t.TrackID
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
JOIN dbo.Users u ON i.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- Students and their grades in the Instructor’s courses
CREATE OR ALTER VIEW v_Instructor_StudentsGrades
AS
SELECT 
    sc.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    c.CourseName,
    sc.TotalScore,
    sc.FinalGrade
FROM dbo.StudentCourse sc
JOIN dbo.Courses c ON sc.CourseID = c.CourseID
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
JOIN dbo.Users u ON i.UserID = u.UserID
JOIN dbo.Students s ON sc.StudentID = s.StudentID
WHERE u.Username = SUSER_SNAME();
GO

-- Exams related to the Instructor’s courses
CREATE OR ALTER VIEW v_Instructor_Exams
AS
SELECT 
    e.ExamID,
    e.ExamTitle,
    e.ExamType,
    e.TotalDegrees,
    e.ExamDuration,
    e.StartDateTime,
    e.EndDateTime,
    c.CourseName
FROM dbo.Exams e
JOIN dbo.Courses c ON e.CourseID = c.CourseID
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
JOIN dbo.Users u ON i.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

-- Questions related to the Instructor’s courses
CREATE OR ALTER VIEW v_Instructor_Questions
AS
SELECT 
    q.QuestionID,
    q.QuestionText,
    q.QuestionType,
    c.CourseName
FROM dbo.Questions q
JOIN dbo.Courses c ON q.CourseID = c.CourseID
JOIN dbo.Instructors i ON c.InstructorID = i.InstructorID
JOIN dbo.Users u ON i.UserID = u.UserID
WHERE u.Username = SUSER_SNAME();
GO

--------------------------------------------------------------------------

-- Add a new Exam
-- إضافة امتحان جديد
CREATE OR ALTER PROCEDURE sp_Instructor_AddExam
    @CourseID INT,
    @ExamTitle NVARCHAR(200),
    @ExamType NVARCHAR(20),
    @TotalDegrees INT,
    @ExamDuration INT,
    @StartDateTime DATETIME,
    @EndDateTime DATETIME,
    @IsRandomOrder BIT = 0,
    @QuestionsNumbers INT,
    @BranchIntakeTrackID INT,
    @ExamMark INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InstructorID INT;

    -- instructor الحالي
    SELECT @InstructorID = i.InstructorID
    FROM dbo.Instructors i
    JOIN dbo.Users u ON i.UserID = u.UserID
    WHERE u.Username = SUSER_SNAME();

    -- تأكد إن الكورس تابع للـ Instructor الحالي
    IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE CourseID = @CourseID AND InstructorID = @InstructorID)
    BEGIN
        RAISERROR('You are not authorized to add exams to this course.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Exams
        (ExamTitle, ExamType, TotalDegrees, ExamDuration, StartDateTime, EndDateTime, IsRandomOrder, QuestionsNumbers, CourseID, InstructorID, BranchIntakeTrackID, ExamMark)
    VALUES
        (@ExamTitle, @ExamType, @TotalDegrees, @ExamDuration, @StartDateTime, @EndDateTime, @IsRandomOrder, @QuestionsNumbers, @CourseID, @InstructorID, @BranchIntakeTrackID, @ExamMark);
END;
GO

-- Assign a Student to an Exam
CREATE OR ALTER PROCEDURE sp_Instructor_AssignStudentToExam
    @ExamID INT,
    @StudentID INT,
    @StartDateTime DATE,
    @EndDateTime DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InstructorID INT, @CourseID INT;

    -- instructor الحالي
    SELECT @InstructorID = i.InstructorID
    FROM dbo.Instructors i
    JOIN dbo.Users u ON i.UserID = u.UserID
    WHERE u.Username = SUSER_SNAME();

    -- تأكد إن الامتحان تبع كورس بيدرسه
    SELECT @CourseID = c.CourseID
    FROM dbo.Exams e
    JOIN dbo.Courses c ON e.CourseID = c.CourseID
    WHERE e.ExamID = @ExamID AND c.InstructorID = @InstructorID;

    IF @CourseID IS NULL
    BEGIN
        RAISERROR('You are not authorized to assign students to this exam.', 16, 1);
        RETURN;
    END

    -- تسجيل الطالب
    INSERT INTO dbo.StudentsExam (ExamID, StudentID, AssignedDate, StudentMark,StartDateTime,EndDateTime)
    VALUES (@ExamID, @StudentID, GETDATE(), 0,@StartDateTime,@EndDateTime );
END;
GO
---------------------------------------------------------------------------------

-- Courses of the Instructor
GRANT SELECT ON v_Instructor_Courses TO role_Instructor;

-- Exams created by the Instructor
GRANT SELECT ON v_Instructor_Exams TO role_Instructor;

-- Questions of the Instructor’s courses
GRANT SELECT ON v_Instructor_ExamQuestions TO role_Instructor;

-- Students registered in the Instructor’s exams
GRANT SELECT ON v_Instructor_ExamStudents TO role_Instructor;

-- Student answers to the Instructor’s questions
GRANT SELECT ON v_Instructor_StudentAnswers TO role_Instructor;

------

-- Revoke all permissions from Instructor
REVOKE SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM role_Instructor;
GO

-- Grant SELECT permissions on the Instructor’s views
GRANT SELECT ON v_Instructor_Courses TO role_Instructor;
GRANT SELECT ON v_Instructor_Exams TO role_Instructor;
GRANT SELECT ON v_Instructor_ExamQuestions TO role_Instructor;
GRANT SELECT ON v_Instructor_ExamStudents TO role_Instructor;
GRANT SELECT ON v_Instructor_StudentAnswers TO role_Instructor;

-- Grant EXECUTE permission on Stored Procedure to add an Exam (example)
GRANT EXECUTE ON sp_Instructor_AddExam TO role_Instructor;

-- Grant EXECUTE permission on Stored Procedure to assign students to an Exam (example)
GRANT EXECUTE ON sp_Instructor_AssignStudentToExam TO role_Instructor;

----------------------------------------------------------------------------------

SELECT * 
FROM sys.views 
WHERE name IN ('v_Instructor_ExamQuestions', 'v_Instructor_ExamStudents', 'v_Instructor_StudentAnswers');

SELECT SCHEMA_NAME(schema_id) AS SchemaName, name 
FROM sys.views
WHERE name LIKE 'v_Instructor%';

GRANT SELECT ON dbo.v_Instructor_Courses TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_Exams TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_Questions TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_StudentsGrades TO role_Instructor;

-----------------------------------------------------------------------------------------------------------
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

 

