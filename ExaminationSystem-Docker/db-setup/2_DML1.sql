USE ITIExaminationSystem
GO

-- Insert Users 
INSERT INTO dbo.Users (Username, [Password], UserType)
VALUES 
    ('admin', 'admin123', 'Admin'),
    ('tm_ahmed', 'tm123', 'TrainingManager'),
    ('tm_mohammed', 'tm456', 'TrainingManager'),
    ('tm_nada', 'tm789', 'TrainingManager'),
    ('inst_rawhia', 'inst123', 'Instructor'),
    ('inst_rahma', 'inst456', 'Instructor'),
    ('inst_nora', 'inst789', 'Instructor'),
    ('inst_sarah', 'inst101', 'Instructor'),
    ('inst_esraa', 'inst102', 'Instructor'),
    ('inst_moaz', 'inst103', 'Instructor'),
    ('inst_youssef', 'inst104', 'Instructor'),
    ('inst_ahmed', 'inst105', 'Instructor'),
    ('inst_bishoy', 'inst106', 'Instructor'),
    ('inst_asmaa', 'inst107', 'Instructor'),
    ('stud_ahmed', 'stud123', 'Student'),
    ('stud_sara', 'stud456', 'Student'),
    ('stud_youssef', 'stud789', 'Student'),
    ('stud_mona', 'stud101', 'Student'),
    ('stud_rania', 'stud102', 'Student'),
    ('stud_farida', 'stud103', 'Student'),
    ('stud_arwa', 'stud104', 'Student'),
    ('stud_nada', 'stud105', 'Student'),
    ('stud_noha', 'stud106', 'Student'),
    ('stud_rana', 'stud107', 'Student'),
    ('stud_omar', 'stud108', 'Student'),
    ('stud_hassan', 'stud109', 'Student'),
    ('stud_fatma', 'stud110', 'Student'),
    ('stud_ali', 'stud111', 'Student'),
    ('stud_dina', 'stud112', 'Student');
GO

-- Insert Training Managers
INSERT INTO dbo.TrainingManager (UserID, NationalID, FirstName, LastName, Email, Phone, HireDate, IsActive)
VALUES 
    (2, '30202020200202', 'Ahmed', 'Magdy', 'ahmed.magdy@company.com', '01023659887', '2024-05-15', 1),
    (3, '30303030300303', 'Mohammed', 'Ali', 'mohammed.ali@company.com', '01063258974', '2024-04-20', 1),
    (4, '30404040400404', 'Nada', 'Alaa', 'nada.alaa@company.com', '01152369741', '2024-02-10', 1);
GO

-- Insert Intakes
INSERT INTO dbo.Intakes (IntakeName, StartDate, EndDate, IntakeYear)
VALUES 
    ('Intake 46', '2025-10-12', '2026-07-30', 2025),
    ('Intake 45', '2024-10-12', '2025-07-30', 2024),
    ('Intake 44', '2023-10-12', '2024-07-30', 2023),
    ('Intake 43', '2022-10-12', '2023-07-30', 2022);
GO

-- Insert Department
INSERT INTO dbo.Department (DepartmentID, TrackID, DepartmentName)
VALUES 
    (1, 1, 'Software Engineering & Agentic AI Development'),
    (2, 2, 'Information System'),
    (3, 3, 'Cyber Security, Cloud, and Infrastructure Services'),
    (4, 4, 'Data Science & Analytics');
GO

-- Insert Tracks
INSERT INTO dbo.Tracks (TrackName, [Description], IsActive, DepartmentID)
VALUES 
    ('Full Stack Development', 'Complete web development track covering frontend and backend technologies', 1, 1),
    ('Data Science', 'Data analysis, machine learning, and statistical modeling', 1, 4),
    ('Cybersecurity', 'Information security, ethical hacking, and network protection', 1, 3),
    ('Cloud Computing', 'Cloud platforms, services, and infrastructure management', 1, 3);
GO

-- Insert Branches
INSERT INTO dbo.Branches (BranchName, [Description], BranchEmail, BranchPhone, TrainingManagerID)
VALUES 
    ('Smart Village Branch', 'Main campus in Smart Village, Bldg B148 on Cairo–Alex Desert Road', 'smartvillage@company.com', '0226594100', 1),
    ('Alexandria Branch', 'Located at Post Office Building, Shohada Square (MISR Station) in Alexandria', 'alexandria@company.com', '0334567890', 2),
    ('New Capital Branch', 'Knowledge City (smart section)', 'newcapital@company.com', '01500123456', 1),
    ('Assiut Branch', 'Assiut University – Info Network Building', 'assiut@company.com', '0882345678', 3),
    ('Minia Branch', 'Minia University – Creativa Building', 'minia@company.com', '0862456789', 2);
GO

-- Insert BranchIntakeTrack
INSERT INTO dbo.BranchIntakeTrack (BranchID, IntakeID, TrackID)
VALUES 
    (1, 1, 1), (1, 1, 2), (1, 1, 3), (1, 1, 4),
    (2, 1, 1), (2, 1, 4),
    (3, 2, 2), (3, 2, 3),
    (4, 2, 3), (4, 2, 2),
    (5, 3, 1), (5, 3, 4),
    (1, 2, 1), (2, 2, 2), (3, 3, 3);
GO


-- Insert Instructors
INSERT INTO dbo.Instructors 
(UserID, FirstName, LastName, Email, Phone, Specialization, HireDate, IsActive, BranchIntakeTrackID, NationalID)
VALUES 
    (5, 'Rawhia', 'Abdulrahman', 'rawhia.abdulrahman@company.com', '01033333333', 'Web Development', '2023-04-05', 1, 1, '29904182345671'),
    (6, 'Rahma', 'Mohammed', 'rahma.mohammed@company.com', '01044444444', 'Data Science', '2023-05-20', 1, 2, '30005201234567'),
    (7, 'Nora', 'Magdy', 'nora.magdy@company.com', '01055555555', 'Cybersecurity', '2023-06-15', 1, 3, '30106152345678'),
    (8, 'Sarah', 'Salah', 'sarah.salah@company.com', '01066666666', 'Cloud Computing', '2023-07-01', 1, 4, '30207012345679'),
    (9, 'Esraa', 'Haroon', 'esraa.haroon@company.com', '01077777777', 'Data Science', '2023-08-10', 1, 7, '30308102345670'),
    (10, 'Moaz', 'Omar', 'moaz.omar@company.com', '01088888888', 'Machine Learning', '2023-09-25', 1, 8, '30409252345671'),
    (11, 'Youssef', 'Mahmoud', 'youssef.mahmoud@company.com', '01099999999', 'Full Stack Development', '2023-10-30', 1, 11, '30510302345672'),
    (12, 'Ahmed', 'Magdy', 'ahmed.magdy@company.com', '01000000000', 'Cybersecurity', '2023-01-01', 1, 9, '30601012345673'),
    (13, 'Bishoy', 'Samir', 'bishoy.samir@company.com', '01111111111', 'Software Engineering', '2024-03-01', 1, 12, '30703012345674'),
    (14, 'Asmaa', 'Gamal', 'asmaa.gamal@company.com', '01222222222', 'Data Analytics', '2024-04-01', 1, 10, '30804012345675');
GO

-- Insert Students
INSERT INTO dbo.Students (UserID, NationalID, FirstName, LastName, Email, Phone, Address, EnrollmentDate, BranchIntakeTrackID, IsActive)
VALUES 
    (15, '31515151515151', 'Ahmed', 'Mohamed', 'ahmed.mohamed@student.com', '01000000001', '123 Nasr City, Cairo', '2025-01-01', 1, 1),
    (16, '31616161616161', 'Sara', 'Gamal', 'sara.gamal@student.com', '01000000002', '456 Dokki, Giza', '2025-01-01', 2, 1),
    (17, '31717171717171', 'Youssef', 'Ibrahim', 'youssef.ibrahim@student.com', '01000000003', '789 Sidi Gaber, Alexandria', '2025-01-01', 5, 1),
    (18, '31818181818181', 'Mona', 'Nafee', 'mona.nafee@student.com', '01000000004', '321 Heliopolis, Cairo', '2025-01-01', 3, 1),
    (19, '31919191919191', 'Rania', 'Alaa', 'rania.alaa@student.com', '01000000005', '654 Mansoura Center', '2025-07-01', 9, 1),
    (20, '32020202020202', 'Farida', 'Mohammed', 'farida.mohammed@student.com', '01000000006', '987 Stanley, Alexandria', '2025-07-01', 11, 1),
    (21, '32121212121212', 'Arwa', 'Sami', 'arwa.sami@student.com', '01000000007', '147 Assiut University St', '2025-07-01', 8, 1),
    (22, '32222222222222', 'Nada', 'Ahmed', 'nada.ahmed@student.com', '01000000008', '258 Ismailia Downtown', '2025-01-01', 4, 1),
    (23, '32323232323232', 'Noha', 'Rashid', 'noha.rashid@student.com', '01000000009', '369 New Administrative Capital', '2026-01-01', 13, 1),
    (24, '32424242424242', 'Rana', 'Ahmed', 'rana.ahmed@student.com', '01000000010', '741 Minia University Area', '2026-01-01', 10, 1),
    (25, '32525252525252', 'Omar', 'Hassan', 'omar.hassan@student.com', '01000000011', '852 Zamalek, Cairo', '2025-01-01', 1, 1),
    (26, '32626262626262', 'Hassan', 'Ali', 'hassan.ali@student.com', '01000000012', '963 Mohandessin, Giza', '2025-01-01', 2, 1),
    (27, '32727272727272', 'Fatma', 'Omar', 'fatma.omar@student.com', '01000000013', '159 Smouha, Alexandria', '2025-07-01', 5, 1),
    (28, '32828282828282', 'Ali', 'Mahmoud', 'ali.mahmoud@student.com', '01000000014', '357 Maadi, Cairo', '2025-01-01', 3, 1),
    (29, '32929292929292', 'Dina', 'Youssef', 'dina.youssef@student.com', '01000000015', '468 6th October City', '2025-07-01', 12, 1);
GO

-- Insert Courses
INSERT INTO dbo.Courses 
(TrackID, InstructorID, CourseName, CourseDescription, MaxDegree, MinDegree, CourseHours, IsActive)
VALUES 
    (1, 2, 'HTML & CSS Fundamentals', 'Introduction to web markup and styling languages', 100, 60, 40, 1),
    (1, 2, 'JavaScript Programming', 'Client-side scripting and DOM manipulation', 100, 60, 50, 1),
    (1, 8, 'React Development', 'Modern frontend framework for building user interfaces', 100, 60, 45, 1),
    (1, 10, 'Node.js Backend', 'Server-side JavaScript development', 100, 60, 50, 1),
    (2, 3, 'Python for Data Science', 'Python programming for data analysis and visualization', 100, 60, 60, 1),
    (2, 7, 'Machine Learning Basics', 'Introduction to ML algorithms and applications', 100, 60, 70, 1),
    (2, 11, 'Data Visualization', 'Creating meaningful charts and dashboards', 100, 60, 40, 1),
    (2, 6, 'Statistical Analysis', 'Statistical methods for data interpretation', 100, 60, 55, 1),
    (3, 4, 'Network Security', 'Fundamentals of cybersecurity and network protection', 100, 60, 50, 1),
    (3, 9, 'Ethical Hacking', 'Penetration testing and vulnerability assessment', 100, 60, 60, 1),
    (3, 4, 'Cryptography', 'Encryption methods and security protocols', 100, 60, 45, 1),
    (4, 5, 'Cloud Platforms', 'AWS and Azure cloud services and deployment', 100, 60, 55, 1),
    (4, 5, 'DevOps Fundamentals', 'CI/CD pipelines and automation tools', 100, 60, 50, 1),
    (4, 5, 'Container Technologies', 'Docker and Kubernetes for scalable applications', 100, 60, 45, 1),
    (1, 2, 'Database Design', 'Relational database concepts and SQL', 100, 60, 45, 1);

-- Insert Exams
INSERT INTO dbo.Exams 
(ExamTitle, ExamType, TotalDegrees, ExamDuration, StartDateTime, EndDateTime, IsRandomOrder, QuestionsNumbers, CourseID, InstructorID, BranchIntakeTrackID, ExamMark)
VALUES 
    ('HTML & CSS Final Exam', 'Final', 100, 120, '2025-03-15 09:00:00', '2025-03-15 11:00:00', 1, 10, 3, 2, 1, 100),
    ('JavaScript Midterm', 'Midterm', 80, 90, '2025-04-10 10:00:00', '2025-04-10 11:30:00', 0, 8, 4, 2, 1, 80),
    ('Python Data Science Quiz', 'Quiz', 50, 60, '2025-05-05 14:00:00', '2025-05-05 15:00:00', 1, 5, 7, 3, 2, 50),
    ('Network Security Assessment', 'Final', 100, 150, '2025-06-20 09:00:00', '2025-06-20 11:30:00', 1, 12, 11, 4, 3, 100),
    ('Cloud Computing Practical', 'Practical', 75, 120, '2025-07-15 13:00:00', '2025-07-15 15:00:00', 0, 6, 14, 5, 4, 75),
    ('React Development Project', 'Project', 100, 180, '2025-08-10 09:00:00', '2025-08-10 12:00:00', 0, 8, 5, 8, 1, 100),
    ('Machine Learning Final', 'Final', 100, 150, '2025-09-25 10:00:00', '2025-09-25 12:30:00', 1, 15, 8, 7, 2, 100);
Go


INSERT INTO dbo.Questions
    (QuestionText, QuestionType, CourseID, InstructorID, CorrectAnswer, DifficultyLevel)
VALUES
    -- HTML & CSS Fundamentals (CourseID = 3, InstructorID = 2)
    ('HTML is a programming language.', 'TrueFalse', 3, 2, 'False', 'Easy'),
    ('Explain the box model in CSS.', 'Text', 3, 2, 'The CSS box model describes rectangular boxes with content, padding, border, and margin areas.', 'Medium'),
    ('Which HTML tag is used for line breaks?', 'MultipleChoice', 3, 2, '<br>', 'Easy'),

    -- JavaScript (CourseID = 4, InstructorID = 2)
    ('What is the correct way to declare a variable in JavaScript?', 'MultipleChoice', 4, 2, 'let variableName;', 'Easy'),
    ('JavaScript is case-sensitive.', 'TrueFalse', 4, 2, 'True', 'Easy'),
    ('Explain the difference between let and var.', 'Text', 4, 2, 'let has block scope while var has function scope. let prevents hoisting issues.', 'Medium'),
    ('Which method adds an element to the end of an array?', 'MultipleChoice', 4, 2, 'push()', 'Easy'),
    ('What does DOM stand for?', 'MultipleChoice', 4, 2, 'Document Object Model', 'Easy'),

    -- Python (CourseID = 7, InstructorID = 3)
    ('What is the correct file extension for Python files?', 'MultipleChoice', 7, 3, '.py', 'Easy'),
    ('Python is an interpreted language.', 'TrueFalse', 7, 3, 'True', 'Easy'),
    ('Explain list comprehension in Python.', 'Text', 7, 3, 'List comprehension provides a concise way to create lists using a single line of code.', 'Medium'),
    ('Which keyword is used to define a function in Python?', 'MultipleChoice', 7, 3, 'def', 'Easy'),
    ('What is the output of print(type([]))?', 'MultipleChoice', 7, 3, '<class ''list''>', 'Medium'),

    -- Network Security (CourseID = 11, InstructorID = 4)
    ('What does HTTPS stand for?', 'MultipleChoice', 11, 4, 'HyperText Transfer Protocol Secure', 'Easy'),
    ('Encryption converts readable data into unreadable format.', 'TrueFalse', 11, 4, 'True', 'Easy'),
    ('Explain two-factor authentication.', 'Text', 11, 4, 'Two-factor authentication adds extra security by requiring two different authentication factors.', 'Medium'),
    ('Which port is commonly used for HTTPS?', 'MultipleChoice', 11, 4, '443', 'Easy'),
    ('What is a firewall?', 'Text', 11, 4, 'A firewall is a network security system that monitors and controls network traffic based on security rules.', 'Medium'),

    -- Cloud Platforms (CourseID = 14, InstructorID = 5)
    ('What does SaaS stand for?', 'MultipleChoice', 14, 5, 'Software as a Service', 'Easy'),
    ('Cloud computing eliminates the need for local servers.', 'TrueFalse', 14, 5, 'False', 'Medium'),
    ('Name three major cloud service providers.', 'Text', 14, 5, 'Amazon Web Services (AWS), Microsoft Azure, Google Cloud Platform (GCP)', 'Easy'),
    ('What is auto-scaling in cloud computing?', 'Text', 14, 5, 'Auto-scaling automatically adjusts computing resources based on demand to maintain performance.', 'Medium'),
    ('Which AWS service is used for object storage?', 'MultipleChoice', 14, 5, 'S3', 'Easy');

GO




-- Insert QuestionChoices 
INSERT INTO dbo.QuestionChoices (QuestionID, ChoiceTextQ, ChoiceLetter, IsCorrect)
VALUES 
    -- Q2: HTML is a programming language.
    (2, 'True', 'A', 0),
    (2, 'False', 'B', 1)

    -- Q4: Which HTML tag is used for line breaks?
    ,(4, '<br>', 'A', 1),
    (4, '<break>', 'B', 0),
    (4, '<lb>', 'C', 0),
    (4, '<newline>', 'D', 0)

    -- Q5: What is the correct way to declare a variable in JavaScript?
    ,(5, 'let variableName;', 'A', 1),
    (5, 'variable variableName;', 'B', 0),
    (5, 'v variableName;', 'C', 0),
    (5, 'declare variableName;', 'D', 0)

    -- Q6: JavaScript is case-sensitive.
    ,(6, 'True', 'A', 1),
    (6, 'False', 'B', 0)

    -- Q8: Which method adds an element to the end of an array?
    ,(8, 'push()', 'A', 1),
    (8, 'add()', 'B', 0),
    (8, 'append()', 'C', 0),
    (8, 'insert()', 'D', 0)

    -- Q9: What does DOM stand for?
    ,(9, 'Document Object Model', 'A', 1),
    (9, 'Data Object Management', 'B', 0),
    (9, 'Dynamic Object Method', 'C', 0),
    (9, 'Document Oriented Model', 'D', 0)

    -- Q10: What is the correct file extension for Python files?
    ,(10, '.py', 'A', 1),
    (10, '.python', 'B', 0),
    (10, '.pt', 'C', 0),
    (10, '.pyt', 'D', 0)

    -- Q11: Python is an interpreted language.
    ,(11, 'True', 'A', 1),
    (11, 'False', 'B', 0)

    -- Q13: Which keyword is used to define a function in Python?
    ,(13, 'def', 'A', 1),
    (13, 'function', 'B', 0),
    (13, 'func', 'C', 0),
    (13, 'define', 'D', 0)

    -- Q14: What is the output of print(type([]))?
    ,(14, '<class ''list''>', 'A', 1),
    (14, 'list', 'B', 0),
    (14, 'array', 'C', 0),
    (14, '<class ''list''>', 'D', 0)

    -- Q15: What does HTTPS stand for?
    ,(15, 'HyperText Transfer Protocol Secure', 'A', 1),
    (15, 'HyperText Transport Protocol Secure', 'B', 0),
    (15, 'HyperText Transmission Protocol Secure', 'C', 0),
    (15, 'HyperText Transfer Process Secure', 'D', 0)

    -- Q16: Encryption converts readable data into unreadable format.
    ,(16, 'True', 'A', 1),
    (16, 'False', 'B', 0)

    -- Q18: Which port is commonly used for HTTPS?
    ,(18, '443', 'A', 1),
    (18, '80', 'B', 0),
    (18, '8080', 'C', 0),
    (18, '22', 'D', 0)

    -- Q20: What does SaaS stand for?
    ,(20, 'Software as a Service', 'A', 1),
    (20, 'System as a Service', 'B', 0),
    (20, 'Storage as a Service', 'C', 0),
    (20, 'Security as a Service', 'D', 0)

    -- Q21: Cloud computing eliminates the need for local servers.
    ,(21, 'True', 'A', 1),
    (21, 'False', 'B', 0)

    -- Q24: Which AWS service is used for object storage?
    ,(24, 'S3', 'A', 1),
    (24, 'EC2', 'B', 0),
    (24, 'RDS', 'C', 0),
    (24, 'Lambda', 'D', 0);

GO

-- Insert QuestionText 
INSERT INTO dbo.QuestionText (QuestionID, TextQText, TextAnswer, AcceptedPattern, IsCorrect)
VALUES 
    (4, 'Explain the box model in CSS.', 'The CSS box model describes rectangular boxes with content, padding, border, and margin areas.', '%content%padding%border%margin%', 1),
    (8, 'Explain the difference between let and var.', 'let has block scope while var has function scope. let prevents hoisting issues.', '%let%var%scope%', 1),
    (13, 'Explain list comprehension in Python.', 'List comprehension provides a concise way to create lists using a single line of code.', '%list%comprehension%create%', 1),
    (18, 'Explain two-factor authentication.', 'Two-factor authentication adds extra security by requiring two different authentication factors.', '%two%factor%authentication%security%', 1),
    (20, 'What is a firewall?', 'A firewall is a network security system that monitors and controls network traffic based on security rules.', '%firewall%network%security%traffic%', 1),
    (23, 'Name three major cloud service providers.', 'Amazon Web Services (AWS), Microsoft Azure, Google Cloud Platform (GCP)', '%AWS%Azure%Google%', 1),
    (24, 'What is auto-scaling in cloud computing?', 'Auto-scaling automatically adjusts computing resources based on demand to maintain performance.', '%auto%scaling%resources%demand%', 1);
GO

-- Insert QuestionsExam 

INSERT INTO dbo.QuestionsExam (ExamID, QuestionID, QuestionDegree, QuestionOrder)
VALUES 
    -- HTML & CSS Final Exam (ExamID = 3, 10 questions)
    (3, 2, 10, 1), (3, 3, 10, 2), (3, 4, 10, 3), (3, 5, 15, 4), (3, 6, 10, 5),
    (3, 7, 10, 6), (3, 8, 15, 7), (3, 9, 10, 8), (3, 10, 10, 9), (3, 11, 10, 10),

    -- JavaScript Midterm (ExamID = 4, 8 questions)
    (4, 5, 10, 1), (4, 6, 10, 2), (4, 7, 10, 3), (4, 8, 15, 4),
    (4, 9, 10, 5), (4, 3, 10, 6), (4, 4, 10, 7), (4, 2, 5, 8),

    -- Python Data Science Quiz (ExamID = 5, 5 questions)
    (5, 10, 10, 1), (5, 11, 10, 2), (5, 12, 15, 3), (5, 13, 10, 4), (5, 14, 5, 5),

    -- Network Security Assessment (ExamID = 6, 8 questions)
    (6, 15, 8, 1), (6, 16, 8, 2), (6, 17, 12, 3), (6, 18, 8, 4),
    (6, 19, 12, 5), (6, 20, 8, 6), (6, 21, 8, 7), (6, 22, 8, 8),

    -- Cloud Computing Practical (ExamID = 7, 6 questions)
    (7, 20, 12, 1), (7, 21, 13, 2), (7, 22, 15, 3),
    (7, 23, 15, 4), (7, 24, 10, 5), (7, 16, 10, 6),

    -- React Development Project (ExamID = 8, 6 questions)
    (8, 5, 12, 1), (8, 6, 13, 2), (8, 7, 15, 3),
    (8, 8, 12, 4), (8, 9, 12, 5), (8, 4, 12, 6),

    -- Machine Learning Final (ExamID = 9, 10 questions)
    (9, 10, 7, 1), (9, 11, 7, 2), (9, 12, 10, 3), (9, 13, 7, 4), (9, 14, 7, 5),
    (9, 20, 6, 6), (9, 21, 6, 7), (9, 22, 10, 8),
    (9, 23, 10, 9), (9, 24, 6, 10);




-- Insert StudentsExam 
INSERT INTO dbo.StudentsExam (ExamID, StudentID, AssignedDate, StudentMark, StartDateTime, EndDateTime)
VALUES 
    (3, 1,  '2025-03-01 08:00:00', 85.00, '2025-03-15 09:00:00', '2025-03-15 11:00:00'),
    (3, 3,  '2025-03-01 08:00:00', 92.00, '2025-03-15 09:00:00', '2025-03-15 11:00:00'),
    (3, 11, '2025-03-01 08:00:00', 78.00, '2025-03-15 09:00:00', '2025-03-15 11:00:00'),

-- ExamID = 4 (JavaScript Midterm)

    (4, 2, '2025-03-02 08:00:00', 88.00, '2025-03-16 09:00:00', '2025-03-16 11:00:00'),
    (4, 5, '2025-03-02 08:00:00', 91.00, '2025-03-16 09:00:00', '2025-03-16 11:00:00'),
    (4, 7, '2025-03-02 08:00:00', 76.00, '2025-03-16 09:00:00', '2025-03-16 11:00:00'),

-- ExamID = 5 (Python Data Science Quiz)

    (5, 4, '2025-03-03 08:00:00', 89.00, '2025-03-17 09:00:00', '2025-03-17 11:00:00'),
    (5, 6, '2025-03-03 08:00:00', 93.00, '2025-03-17 09:00:00', '2025-03-17 11:00:00'),
    (5, 8, '2025-03-03 08:00:00', 81.00, '2025-03-17 09:00:00', '2025-03-17 11:00:00'),

-- ExamID = 6 (Network Security Assessment)

    (6, 9,  '2025-03-04 08:00:00', 84.00, '2025-03-18 09:00:00', '2025-03-18 11:00:00'),
    (6, 10, '2025-03-04 08:00:00', 79.00, '2025-03-18 09:00:00', '2025-03-18 11:00:00'),
    (6, 2,  '2025-03-04 08:00:00', 91.00, '2025-03-18 09:00:00', '2025-03-18 11:00:00'),

-- ExamID = 7 (Cloud Computing Practical)

    (7, 3,  '2025-03-05 08:00:00', 87.00, '2025-03-19 09:00:00', '2025-03-19 11:00:00'),
    (7, 6,  '2025-03-05 08:00:00', 90.00, '2025-03-19 09:00:00', '2025-03-19 11:00:00'),
    (7, 12, '2025-03-05 08:00:00', 74.00, '2025-03-19 09:00:00', '2025-03-19 11:00:00'),

-- ExamID = 8 (React Development Project)

    (8, 5,  '2025-03-06 08:00:00', 92.00, '2025-03-20 09:00:00', '2025-03-20 11:00:00'),
    (8, 7,  '2025-03-06 08:00:00', 88.00, '2025-03-20 09:00:00', '2025-03-20 11:00:00'),
    (8, 9,  '2025-03-06 08:00:00', 80.00, '2025-03-20 09:00:00', '2025-03-20 11:00:00'),

-- ExamID = 9 (Machine Learning Final)

    (9, 8,  '2025-03-07 08:00:00', 86.00, '2025-03-21 09:00:00', '2025-03-21 11:00:00'),
    (9, 10, '2025-03-07 08:00:00', 90.00, '2025-03-21 09:00:00', '2025-03-21 11:00:00'),
    (9, 11, '2025-03-07 08:00:00', 77.00, '2025-03-21 09:00:00', '2025-03-21 11:00:00')


-- Insert CorrectiveExam
INSERT INTO dbo.CorrectiveExam (ExamID, Reason, ApprovedBy, IsApproved, QuestionsNumbers)
VALUES 
    (3, 'Student failed original exam and requested retake due to technical issues', 2, 1, 10), 
    (4, 'Make-up exam for absent student due to medical emergency', 3, 1, 8), 
    (6, 'Retake exam approved after appeal for unfair grading', 7, 1, 12),
    (7, 'Additional attempt granted due to system malfunction during original exam', 8, 0, 6);

-- Insert StudentAnswers
INSERT INTO dbo.StudentAnswers (StudentID, ExamID, QuestionID, StudentAnswer, IsCorrect, MarksObtained)
VALUES
-- ExamID 3 ? HTML & CSS Final Exam
(1, 3, 2, 'False', 1, 1),
(1, 3, 3, 'The box model includes margin, border, padding, and content', 1, 1),
(1, 3, 4, '<br>', 1, 1),

-- ExamID 4 ? JavaScript Midterm
(2, 4, 5, 'var x = 10;', 1, 1),
(2, 4, 6, 'True', 1, 1), 
(2, 4, 7, 'let is block scoped, var is function scoped', 1, 1),
(2, 4, 8, 'push()', 1, 1),
(2, 4, 9, 'Document Object Model', 1, 1),

-- ExamID 5 ? Python Data Science Quiz
(3, 5, 10, '.py', 1, 1),
(3, 5, 11, 'True', 1, 1),
(3, 5, 12, '[x for x in range(5)]', 1, 1),
(3, 5, 13, 'def', 1, 1),
(3, 5, 14, '<class ''list''>', 1, 1),

-- ExamID 6 ? Network Security Assessment
(4, 6, 15, 'Hypertext Transfer Protocol Secure', 1, 1),
(4, 6, 16, 'True', 1, 1),
(4, 6, 17, 'Something you know and something you have', 1, 1),
(4, 6, 18, '443', 1, 1),
(4, 6, 19, 'A system that monitors and controls network traffic', 1, 1),

-- ExamID 7 ? Cloud Computing Practical
(5, 7, 20, 'Software as a Service', 1, 1),
(5, 7, 21, 'True', 1, 1),
(5, 7, 22, 'AWS, Azure, Google Cloud', 1, 1),
(5, 7, 23, 'Automatically adjusts resources based on demand', 1, 1),
(5, 7, 24, 'Amazon S3', 1, 1);

GO

-- Insert StudentCourse 
INSERT INTO dbo.StudentCourse (StudentID, CourseID, TotalScore, FinalGrade)
VALUES 
    (1, 15, 62.00, 'C'),
    (2, 5, 89.75, 'A'),
    (2, 6, 91.50, 'A'),
    (2, 7, 78.25, 'B'),
    (3, 3, 85.75, 'A'),
    (4, 9, 88.25, 'A'),
    (4, 11, 82.00, 'B'),
    (5, 9, 76.75, 'B'),
    (5, 10, 84.50, 'B'),
    (6, 3, 95.25, 'A'),
    (6, 4, 87.75, 'A'),
    (7, 9, 82.50, 'B'),
    (7, 10, 79.25, 'B'),
    (8, 12, 68.75, 'C'),
    (8, 13, 71.50, 'B'),
    (9, 15, 55.00, 'F'),
    (10, 12, 71.25, 'B'),
    (10, 14, 77.50, 'B'),
    (12, 5, 42.50, 'F'),
    (12, 6, 93.75, 'A'),
    (13, 7, 89.25, 'A'),
    (13, 8, 86.50, 'A'),
    (14, 9, 73.25, 'B'),
    (15, 3, 87.00, 'A'),
    (15, 4, 91.25, 'A');




    SELECT * FROM Users

    SELECT * FROM Students