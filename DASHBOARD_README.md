# Academic Course Assistant Dashboard

## Overview

The Academic Course Assistant Dashboard is a modern, interactive Streamlit web application that provides students and advisors with comprehensive course information, analytics, and academic planning tools. It connects to the SQLite database to display real-time course catalog and relevant analytics.

## What It Does

The dashboard provides:

- **Course Catalog Browsing**: Filter and search the complete course catalog by department, difficulty level, and instructor mode
- **Academic Analytics**: Visualize course distribution, difficulty levels, and departmental course offerings
- **Interactive Visualizations**: Charts and graphs for data-driven decision making
- **Real-Time Database Integration**: All data pulled directly from SQLite database

## Technology Stack

- **Framework**: Streamlit 1.51.0
- **Data Processing**: pandas 2.3.3
- **Visualization**: Plotly 6.5.0
- **Database**: SQLite3
- **Language**: Python 3.x

## Prerequisites

### 1. Database Setup

Ensure the SQLite database is properly initialized:

```powershell
# From project root directory
# If database doesn't exist, run the DDL and DML scripts

sqlite3 sqlite_database.db < 05_DDL_schema_v1.sql
sqlite3 sqlite_database.db < 05b_DML_sample_data.sql
```

The database should include:
- Student profiles and academic history
- Course catalog with descriptions and difficulty levels
- Department and prerequisite information
- Course recommendations and academic records

### 2. Virtual Environment Setup

Create and activate a Python virtual environment:

**Windows (PowerShell):**
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

**Windows (Command Prompt):**
```cmd
python -m venv .venv
.venv\Scripts\activate
```

**Mac/Linux:**
```bash
python -m venv .venv
source .venv/bin/activate
```

### 3. Install Dependencies

```powershell
pip install -r requirements.txt
```

This installs:
- `streamlit==1.51.0` - Web application framework
- `pandas==2.2.3` - Data manipulation and analysis
- `plotly==5.24.1` - Interactive visualizations

## Running the Dashboard

### Start the Application

```powershell
streamlit run streamlit_app.py
```

The application will launch in your default web browser at `http://localhost:8501`

### Application Interface

**Sidebar Navigation:**
- Select different dashboard views and reports
- Filter by student, department, or course criteria
- Configure visualization options

**Main Dashboard:**
- Course catalog with search and filtering
- Academic analytics and visualizations

## Database Design

### Core Tables

**Students**
- StudentID, FirstName, LastName, Email, CumulativeGPA
- MajorID, ClassificationID, AcademicStanding
- Stores student profile information

**Courses**
- CourseID, CourseCode, CourseName, Description
- DepartmentID, CreditHours, DifficultyLevel
- PrerequisiteString, IsActive
- Comprehensive course catalog with metadata

**AcademicHistory**
- HistoryID, StudentID, CourseID
- Grade, TermCompleted, CreditHours
- Tracks completed courses and performance

**Prerequisites**
- PrerequisiteID, CourseID, PrerequisiteCourseID
- Defines course prerequisite relationships

**Departments**
- DepartmentID, DepartmentCode, DepartmentName
- Description, DepartmentType, IsActive
- Academic department organization

**Classification**
- ClassificationID, ClassificationName
- Student class standing (Freshman, Sophomore, etc.)

### Database Schema Visualization

```
Students
├── StudentID (PK)
├── MajorID (FK) → Departments
├── ClassificationID (FK) → Classification
└── CumulativeGPA

AcademicHistory
├── HistoryID (PK)
├── StudentID (FK) → Students
├── CourseID (FK) → Courses
└── Grade, TermCompleted

Courses
├── CourseID (PK)
├── DepartmentID (FK) → Departments
├── DifficultyLevel
└── PrerequisiteString

Prerequisites
├── PrerequisiteID (PK)
├── CourseID (FK) → Courses
└── PrerequisiteCourseID (FK) → Courses

Departments
├── DepartmentID (PK)
└── DepartmentType (Major, Concentration, Support)

Classification
├── ClassificationID (PK)
└── ClassificationName
```

For the complete database schema including all columns, constraints, and indexes, see `05_DDL_schema_v1.sql`

## Key Features

### 1. Course Discovery
- Search and filter courses by keyword, department, and difficulty
- View detailed course information

### 2. Academic Analytics
- Visualize course distribution across departments
- Analyze course difficulty levels and credit hour requirements

## Troubleshooting

### Application Won't Start
```powershell
# Check Streamlit is installed
pip list | findstr streamlit

# Reinstall if needed
pip install --upgrade streamlit
```

### Database Connection Error
```powershell
# Verify database file exists
Test-Path sqlite_database.db

# Check database integrity
sqlite3 sqlite_database.db "SELECT COUNT(*) FROM Students;"
```

### Missing Data
- Ensure `05_DDL_schema_v1.sql` and `05b_DML_sample_data.sql` have been run
- Verify `sqlite_database.db` is in the project root directory
- Check file permissions on the database file

### Port Already in Use
```powershell
# Run on different port
streamlit run streamlit_app.py --server.port 8502
```

## Workflow Integration

The dashboard integrates with the multi-agent workflow:
- Displays recommendations generated by `.claude/commands/student-eval-analysis.md`
- Sources course data from the same SQLite database
- Uses the same course catalog and student profiles

## Performance Notes

- Initial load may take a few seconds while querying the database
- Large course catalogs (1000+ courses) may require filtering for optimal performance
- Visualizations are cached and will update when data changes

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the database schema in `05_DDL_schema_v1.sql`
3. Consult the requirements document: `02_product_requirements_document_v1.md`
4. Review entity analysis: `03_erd_entity_analysis_v1.md`
