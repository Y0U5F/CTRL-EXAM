------------------------- Ahmed & Bishoy ---------------------------------------
-- Create Roles 
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Admin')
    CREATE ROLE role_Admin;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_TrainingManager')
    CREATE ROLE role_TrainingManager;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Instructor')
    CREATE ROLE role_Instructor;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Student')
    CREATE ROLE role_Student;
GO

-- Revoke any public permissions on all dbo tables 
REVOKE SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM public;
GO

-- Student
GRANT SELECT ON v_Student_Exams TO role_Student;
GRANT SELECT ON v_Student_ExamQuestions TO role_Student;
GRANT SELECT ON v_Student_Answers TO role_Student;
GRANT SELECT ON v_Student_CourseGrades TO role_Student;
GRANT SELECT ON v_Student_AssignedExams TO role_Student;

-- Procedures
GRANT EXECUTE ON sp_StudentSubmitAnswer TO role_Student;
--GRANT EXECUTE ON sp_AssignExamToStudent TO role_Student;

-- Instructor
GRANT SELECT ON dbo.v_Instructor_Courses TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_Exams TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_Questions TO role_Instructor;
GRANT SELECT ON dbo.v_Instructor_StudentsGrades TO role_Instructor;

-- Grant EXECUTE permission on stored procedure to add an exam 
GRANT EXECUTE ON sp_Instructor_AddExam TO role_Instructor;

-- Grant EXECUTE permission on stored procedure to assign students to exam 
GRANT EXECUTE ON sp_Instructor_AssignStudentToExam TO role_Instructor;

-- Training Manager
GRANT SELECT ON dbo.v_Manager_Branches TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Students TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Courses TO role_TrainingManager;
GRANT SELECT ON dbo.v_Manager_Exams TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddBranch TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerDeleteBranch TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddIntake TO role_TrainingManager;
GRANT EXECUTE ON sec.sp_ManagerAddDepartment TO role_TrainingManager;
GRANT EXECUTE ON AddStudentByManager TO role_TrainingManager;
GRANT EXECUTE ON AddInstructorByManager TO role_TrainingManager;

-- Admin (if you want a full database owner)
EXEC sp_addrolemember 'db_owner', 'role_Admin'
GO

-- Administrative schema for security/permissions
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'sec')
    EXEC('CREATE SCHEMA sec AUTHORIZATION dbo;');
GO

CREATE OR ALTER PROCEDURE sec.ProvisionAppUserLogin
    @AppUsername     VARCHAR(50),     
    @LoginPassword   NVARCHAR(256) 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserType VARCHAR(20);
    SELECT @UserType = UserType
    FROM dbo.Users
    WHERE Username = @AppUsername;

    IF @UserType IS NULL
    BEGIN
        RAISERROR('App user not found in dbo.Users.', 16, 1);
        RETURN;
    END

    DECLARE @loginName SYSNAME = @AppUsername;
    DECLARE @sql NVARCHAR(MAX);

    -- 1) Create SQL Server LOGIN 
    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @loginName)
    BEGIN
        SET @sql = N'CREATE LOGIN ' + QUOTENAME(@loginName) 
                 + N' WITH PASSWORD = ' + QUOTENAME(@LoginPassword,'''') 
                 + N', CHECK_POLICY = OFF;';  -- Set ON if you want strong password policies
        EXEC (@sql);
    END

    -- 2) Create USER inside the database if it does not exist
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @loginName)
    BEGIN
        SET @sql = N'CREATE USER ' + QUOTENAME(@loginName) 
                 + N' FOR LOGIN ' + QUOTENAME(@loginName) + N';';
        EXEC (@sql);
    END

    -- 3) Remove membership from all App Roles first 
    DECLARE @roles TABLE(name SYSNAME);
    INSERT INTO @roles(name)
    VALUES ('role_Admin'), ('role_TrainingManager'), ('role_Instructor'), ('role_Student');

    DECLARE @r SYSNAME;
    DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT name FROM @roles;
    OPEN c;
    FETCH NEXT FROM c INTO @r;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM sys.database_role_members drm
            JOIN sys.database_principals r ON r.principal_id = drm.role_principal_id
            JOIN sys.database_principals u ON u.principal_id = drm.member_principal_id
            WHERE r.name = @r AND u.name = @loginName
        )
        BEGIN
            SET @sql = N'ALTER ROLE ' + QUOTENAME(@r) + N' DROP MEMBER ' + QUOTENAME(@loginName) + N';';
            EXEC (@sql);
        END
        FETCH NEXT FROM c INTO @r;
    END
    CLOSE c; DEALLOCATE c;

    -- 4) Assign role based on UserType in Users table
    DECLARE @targetRole SYSNAME =
        CASE @UserType
            WHEN 'Admin'             THEN 'role_Admin'
            WHEN 'TrainingManager'  THEN 'role_TrainingManager'  -- Make sure string matches what you store
            WHEN 'Instructor'        THEN 'role_Instructor'
            WHEN 'Student'           THEN 'role_Student'
            ELSE NULL
        END;

    IF @targetRole IS NULL
    BEGIN
        RAISERROR('Unsupported or mismatched UserType in dbo.Users.', 16, 1);
        RETURN;
    END

    SET @sql = N'ALTER ROLE ' + QUOTENAME(@targetRole) + N' ADD MEMBER ' + QUOTENAME(@loginName) + N';';
    EXEC (@sql);
END
GO

-------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.AddStudentByManager
    @ManagerUserID INT,     
    @Username VARCHAR(50),
    @Password VARCHAR(255),
    @NationalID CHAR(14),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15) = NULL,
    @Address VARCHAR(200) = NULL,
    @EnrollmentDate DATE,
    @BranchIntakeTrackID INT

AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM dbo.Users 
        WHERE UserID = @ManagerUserID 
          AND UserType = 'TrainingManager'
    )
    BEGIN
        DECLARE @NewUserID INT;

        -- 2) إضافة الطالب كـ User جديد
        INSERT INTO dbo.Users (Username, [Password], UserType)
        VALUES (@Username, @Password, 'Student');

        SET @NewUserID = SCOPE_IDENTITY();

        -- 3) إضافة الطالب لجدول Students
        INSERT INTO dbo.Students
            (UserID, NationalID, FirstName, LastName, Email, Phone, Address, EnrollmentDate, BranchIntakeTrackID)
        VALUES
            (@NewUserID, @NationalID, @FirstName, @LastName, @Email, @Phone, @Address, @EnrollmentDate, @BranchIntakeTrackID);

        PRINT 'Student added successfully by Training Manager.';
    END
    ELSE
    BEGIN
        PRINT 'Access Denied: Only Training Managers can add students.';
    END
END;
GO



CREATE OR ALTER PROCEDURE AddInstructorByManager
    @ManagerUserID INT,         -- Training Manager الذي ينفذ العملية
    @Username VARCHAR(50),
    @Password VARCHAR(255),
    @NationalID CHAR(14),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15),
    @HireDate DATE,
    @Specialization VARCHAR(100),
    @BranchIntakeTrackID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 
        FROM dbo.Users U
        INNER JOIN dbo.TrainingManager TM ON U.UserID = TM.UserID
        WHERE U.UserID = @ManagerUserID
          AND U.UserType = 'TrainingManager'
          AND TM.IsActive = 1
    )
    BEGIN
        DECLARE @NewUserID INT;
        INSERT INTO dbo.Users (Username, [Password], UserType)
        VALUES (@Username, @Password, 'Instructor');
        SET @NewUserID = SCOPE_IDENTITY();
        INSERT INTO dbo.Instructors
            (UserID, FirstName, NationalID, LastName, Email, Phone,
             Specialization, HireDate, BranchIntakeTrackID, IsActive)
        VALUES
            (@NewUserID, @FirstName, @NationalID, @LastName, @Email,
             @Phone, @Specialization, GETDATE(), @BranchIntakeTrackID, 1);
        PRINT 'Instructor added successfully by Training Manager.';
    END
    ELSE
    BEGIN
        PRINT 'Access Denied: Only Training Managers can add instructors.';
    END
END;
GO

SELECT 
    name AS UserName,
    type_desc AS UserType,
    default_schema_name AS DefaultSchema,
    create_date AS CreatedDate,
    modify_date AS LastModified
FROM sys.database_principals 
WHERE type IN ('S', 'U', 'G')  
ORDER BY name;
