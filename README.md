# CTRL + EXAM
<h1 align="center">
  <img src="CTRL_EXAM.png" alt="CTRL+EXAM Logo" width="180"/>
  <br/>
  CTRL+EXAM
</h1>

# ITI Examination System Database

This repository contains the complete database project for the ITI Examination System, a comprehensive solution designed to manage and automate the examination process for the Information Technology Institute (ITI). This project was developed as part of the Data Engineer track curriculum.

---

## 📂 Project Structure

The project is organized into two main modules: `ExaminationSystem-Database` for the core database scripts and documentation, and `ExaminationSystem-Docker` for containerization.

```text
CRTL-TEST/
├── 📁 ExaminationSystem-Database/
│   ├── 📁 backup/
│   │   └── 📦 ExaminationSystem.bak
│   │
│   ├── 📁 Docs/
│   │   ├── 📄 Documentation.pdf
│   │   ├── 🖼️ ERD.drawio.png
│   │   └── 📄 Mapping.pdf
│   │
│   ├── 📁 Project scripts/
│   │   ├── 📁 SQL scripts/
│   │   │   ├── 📜 DDL.sql
│   │   │   ├── 📜 DML1.sql
│   │   │   ├── 📜 Functions.sql
│   │   │   ├── 📜 Views_and_SPs.sql  (Combined)
│   │   │   ├── 📜 Trig.sql
│   │   │   ├── 📜 Users Auth Autho.sql
│   │   │   └── 📜 Scenario.sql
│   │   └── 📄 DataBaseProject.sln
│   │
│   └── 📁 Users for roles/
│       └── 📄 Users.txt
│
└── 📁 ExaminationSystem-Docker/
    ├── 📁 db-setup/
    │   ├── (Numbered SQL scripts for Docker setup)
    │   └── 📜 entrypoint.sh
    │
    ├── 🐳 docker-compose.yml
    └── 🐳 Dockerfile
```


## ✨ Key Features

* **Comprehensive Management**: Full control over students, instructors, courses, branches, and exams.
* **Dynamic Question Bank**: Supports Multiple-Choice (MCQ), True/False, and Text-based questions.
* **Flexible Exam Generation**: Instructors can create exams manually or generate them randomly.
* **Role-Based Access Control (RBAC)**: A secure permission system with four distinct roles: **Admin**, **Training Manager**, **Instructor**, and **Student**.
* **Process Automation**: Automates exam scheduling, result calculation, and answer storage.
* **Data Integrity & Auditing**: Utilizes triggers to maintain data consistency and audit critical changes.
* **Reporting & Analytics**: Offers rich views and functions for tracking student performance and exam statistics.

---

## 🚀 Core Components & Code Explanation

This section explains the role of each major SQL script located in the `ExaminationSystem-Database/Project scripts/SQL scripts/` directory.

### DDL.sql (Data Definition Language)
This script is the blueprint of the database. It builds the entire structure, creating all tables (like `Users`, `Students`, `Exams`, `Questions`) and defining the relationships between them using primary and foreign keys.

### DML1.sql (Data Manipulation Language)
This script populates the database with initial "seed" data. It adds sample students, instructors, courses, and questions, making the system ready for immediate testing and demonstration.

### Functions.sql
This script creates all user-defined functions used for calculations and checks. Key functions include `FN_CalculateExamResult` to get a student's total score and `FN_CheckTextAnswer` to validate text-based answers.

### Views_and_SPs.sql (Views and Stored Procedures)
This is the core of the system's business logic. It contains all views (e.g., `v_Student_Exams`) that provide secure, role-specific data access, and all stored procedures (e.g., `sp_Instructor_AddExam`) that handle operations like creating exams or submitting answers.

### Trig.sql (Triggers)
This script sets up automated actions. For example, `trg_Students_Audit` logs all changes to student data for security, and `TRG_Exams_AutoEndTime` automatically calculates an exam's end time, ensuring data integrity.

### Users Auth Autho.sql (Security)
This script establishes the security framework. It creates the database roles, grants them specific permissions on views and procedures, and contains the master procedure `sec.ProvisionAppUserLogin` for creating user logins securely.

---

## 🛠️ Technologies Used

* **Database**: SQL Server
* **Language**: T-SQL
* **Tools**: SQL Server Management Studio (SSMS), SQL Server Agent, Docker

---

## 🎨 Database Schema (ERD)

The database is designed with normalization principles to ensure data integrity and minimize redundancy.
![Entity Relationship Diagram](ExaminationSystem-Database/Docs/ERD/ERD.drawio.png)


---

## 🔧 Setup & Usage

To get the database up and running, execute the SQL scripts in the specified order to ensure dependencies are handled correctly.

1.  **Clone the Repository**:
    ```bash
    git clone [https://github.com/Y0U5F/CRTL-EXAM.git](https://github.com/Y0U5F/CRTL-EXAM.git)
    ```

2.  **Execute Scripts in Order**:
    In SQL Server Management Studio (SSMS), open and run the files from the `ExaminationSystem-Database/Project scripts/SQL scripts/` directory one by one in the following sequence:
    1.  `DDL.sql`
    2.  `DML1.sql`
    3.  `Functions.sql`
    4.  `views&spInstructor.sql`, `views&spManger.sql`, `views&spStudent.sql` (or a combined file)
    5.  `Trig.sql`
    6.  `Users Auth Autho.sql`

3.  **Create User Logins**:
    After setting up the database, create the necessary SQL Server Logins for the sample users using the `sec.ProvisionAppUserLogin` stored procedure.
    ```sql
    EXEC sec.ProvisionAppUserLogin @AppUsername = 'stud_ahmed', @LoginPassword = 'stud123';
    EXEC sec.ProvisionAppUserLogin @AppUsername = 'inst_rahma', @LoginPassword = 'inst456';
    ```

4.  **Run Demonstration Scenarios (Optional)**:
    Execute `Scenario.sql` to see a demonstration of how different roles interact with the system.

---

## 🛡️ Backup Strategy

A daily full backup job can be configured using **SQL Server Agent**. A backup file (`ExaminationSystem.bak`) is also included in the `backup` directory.

---

## 👥 Team Members

* Asmaa Gamal Abdalaal Sayed
* Ahmed Magdi Ali Baraka
* Esraa Ramadan Sayed Darder
* Bishoy Samir Najeeb Tawdros
* Yousef Mohamed Soliman Abo-eleneen
* Moaaz Omar Abdelfattah Abdelhamede: 8]
