# CTRL + EXAM
# ITI Examination System Database

This repository contains the complete database project for the ITI Examination System, a comprehensive solution designed to manage and automate the examination process for the Information Technology Institute (ITI). This project was developed as part of the Data Engineer track curriculum.

## 📂 Project Structure

The project is organized into a clean, modular structure to separate documentation from the SQL source code. The SQL scripts are numbered to indicate the correct execution order.

```text
CRTL-TEST/
├── 🖼️ CTRL_EXAM.png
├── 📄 LICENSE
├── 📖 README.md
│
├── 📁 ExaminationSystem-Database/
│   ├── 📁 backup/
│   │   ├── ExaminationSystem.bak
│   │   └── .gitkeep
│   │
│   ├── 📁 Docs/
│   │   ├── 📁 Documentation/
│   │   │   └── 📄 Documentation.pdf
│   │   ├── 📁 ERD/
│   │   │   └── 🖼️ ERD.drawio.png
│   │   └── 📁 Mapping/
│   │       └── 📄 Mapping.pdf
│   │
│   ├── 📁 Project scripts/
│   │   ├── 📁 Backup script/
│   │   │   ├── .suo
│   │   │   ├── DocumentLayout.backup.json
│   │   │   └── DocumentLayout.json
│   │   │
│   │   ├── 📁 SQL scripts/
│   │   │   ├── DataBaseProject.ssmssqlproj
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
│   │   │
│   │   └── 📄 DataBaseProject.sln
│   │
│   ├── 📁 Users for roles/
│   │   └── 📄 Users.txt
│   │
│   └── .gitkeep
│
└── 📁 ExaminationSystem-Docker/
    ├── 📁 db-setup/
    │   ├── 📜 1_DDL.sql
    │   ├── 📜 2_DML1.sql
    │   ├── 📜 3_Functions.sql
    │   ├── 📜 4_views_spStudent.sql
    │   ├── 📜 5_views_spInstructor.sql.sql
    │   ├── 📜 6_views_spManger.sql.sql
    │   ├── 📜 7_Users_Auth_Autho.sql.sql
    │   ├── 📜 8_Trig.sql.sql
    │   └── 📜 entrypoint.sh
    │
    ├── 🐳 docker-compose.yml
    ├── 🐳 Dockerfile
    ├── .gitattributes
    └── .gitkeep
```


## ✨ Key Features

* **Comprehensive Management**: Full control over students, instructors, courses, branches, and exams.
* **Dynamic Question Bank**: Supports Multiple-Choice (MCQ), True/False, and Text-based questions.
* **Flexible Exam Generation**: Instructors can create exams manually or generate them randomly.
* **Role-Based Access Control (RBAC)**: A secure permission system with four distinct roles: **Admin**, **Training Manager**, **Instructor**, and **Student**.
* **Process Automation**: Automates exam scheduling, result calculation, and answer storage.
* **Data Integrity & Auditing**: Utilizes triggers to maintain data consistency and audit critical changes.
* **Reporting & Analytics**: Offers rich views and functions for tracking student performance and exam statistics.

## 🛠️ Technologies Used

* **Database**: SQL Server
* **Language**: T-SQL
* **Tools**: SQL Server Management Studio (SSMS), SQL Server Agent

## 🎨 Database Schema (ERD)

The database is designed with normalization principles to ensure data integrity and minimize redundancy.

![Entity Relationship Diagram](Docs/ERD/ERD.drawio.jpg)

## 🔧 Setup & Usage

To get the database up and running, execute the SQL scripts from the `sql/` folder in their numbered order. This ensures that dependencies are handled correctly (e.g., tables are created before data is inserted).

1.  **Clone the Repository**:
    ```bash
    git clone [https://github.com/Y0U5F/CRTL-EXAM.git](https://github.com/Y0U5F/CRTL-EXAM.git)
    ```
2.  **Execute Scripts in Order**:
    In SQL Server Management Studio (SSMS), open and run the files from the `sql/` directory one by one, following the numbered sequence:
    1.  `1_DDL.sql` - Creates the database schema and all tables.
    2.  `2_DML.sql` - Populates the tables with initial seed data.
    3.  `3_Functions.sql` - Creates all user-defined functions.
    4.  `4_Views_and_SPs.sql` - Creates all views and stored procedures for all roles.
    5.  `5_Triggers.sql` - Creates the database triggers.
    6.  `6_Security.sql` - Sets up all security roles, permissions, and logins.

3.  **Run Demonstration Scenarios (Optional)**:
    Execute `7_Scenario.sql` to see a demonstration of how different roles interact with the system.

## 🛡️ Backup Strategy

A daily full backup job is configured using **SQL Server Agent** to ensure data durability and reliability.

## 👥 Team Members

* Asmaa Gamal Abdalaal Sayed
* Ahmed Magdi Ali Baraka
* Esraa Ramadan Sayed Darder
* Bishoy Samir Najeeb Tawdros
* Yousef Mohamed Soliman Abo-eleneen
* Moaaz Omar Abdelfattah Abdelhamed [cite: 8]
