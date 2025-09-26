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