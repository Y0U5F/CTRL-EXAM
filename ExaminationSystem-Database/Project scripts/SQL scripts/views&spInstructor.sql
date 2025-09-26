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



