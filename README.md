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
│   │   ├── 📁 Documentation/
│   │   │   └── 📄 Documentation.pdf
│   │   ├── 📁 ERD/
│   │   │   └── 🖼️ ERD.drawio.png
│   │   ├── 📁 Mapping/
│   │   │   └── 📄 Mapping.pdf
│   │
│   ├── 📁 Project scripts/
│   │   ├── 📁 SQL scripts/
│   │   │   ├── 📜 DDL.sql
│   │   │   ├── 📜 DML1.sql
│   │   │   ├── 📜 Functions.sql
│   │   │   ├── 📜 Scenario.sql
│   │   │   ├── 📜 TestBackup.sql
│   │   │   ├── 📜 Trig.sql
│   │   │   ├── 📜 Users Auth Autho.sql
│   │   │   ├── 📜 views&spInstructor.sql
│   │   │   ├── 📜 views&spManger.sql
│   │   │   └── 📜 views&spStudent.sql
│   │   ├── 📁 Backup script/
│   │   │   ├── 📄 DocumentLayout.backup.json
│   │   │   └── 📄 DocumentLayout.json
│   │   └── 📄 DataBaseProject.sln
│   │
│   └── 📁 Users for roles/
│       └── 📄 Users.txt
│
└── 📁 ExaminationSystem-Docker/
    ├── 📁 db-setup/
    │   └── (Numbered SQL scripts for Docker setup)
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

1. ### DDL.sql (Data Definition Language)
   This script is the blueprint of the database. It builds the entire structure, creating all tables (like `Users`, `Students`, `Exams`, `Questions`) and defining the relationships between them using primary and foreign keys.

2. ### DML1.sql (Data Manipulation Language)
   This script populates the database with initial "seed" data. It adds sample students, instructors, courses, and questions, making the system ready for immediate testing and demonstration.

3. ### Functions.sql
   This script creates all user-defined functions used for calculations and checks. Key functions include `FN_CalculateExamResult` to get a student's total score and `FN_CheckTextAnswer` to validate text-based answers.

4. ### Views_and_SPs.sql (Views and Stored Procedures)
   This is the core of the system's business logic. It contains all views (e.g., `v_Student_Exams`) that provide secure, role-specific data access, and all stored procedures (e.g., `sp_Instructor_AddExam`) that handle operations like creating exams or submitting answers.

5. ### Trig.sql (Triggers)
   This script sets up automated actions. For example, `trg_Students_Audit` logs all changes to student data for security, and `TRG_Exams_AutoEndTime` automatically calculates an exam's end time, ensuring data integrity.

6. ### Users Auth Autho.sql (Security)
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

---

## 🔧 Setup & Usage

You can set up and run this project in two ways. The automated Docker method is highly recommended for its simplicity and reliability.

### Option A: Automated Setup via Docker (Recommended)

This is the fastest way to get the database running. It creates an isolated container with a fully configured SQL Server instance and automatically sets up the database, tables, and data.

**How it Works**
The `docker-compose.yml` file orchestrates the entire process. It builds a custom image from the `Dockerfile`, which copies all the necessary SQL scripts inside. When the container starts for the first time, the SQL Server engine automatically executes these scripts in alphabetical order to build and populate the database. Data is safely stored outside the container using a Docker Volume to ensure persistence.

**Prerequisites:**
* Docker Desktop installed and running on your machine.

**Steps:**

1.  **Navigate to the Docker Directory**:
    Open a terminal and navigate to the `ExaminationSystem-Docker` folder, where the `docker-compose.yml` file is located.

2.  **Create the Environment File**:
    This file securely stores the database password. Create a new file named `.env` in the same directory and add the following line (you can change the password):
    ```
    MSSQL_SA_PASSWORD=YourStrongPass_123!
    ```

3.  **Build and Run the Container**:
    Execute the following command. This will build the image, create the container, and run it in the background (`-d`).
    ```bash
    docker-compose up -d --build
    ```

4.  **Verify the Status**:
    Wait for a minute or two for the database to initialize, then check the container's status:
    ```bash
    docker-compose ps
    ```
    The expected status is `Up (healthy)`, which confirms the database is ready.

5.  **Connect to the Database**:
    You can now connect using any database tool (like SSMS) with these credentials:
    * **Server**: `localhost`
    * **Login**: `sa`
    * **Password**: The password you set in your `.env` file.

---

### Option B: Manual Setup via SQL Scripts

This method is for users who have SQL Server installed locally and prefer to set up the database manually.

**Execution Order is Crucial**
You must run the scripts in the specified sequence because they depend on each other. For example, you cannot insert data (DML) into tables that have not yet been created (DDL).

**Steps:**

1.  **Clone the Repository** to get all the script files on your local machine.

2.  **Execute Scripts in Order**:
    In SQL Server Management Studio (SSMS), open and run the files from the `ExaminationSystem-Database/Project scripts/SQL scripts/` directory in the following sequence:
    1.  `DDL.sql` - Builds the database structure (tables, columns, relationships).
    2.  `DML1.sql` - Inserts the initial seed data into the tables.
    3.  `Functions.sql` - Creates all user-defined functions.
    4.  `views&sp...` files - Creates the views and stored procedures.
    5.  `Trig.sql` - Creates the database triggers.
    6.  `Users Auth Autho.sql` - Sets up security roles and permissions.

3.  **Create User Logins**:
    The database `USERS` exist, but they need server `LOGINS` to connect. Run the following stored procedure to create the logins and link them to the database users.
    ```sql
    EXEC sec.ProvisionAppUserLogin @AppUsername = 'stud_ahmed', @LoginPassword = 'stud123';
    EXEC sec.ProvisionAppUserLogin @AppUsername = 'inst_rahma', @LoginPassword = 'inst456';
    ```
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
