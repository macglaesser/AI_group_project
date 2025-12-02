
import sys
import sqlite3
import json
import datetime

def get_db_connection():
    conn = sqlite3.connect(r'c:\Users\macgl\Projects\ai_group_project\sqlite_database.db')
    conn.row_factory = sqlite3.Row
    return conn

def execute_query(conn, query, params=()):
    cursor = conn.cursor()
    cursor.execute(query, params)
    rows = cursor.fetchall()
    return [dict(row) for row in rows]

def main():
    if len(sys.argv) < 2:
        print("Usage: python database_queries.py <student_id>")
        sys.exit(1)
    student_id = int(sys.argv[1])
    conn = get_db_connection()

    # Query 1: Student Profile Data
    profile_query = """
    SELECT 
      s.StudentID, s.FirstName, s.LastName, s.Email, s.CumulativeGPA,
      d.DepartmentName as Major,
      c.ClassificationName,
      s.AcademicStanding
    FROM Students s
    LEFT JOIN Departments d ON s.MajorID = d.DepartmentID
    LEFT JOIN Classification c ON s.ClassificationID = c.ClassificationID
    WHERE s.StudentID = ?
    """
    profile_data = execute_query(conn, profile_query, (student_id,))
    print(json.dumps({"student_profile": profile_data}))

    # Query 2: Student Academic History
    history_query = """
    SELECT 
      ah.HistoryID,
      c.CourseCode,
      c.CourseName,
      c.CreditHours,
      ah.Grade,
      ah.TermCompleted,
      d.DepartmentName
    FROM AcademicHistory ah
    JOIN Courses c ON ah.CourseID = c.CourseID
    JOIN Departments d ON c.DepartmentID = d.DepartmentID
    WHERE ah.StudentID = ?
    ORDER BY ah.TermCompleted DESC
    """
    history_data = execute_query(conn, history_query, (student_id,))
    print(json.dumps({"academic_history": history_data}))

    # Query 3: All Active Courses
    courses_query = """
    SELECT 
      c.CourseID,
      c.CourseCode,
      c.CourseName,
      c.Description,
      d.DepartmentName,
      c.CreditHours,
      dl.LevelName,
      dl.DisplayOrder as DifficultyLevel,
      im.ModeName as InstructionMode,
      COALESCE(group_concat(p.PrerequisiteCourseID), '') as PrerequisiteCourseIDs
    FROM Courses c
    LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID
    LEFT JOIN DifficultyLevels dl ON c.DifficultyLevelID = dl.DifficultyLevelID
    LEFT JOIN InstructionModes im ON c.InstructionModeID = im.InstructionModeID
    LEFT JOIN Prerequisites p ON c.CourseID = p.CourseID
    WHERE c.Status = 'Active'
    GROUP BY c.CourseID
    ORDER BY c.CourseCode
    """
    courses_data = execute_query(conn, courses_query)
    print(json.dumps({"available_courses": courses_data}))

    # Query 4: Prerequisites Map
    prereqs_query = """
    SELECT 
      c.CourseID,
      c.CourseCode,
      p.PrerequisiteCourseID,
      pc.CourseCode as PrerequisiteCourseCode,
      p.MinimumGrade,
      p.PrerequisiteType
    FROM Prerequisites p
    JOIN Courses c ON p.CourseID = c.CourseID
    JOIN Courses pc ON p.PrerequisiteCourseID = pc.CourseID
    WHERE c.Status = 'Active'
    ORDER BY c.CourseCode
    """
    prereqs_data = execute_query(conn, prereqs_query)
    print(json.dumps({"prerequisites_map": prereqs_data}))

    conn.close()

if __name__ == '__main__':
    main()
