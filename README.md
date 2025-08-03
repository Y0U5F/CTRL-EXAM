# CRTL-TEST
# Comprehensive Workflow for Examination System Database Project

This document outlines a detailed workflow for developing the Examination System Database project using SQL Server, as specified in the provided requirements. The workflow incorporates Trello for project management and GitHub for version control, ensuring a structured, collaborative, and professional approach akin to a company project. Below, each phase is detailed with tasks, tools usage, and deliverables to ensure success.

## 1. Project Initiation
**Objective**: Establish the project environment and tools to kick off development.

**Tasks**:
- **Review Requirements**: Thoroughly understand the requirements from the provided document, which includes creating a database for managing courses, instructors, students, exams, and a question pool, with specific features like text question validation and user permissions.
- **Set Up Trello**:
  - Create a Trello board named "Examination System Database Project" ([Trello Guide](https://trello.com/guide)).
  - Add lists: **Design**, **Implementation**, **Testing**, **Documentation**, **Deployment**, and optionally **Backlog** for unstarted tasks.
  - Invite team members to the board and assign roles.
- **Set Up GitHub**:
  - Create a repository named "examination-system-db" ([GitHub Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)).
  - Initialize with a README.md describing the project.
  - Create folders: `docs/` (for documentation), `sql/` (for SQL scripts), and `tests/` (for test data if needed).
  - Structure `sql/` with a `team_members/` subfolder for individual scripts (e.g., `member1.sql`) and a `master.sql` for the combined script.
- **Team Coordination**:
  - Identify team members (assumed 2-4 based on requirements).
  - Assign responsibilities, e.g., one member focuses on course management, another on exam creation.

**Deliverables**:
- Trello board set up with initial lists.
- GitHub repository initialized with folder structure.

## 2. Planning
**Objective**: Break down the project into tasks and assign them to team members.

**Tasks**:
- **Task Breakdown**: Divide the project into tasks based on the requirements:
  - **Design Phase**:
    - Create Entity-Relationship Diagram (ERD).
    - Define database schema (tables, columns, data types, relationships).
    - Design stored procedures, functions, triggers, and views.
    - Plan user roles and permissions.
  - **Implementation Phase**:
    - Create database and filegroups.
    - Implement tables with constraints.
    - Create indexes for performance.
    - Write stored procedures, functions, triggers, and views.
    - Set up user accounts and permissions.
  - **Testing Phase**:
    - Insert test data.
    - Write and execute test cases.
    - Document test results.
  - **Documentation Phase**:
    - Finalize ERD.
    - List all database objects with descriptions.
    - Prepare test sheets.
    - Document account credentials.
  - **Deployment Phase**:
    - Create a master SQL script.
    - Set up a daily backup job.
- **Trello Setup**:
  - Create cards for each task in the appropriate list (e.g., "Create ERD" in Design).
  - Assign cards to team members and set due dates.
  - Add checklists for subtasks, e.g., for "Create ERD":
    - Identify entities.
    - Define relationships.
    - Draw ERD using a tool like Lucidchart ([Lucidchart](https://www.lucidchart.com)).
    - Review with team.
- **GitHub Setup**:
  - Ensure team members have write access to the repository.
  - Agree on a commit message convention, e.g., "Added Courses table creation script."

**Deliverables**:
- Trello cards created and assigned.
- GitHub repository ready for contributions.

## 3. Design Phase
**Objective**: Develop the database design to meet all requirements.

**Tasks**:
- **Create ERD**:
  - Identify entities: Courses, Instructors, Students, Questions, Exams, etc.
  - Define relationships, e.g., one Instructor can teach multiple Courses.
  - Use a tool like Lucidchart or draw.io ([draw.io](https://app.diagrams.net)) to create the ERD.
  - Save as `docs/erd.png`.
- **Define Database Schema**:
  - List tables (e.g., Courses, Instructors, Students, Questions, Exams).
  - Specify columns, data types, and constraints (e.g., primary keys, foreign keys).
  - Follow normalization rules to minimize redundancy.
  - Document schema in `docs/schema.txt`.
- **Design Database Objects**:
  - Plan stored procedures, e.g., `SP_AddQuestion`, `SP_CreateExam`.
  - Design functions, e.g., for validating text answers using regular expressions.
  - Plan triggers for data integrity, e.g., ensuring exam degrees don’t exceed course max degree.
  - Design views for reporting, e.g., student exam results.
- **Plan User Roles and Permissions**:
  - Define four roles: Admin, Training Manager, Instructor, Student.
  - Specify permissions, e.g., Instructors can only access their course data.

**Trello**:
- Move cards to "Design" list as tasks begin.
- Update card statuses and add comments for team discussions.

**GitHub**:
- Commit ERD (`docs/erd.png`) and schema (`docs/schema.txt`).

**Deliverables**:
- ERD in `docs/erd.png`.
- Schema definition in `docs/schema.txt`.

## 4. Implementation Phase
**Objective**: Build the database and implement all required features.

**Tasks**:
- **Create Database and Filegroups**:
  - Write SQL to create the database with filegroups based on estimated data size.
- **Create Tables**:
  - Implement tables with appropriate constraints (e.g., foreign keys for relationships).
  - Use meaningful naming conventions, e.g., `tbl_Courses`, `tbl_Questions`.
- **Implement Indexes**:
  - Add indexes on frequently queried columns, e.g., `CourseID`, `StudentID`.
- **Write Stored Procedures, Functions, Triggers, Views**:
  - Each team member writes their assigned objects in their own script file, e.g., `sql/team_members/member1.sql`.
  - Example stored procedure for adding a question:
    ```sql
    -- Author: Member1
    -- Description: Add a question to the question pool
    CREATE PROCEDURE SP_AddQuestion
        @QuestionText NVARCHAR(MAX),
        @QuestionType NVARCHAR(50),
        @CorrectAnswer NVARCHAR(MAX),
        @CourseID INT
    AS
    BEGIN
        INSERT INTO tbl_Questions (QuestionText, QuestionType, CorrectAnswer, CourseID)
        VALUES (@QuestionText, @QuestionType, @CorrectAnswer, @CourseID);
    END;
    ```
  - Implement functions for text answer validation using regex.
  - Create triggers to enforce data integrity, e.g., checking exam degree limits.
  - Create views for easy data retrieval, e.g., exam results by student.
- **Set Up User Accounts and Permissions**:
  - Create SQL Server users for each role.
  - Grant specific permissions, e.g., `GRANT EXECUTE ON SP_CreateExam TO InstructorRole;`.

**Trello**:
- Create cards in "Implementation" list, e.g., "Implement Courses table."
- Use checklists for subtasks: Write SQL, Test locally, Commit to GitHub.

**GitHub**:
- Each team member commits their scripts to `sql/team_members/`.
- Periodically combine scripts into `sql/master.sql`, ensuring correct order (tables before procedures).
- Use comments to indicate authorship, e.g., `-- Author: Member1`.

**Deliverables**:
- Individual SQL scripts in `sql/team_members/`.
- Combined `sql/master.sql`.

## 5. Testing Phase
**Objective**: Verify that the system meets all requirements.

**Tasks**:
- **Insert Test Data**:
  - Write `sql/test_data.sql` to populate tables with sample data, e.g., courses, students, questions.
- **Write Test Cases**:
  - Create test cases for each functionality, e.g., adding a question, creating an exam, grading text answers.
  - Document in `docs/test_sheets.docx` with columns: Test Query, Expected Result, Actual Result, Comments.
- **Execute Tests**:
  - Run tests using SQL Server Management Studio (SSMS) ([SSMS Download](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)).
  - Fix bugs and retest as needed.

**Trello**:
- Create cards in "Testing" list, e.g., "Test exam creation."
- Link to corresponding implementation cards for traceability.

**GitHub**:
- Commit `sql/test_data.sql`.
- Add test results to `docs/test_sheets.docx`.

**Deliverables**:
- Test data script in `sql/test_data.sql`.
- Test sheets in `docs/test_sheets.docx`.

**Sample Test Sheet Table**:
| Test Query | Expected Result | Actual Result | Comments |
|------------|-----------------|---------------|----------|
| EXEC SP_AddQuestion 'What is SQL?', 'MCQ', 'Structured Query Language', 1 | Question added to tbl_Questions | Question added successfully | Passed |
| SELECT * FROM vw_ExamResults WHERE StudentID = 1 | Returns exam results for StudentID 1 | Correct results returned | Passed |

## 6. Documentation Phase
**Objective**: Prepare all required deliverables.

**Tasks**:
- **Finalize ERD**: Ensure `docs/erd.png` is complete.
- **List Database Objects**:
  - Create `docs/object_list.txt` with names and descriptions of all objects (e.g., `SP_AddQuestion: Adds a question to the question pool`).
- **Prepare Test Sheets**:
  - Finalize `docs/test_sheets.docx` with all test cases and results.
- **Document Account Credentials**:
  - Create `docs/accounts.txt` with usernames and passwords (use secure methods in a real project).

**Trello**:
- Create cards in "Documentation" list for each deliverable.

**GitHub**:
- Commit all documentation files to `docs/`.

**Deliverables**:
- ERD in `docs/erd.png`.
- Object list in `docs/object_list.txt`.
- Test sheets in `docs/test_sheets.docx`.
- Account credentials in `docs/accounts.txt`.

## 7. Deployment Phase
**Objective**: Prepare the system for deployment.

**Tasks**:
- **Create Master Script**:
  - Combine all individual scripts into `sql/master.sql`.
  - Ensure correct order: tables, constraints, indexes, procedures, functions, triggers, views, permissions.
- **Set Up Daily Backups**:
  - Write `sql/backups.sql` to create a SQL Server job for daily backups:
    ```sql
    USE msdb;
    GO
    BEGIN
        EXEC sp_add_job @job_name=N'DailyBackup';
        EXEC sp_add_jobstep @job_name=N'DailyBackup', @step_name=N'BackupDatabase', 
            @subsystem=N'TSQL', @command=N'BACKUP DATABASE [ExaminationSystem] TO DISK = ''C:\Backups\ExaminationSystem.bak'' WITH FORMAT;', 
            @retry_attempts = 0, @retry_interval = 0;
        EXEC sp_add_jobschedule @job_name=N'DailyBackup', @name=N'DailySchedule', 
            @enabled=1, @freq_type=4, @freq_interval=1, @freq_subday_type=1, 
            @freq_subday_interval=0, @freq_relative_interval=0, @freq_recurrence_factor=0, 
            @active_start_date=20230101, @active_end_date=99991231, @active_start_time=200000, 
            @active_end_time=235959;
        EXEC sp_add_jobserver @job_name=N'DailyBackup';
    END
    GO
    ```

**Trello**:
- Create cards in "Deployment" list, e.g., "Create master.sql," "Set up backup job."

**GitHub**:
- Commit `sql/master.sql` and `sql/backups.sql`.

**Deliverables**:
- Master script in `sql/master.sql`.
- Backup script in `sql/backups.sql`.

## 8. Project Closure
**Objective**: Ensure all deliverables are complete and ready for submission.

**Tasks**:
- **Verify Deliverables**:
  - System Requirement sheet (provided).
  - ERD (`docs/erd.png`).
  - Database files (`sql/`).
  - SQL Server solution (`sql/team_members/`, `sql/master.sql`).
  - Object list (`docs/object_list.txt`).
  - Test sheets (`docs/test_sheets.docx`).
  - Account credentials (`docs/accounts.txt`).
- **Archive Trello Board**:
  - Archive the board for future reference ([Trello Archiving](https://help.trello.com/article/801-archiving-and-deleting-cards)).
- **Finalize GitHub**:
  - Ensure all files are committed.
  - Tag the final version, e.g., `v1.0` ([GitHub Tagging](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)).

**Deliverables**:
- Complete set of project files in GitHub.
- Archived Trello board.

## Best Practices
- **Trello**:
  - Use labels for priorities (High, Medium, Low).
  - Hold weekly stand-up meetings to discuss progress.
  - Update card statuses promptly.
- **GitHub**:
  - Write clear commit messages, e.g., "Added SP_CreateExam procedure."
  - Use branches for major features if needed, but keep it simple for small teams.
  - Avoid conflicts by assigning specific functionalities to team members (e.g., one handles exam creation, another handles student management).
- **SQL Development**:
  - Use transactions in stored procedures to ensure data integrity.
  - Handle errors with TRY-CATCH blocks.
  - Test text question validation thoroughly, as regex can be complex.
- **Team Collaboration**:
  - Communicate regularly via Trello comments or meetings.
  - Review each other’s SQL scripts to catch errors early.

## Potential Challenges
- **Schema Design**: Ensuring no redundancy while meeting all requirements.
- **Text Question Validation**: Implementing accurate regex or text functions for grading.
- **User Permissions**: Setting up roles to restrict access correctly.
- **Script Merging**: Combining individual scripts into `master.sql` without errors or duplicates.

## Tools
- **SQL Server Management Studio (SSMS)**: For writing and testing SQL ([SSMS Download](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)).
- **Lucidchart or draw.io**: For ERD creation ([Lucidchart](https://www.lucidchart.com), [draw.io](https://app.diagrams.net)).
- **Trello**: For project management ([Trello](https://trello.com)).
- **GitHub**: For version control ([GitHub](https://github.com)).

This workflow ensures a professional, organized approach to developing the Examination System Database, meeting all specified requirements while leveraging Trello and GitHub for effective collaboration and version control.
