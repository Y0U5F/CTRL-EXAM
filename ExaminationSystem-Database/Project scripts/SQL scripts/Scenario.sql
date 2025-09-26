
EXEC sec.ProvisionAppUserLogin
     @AppUsername   = 'inst_rahma',
     @LoginPassword = 'inst456';

EXEC sec.ProvisionAppUserLogin
     @AppUsername   = 'stud_ahmed',
     @LoginPassword = 'stud123';

EXEC sec.ProvisionAppUserLogin
     @AppUsername   = 'tm_mohammed',
     @LoginPassword = 'tm456';

EXEC sec.ProvisionAppUserLogin
     @AppUsername   = 'admin',
     @LoginPassword = 'admin123';


     EXEC sec.ProvisionAppUserLogin
     @AppUsername   = 'stud_omar',
     @LoginPassword = 'stud108';

--------------------------------------------------------------
--------------------------------------------------------------
--Log in by username : tm_mohammed Password : tm456
SELECT * from dbo.v_Manager_Branches
SELECT * from dbo.v_Manager_Courses
SELECT * from dbo.v_Manager_Students



EXEC AddInstructorByManager
    @ManagerUserID = 3,  
    @Username = 'Ehab.inst',
    @Password = 'inst0987',
    @NationalID = '98765432101234',
    @FirstName = 'Ehab',
    @LastName = 'Hassan',
    @Email = 'Ehab.hassan@example.com',
    @Phone = '01000000002',
    @HireDate='',
    @Specialization = 'Database',
    @BranchIntakeTrackID = 1;


   EXEC dbo.AddStudentByManager
    @ManagerUserID = 3,
    @Username = 'kenzy.stud',
    @Password = '123456',
    @NationalID = '82345678901234',
    @FirstName = 'kenzy',
    @LastName = 'ahmed',
    @Email = 'kenzy@student.com',
    @Phone = '01000080000',
    @Address = 'giza',
    @EnrollmentDate = '2025-08-18',
    @BranchIntakeTrackID = 1;


    EXEC sec.sp_ManagerAddBranch 
    'Nasr_City' ,'NasrCity@gmail.com' ,'01999643501'

    EXEC sec.sp_ManagerAddIntake
    'Intake 48' ,'2027-07-30','2028-07-30',2028


    EXEC sec.sp_ManagerDeleteBranch 8

-----------------------------------------------------------
-----------------------------------------------------------

--Log in by username : inst_rahma Password : inst456
SELECT * FROM dbo.v_Instructor_Courses
select * from dbo.v_Instructor_Exams
select * from dbo.v_Instructor_Questions
select * from dbo.v_Instructor_StudentsGrades


EXEC dbo.sp_Instructor_AddExam 7,'Python Data Science Mid','Mid',50,60,'2025-05-20 14:00:00.000','2025-05-20 15:00:00.000',1,10,1,50
EXEC dbo.sp_Instructor_AssignStudentToExam 13,13,'2025-05-20 14:00:00.000','2025-05-20 15:00:00.000'

--------------------------------------------------------------
--------------------------------------------------------------

--Log in by username : stud_ahmed Password : stud123
SELECT * FROM v_Student_Exams;
SELECT * FROM v_Student_ExamQuestions;
SELECT * FROM v_Student_Answers;
SELECT * FROM v_Student_CourseGrades;
SELECT * FROM v_Student_AssignedExams;
SELECT * FROM v_Student_AssignedExams_Friendly;

EXEC sp_StudentSubmitAnswer 
     @ExamID = 3,
     @QuestionID = 2,
     @StudentAnswer = 'B';

-------------------------------------------------------------
-------------------------------------------------------------
--Functions 
SELECT dbo.FN_CalculateExamResult(2, 4) AS StudentTotalMark; 
SELECT dbo.FN_GetTotallEnrollmentStudent() AS TotalStudents;
SELECT dbo.FN_CheckTextAnswer('The CSS box model', 4, 1) AS CheckText;
SELECT dbo.FN_CheckMultipleChoiceAnswer(4, 8, 2) AS TF_Result;
SELECT * FROM dbo.FN_GetExamDetails(3);
SELECT * FROM dbo.dashboardOfExam(4);

------------------------------------------------------------
------------------------------------------------------------
