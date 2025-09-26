
--CREATE DATABASE ITIExaminationSystem
-------------------------Asmaa-----------------------------------
CREATE TABLE dbo.Users (
    UserID       INT            IDENTITY(1,1) PRIMARY KEY,
    Username     VARCHAR(50)    NOT NULL UNIQUE,
    [Password]   VARCHAR(255)   NOT NULL,
    UserType     VARCHAR(20)    NOT NULL
);
GO

-- 2) TrainingManager
CREATE TABLE dbo.TrainingManager (
    TrainingManagerID INT            IDENTITY(1,1) PRIMARY KEY,
    UserID            INT            NOT NULL,
    NationalID        CHAR(14)       NOT NULL,
    FirstName         VARCHAR(50)    NOT NULL,
    LastName          VARCHAR(50)    NOT NULL,
    Email             VARCHAR(100)   NOT NULL,
    Phone             VARCHAR(15)    NULL,
    HireDate          DATE           NULL,
    IsActive          BIT            NOT NULL DEFAULT(1),
    CONSTRAINT FK_TM_User FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
);
GO

-- 3) Branches
CREATE TABLE dbo.Branches (
    BranchID           INT            IDENTITY(1,1) PRIMARY KEY,
    BranchName         VARCHAR(100)   NOT NULL,
    [Description]      VARCHAR(500)   NULL,
    BranchEmail        VARCHAR(100)   NOT NULL,
    BranchPhone        VARCHAR(15)    NULL,
    TrainingManagerID  INT            NOT NULL,
    CONSTRAINT FK_Branches_TM FOREIGN KEY (TrainingManagerID) REFERENCES dbo.TrainingManager(TrainingManagerID)
);
GO

-- 4) Intakes
CREATE TABLE dbo.Intakes (
    IntakeID           INT            IDENTITY(1,1) PRIMARY KEY,
    IntakeName         VARCHAR(50)    NOT NULL,
    StartDate          DATE           NOT NULL,
    EndDate            DATE           NOT NULL,
    IntakeYear         INT            NOT NULL
);
GO
-------------------------Esraa-----------------------------------

-- 5) Department
CREATE TABLE dbo.Department (
    DepartmentID     INT NOT NULL PRIMARY KEY,
    TrackID          INT NOT NULL,
    DepartmentName   VARCHAR(50)
);
GO

-- 6) Tracks
CREATE TABLE dbo.Tracks (
    TrackID       INT            IDENTITY(1,1) PRIMARY KEY,
    TrackName     VARCHAR(100)   NOT NULL,
    [Description] VARCHAR(500)   NULL,
    IsActive      BIT            NOT NULL DEFAULT(1),
    DepartmentID  INT            NOT NULL,
    CONSTRAINT FK_Department_Track FOREIGN KEY (DepartmentID) REFERENCES dbo.Department(DepartmentID)
);
GO

-- 7) BranchIntakeTrack
CREATE TABLE dbo.BranchIntakeTrack (
    BranchIntakeTrackID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT NOT NULL,
    IntakeID INT NOT NULL,
    TrackID  INT NOT NULL,
    CONSTRAINT FK_BIT_B FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
    CONSTRAINT FK_BIT_I FOREIGN KEY (IntakeID) REFERENCES dbo.Intakes(IntakeID),
    CONSTRAINT FK_BIT_T FOREIGN KEY (TrackID)  REFERENCES dbo.Tracks(TrackID)
);
GO

-- 8) Students
CREATE TABLE dbo.Students (
    StudentID      INT            IDENTITY(1,1) PRIMARY KEY,
    UserID         INT            NOT NULL,
    NationalID     CHAR(14)       NOT NULL,
    FirstName      VARCHAR(50)    NOT NULL,
    LastName       VARCHAR(50)    NOT NULL,
    Email          VARCHAR(100)   NOT NULL,
    Phone          VARCHAR(15)    NULL,
    Address        VARCHAR(200)   NULL,
    EnrollmentDate DATE           NOT NULL,
    BranchIntakeTrackID INT NOT NULL,
    IsActive       BIT            NOT NULL DEFAULT(1),
    CONSTRAINT FK_Students_User FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_BranchIntakeTrack FOREIGN KEY (BranchIntakeTrackID) REFERENCES dbo.BranchIntakeTrack(BranchIntakeTrackID)
);
GO
-------------------------Bishoy-----------------------------------

-- 9) Instructors
CREATE TABLE dbo.Instructors (
    InstructorID   INT            IDENTITY(1,1) PRIMARY KEY,
    UserID         INT            NOT NULL,
    FirstName      VARCHAR(50)    NOT NULL,
    NationalID     CHAR(14)       NOT NULL,
    LastName       VARCHAR(50)    NOT NULL,
    Email          VARCHAR(100)   NOT NULL,
    Phone          VARCHAR(15)    NULL,
    Specialization VARCHAR(100)   NULL,
    HireDate       DATE           NULL,
    IsActive       BIT            NOT NULL DEFAULT(1),
    BranchIntakeTrackID INT NOT NULL,
    CONSTRAINT FK_Instructors_User FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_Instructors_BIT FOREIGN KEY (BranchIntakeTrackID) REFERENCES dbo.BranchIntakeTrack(BranchIntakeTrackID)
);
GO

-- 10) Courses
CREATE TABLE dbo.Courses (
    CourseID          INT            IDENTITY(1,1) PRIMARY KEY,
    TrackID           INT            NOT NULL,
    InstructorID      INT            NOT NULL,
    CourseName        VARCHAR(100)   NOT NULL,
    CourseDescription VARCHAR(500)   NULL,
    MaxDegree         INT            NOT NULL,
    MinDegree         INT            NOT NULL,
    CourseHours       INT            NOT NULL,
    IsActive          BIT            NOT NULL DEFAULT(1),
    CONSTRAINT FK_Courses_Track FOREIGN KEY (TrackID) REFERENCES dbo.Tracks(TrackID),
    CONSTRAINT FK_Courses_Inst FOREIGN KEY (InstructorID) REFERENCES dbo.Instructors(InstructorID)
);
GO

-- 11) Exams
CREATE TABLE dbo.Exams (
    ExamID           INT            IDENTITY(1,1) PRIMARY KEY,
    ExamTitle        VARCHAR(200)   NOT NULL,
    ExamType         VARCHAR(20)    NOT NULL,
    TotalDegrees     INT            NOT NULL,
    ExamDuration     INT            NOT NULL,
    StartDateTime    DATETIME       NOT NULL,
    EndDateTime      DATETIME       NOT NULL,
    IsRandomOrder    BIT            NOT NULL DEFAULT(0),
    QuestionsNumbers INT            NOT NULL,
    CourseID         INT            NOT NULL,
    InstructorID     INT            NOT NULL,
    BranchIntakeTrackID INT         NOT NULL,
    ExamMark         INT            NOT NULL,
    CONSTRAINT FK_Exams_Course     FOREIGN KEY (CourseID) REFERENCES dbo.Courses(CourseID),
    CONSTRAINT FK_Exams_Instructor FOREIGN KEY (InstructorID) REFERENCES dbo.Instructors(InstructorID),
    CONSTRAINT FK_Exams_Context    FOREIGN KEY (BranchIntakeTrackID) REFERENCES dbo.BranchIntakeTrack(BranchIntakeTrackID)
);
GO

-- 12) Questions
CREATE TABLE dbo.Questions (
    QuestionID      INT            IDENTITY(1,1) PRIMARY KEY,
    QuestionText    TEXT           NOT NULL,
    QuestionType    VARCHAR(20)    NOT NULL,
    CourseID        INT            NOT NULL,
    InstructorID    INT            NOT NULL,
    CorrectAnswer   TEXT           NULL,
    DifficultyLevel VARCHAR(10)    NULL,
    CONSTRAINT FK_Questions_Course     FOREIGN KEY (CourseID) REFERENCES dbo.Courses(CourseID),
    CONSTRAINT FK_Questions_Instructor FOREIGN KEY (InstructorID) REFERENCES dbo.Instructors(InstructorID)
);
GO
-------------------------Ahmed-----------------------------------

-- 13) QuestionChoices
CREATE TABLE dbo.QuestionChoices (
    ChoiceQID     INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID    INT NOT NULL,
    ChoiceTextQ   VARCHAR(500) NOT NULL,
    ChoiceLetter  CHAR(1) NOT NULL,
    IsCorrect     BIT NOT NULL,
    CONSTRAINT FK_MCQ_Question FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID)
);
GO

-- 14) QuestionText
CREATE TABLE dbo.QuestionText (
    TextQID      INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID   INT NOT NULL,
    TextQText    VARCHAR(500) NOT NULL,
    TextAnswer   NVARCHAR(500) NOT NULL,
    AcceptedPattern TEXT NULL,
    IsCorrect    BIT NOT NULL,
    CONSTRAINT FK_TextQ_Question FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID)
);
GO

-- 15) QuestionsExam
CREATE TABLE dbo.QuestionsExam (
    ExamID         INT NOT NULL,
    QuestionID     INT NOT NULL,
    QuestionDegree INT NOT NULL,
    QuestionOrder  INT NOT NULL,
    CONSTRAINT PK_EQ PRIMARY KEY (ExamID, QuestionID),
    CONSTRAINT FK_EQ_Exam     FOREIGN KEY (ExamID) REFERENCES dbo.Exams(ExamID),
    CONSTRAINT FK_EQ_Question FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID)
);
GO

-- 16) StudentsExam
CREATE TABLE dbo.StudentsExam (
    ExamID       INT     NOT NULL,
    StudentID    INT     NOT NULL,
    AssignedDate DATETIME NOT NULL,
    StudentMark  DECIMAL(5,2) NOT NULL,
    StartDateTime DATETIME NOT NULL,
    EndDateTime   DATETIME NULL,
    CONSTRAINT PK_ExamStudents PRIMARY KEY (ExamID, StudentID),
    CONSTRAINT FK_ES_Exam    FOREIGN KEY (ExamID)    REFERENCES dbo.Exams(ExamID),
    CONSTRAINT FK_ES_Student FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID)
);
GO
-------------------------Yossef-----------------------------------

-- 17) CorrectiveExam
CREATE TABLE dbo.CorrectiveExam (
    CorrectiveExamID INT IDENTITY(1,1) PRIMARY KEY,
    ExamID           INT NOT NULL,
    Reason           NVARCHAR(500) NULL,
    ApprovedBy       INT NULL,
    IsApproved       BIT NOT NULL DEFAULT(0),
    QuestionsNumbers INT NOT NULL,
    CONSTRAINT FK_CE_Exam     FOREIGN KEY (ExamID) REFERENCES dbo.Exams(ExamID),
    CONSTRAINT FK_CE_Approver FOREIGN KEY (ApprovedBy) REFERENCES dbo.Instructors(InstructorID)
);
GO

-- 18) StudentAnswers
CREATE TABLE dbo.StudentAnswers (
    AnswerID      INT IDENTITY(1,1) PRIMARY KEY,
    ExamID        INT NULL,
    StudentID     INT NULL,
    QuestionID    INT NOT NULL,
    StudentAnswer TEXT NOT NULL,
    IsCorrect     BIT NOT NULL,
    MarksObtained DECIMAL(5,2) NOT NULL,
    ManualReview  BIT NOT NULL DEFAULT(0),
    ReviewedBy    INT NULL,
    CONSTRAINT FK_SA_Question FOREIGN KEY (QuestionID) REFERENCES dbo.Questions(QuestionID),
    CONSTRAINT FK_SA_Reviewer FOREIGN KEY (ReviewedBy) REFERENCES dbo.Instructors(InstructorID),
    CONSTRAINT FK_SA_Exam     FOREIGN KEY (ExamID) REFERENCES dbo.Exams(ExamID),
    CONSTRAINT FK_SA_Student  FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID)
);
GO

-- 19) StudentCourse
CREATE TABLE dbo.StudentCourse (
    StudentID   INT NOT NULL,
    CourseID    INT NOT NULL,
    TotalScore  DECIMAL(5,2) NOT NULL,
    FinalGrade  VARCHAR(2) NULL,
    CONSTRAINT PK_SC PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_SC_Student FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    CONSTRAINT FK_SC_Course  FOREIGN KEY (CourseID)  REFERENCES dbo.Courses(CourseID)
);
GO
