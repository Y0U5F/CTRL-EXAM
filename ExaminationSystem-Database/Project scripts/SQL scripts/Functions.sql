-------------------------Asmaa----------------------------------
--1)FN_CheckTextAnswer
CREATE OR ALTER FUNCTION dbo.FN_CheckTextAnswer
(
    @StudentAnswer NVARCHAR(MAX),
    @QuestionID INT,
    @ManualReview BIT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
    DECLARE @AcceptedPattern NVARCHAR(MAX);

    SELECT @AcceptedPattern = CAST(AcceptedPattern AS NVARCHAR(MAX))
    FROM dbo.QuestionText 
    WHERE QuestionID = @QuestionID;

    IF @StudentAnswer LIKE @AcceptedPattern
        SET @Result = 1;
    ELSE
        SET @Result = 0;

    IF @Result <> @ManualReview
        SET @Result = @ManualReview;

    RETURN @Result;
END
GO

-------------------------Esraa-----------------------------------
--2)Calc exam result -> total score
CREATE OR ALTER FUNCTION FN_CalculateExamResult  
(
    @StudentID INT,
    @ExamID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Result DECIMAL(10,2)

   SELECT @Result = SUM(MarksObtained)
   FROM StudentAnswers
   WHERE ExamID =@ExamID AND StudentID = @StudentID

    RETURN @Result
END
GO

--SELECT dbo.FN_CalculateExamResult(2,4) AS TotalScore

-------------------------Bishoy-----------------------------------

--3)Function CalcTotalNumbersOfStudents
CREATE OR ALTER function FN_GetTotallEnrollmentStudent() 
RETURNS INT
AS
BEGIN
    DECLARE @total int;
  SELECT @total=count(StudentID)
  FROM Students
  RETURN @total
END
GO

--SELECT dbo.FN_GetTotallEnrollmentStudent() AS TotalStudent

-------------------------Ahmed-----------------------------------

--4)CheckTFAnswer FUNC
CREATE OR ALTER FUNCTION dbo.FN_CheckTrueFalse
(
    @ExamID INT,
    @QuestionID INT,
    @StudentID INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @IsCorrect BIT
    DECLARE @MarksObtained DECIMAL(10,2)
    DECLARE @Result NVARCHAR(100)

    SELECT 
        @IsCorrect = IsCorrect,
        @MarksObtained = MarksObtained
    FROM StudentAnswers
    WHERE ExamID = @ExamID 
      AND QuestionID = @QuestionID 
      AND StudentID = @StudentID;

    IF @IsCorrect = 1
        SET @Result = 'Correct - Grade: ' + CAST(@MarksObtained AS NVARCHAR)
    ELSE
        SET @Result = 'Wrong - Grade: 0'

    RETURN @Result
END
GO

--SELECT dbo.FN_CheckTrueFalse(4, 8, 2) AS Result

-------------------------Moaaz-----------------------------------

CREATE OR ALTER FUNCTION dbo.FN_GetExamDetails(@ExamID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT E.*, 
           C.CourseName,
           (I.FirstName + ' ' + I.LastName) AS InstructorName
    FROM Exams E
    JOIN Courses C ON E.CourseID = C.CourseID
    JOIN Instructors I ON E.InstructorID = I.InstructorID
    WHERE E.ExamID = @ExamID
);

--SELECT * FROM dbo.FN_GetExamDetails(3)
-------------------------Yossef-----------------------------------

CREATE OR ALTER FUNCTION dbo.dashboardOfExam(@EXAMID INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        COUNT(StudentID) AS Total_Students,
        MAX(StudentMark) AS Toppest_Grade,
        MIN(StudentMark) AS Lowest_Grade,
        AVG(StudentMark) AS AverageMark
    FROM StudentsExam
    WHERE ExamID = @EXAMID
);
GO

--SELECT * FROM dbo.dashboardOfExam(4);
