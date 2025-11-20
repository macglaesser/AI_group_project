"""
Academic Course Assistant System - Streamlit Web Application
Provides a modern web interface for students to view course data
"""

import streamlit as st
import sqlite3
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime
import json

# ============================================================================
# PAGE CONFIGURATION
# ============================================================================

st.set_page_config(
    page_title="Academic Course Assistant",
    page_icon="🎓",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom styling
st.markdown("""
    <style>
    .main {
        padding-top: 2rem;
    }
    .metric-card {
        background-color: #f0f2f6;
        padding: 1.5rem;
        border-radius: 0.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }
    .header-title {
        color: #1f77b4;
        font-size: 2.5rem;
        font-weight: bold;
        margin-bottom: 1rem;
    }
    </style>
    """, unsafe_allow_html=True)

# ============================================================================
# DATABASE CONNECTION
# ============================================================================

def get_db_connection():
    """Create database connection (do NOT cache for SQLite threading issues)"""
    conn = sqlite3.connect('sqlite_database.db', check_same_thread=False)
    conn.row_factory = sqlite3.Row
    return conn

# ============================================================================
# QUERY FUNCTIONS
# ============================================================================

def get_all_courses(conn):
    """Fetch all active courses with department and difficulty info"""
    query = """
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        c.Description,
        c.CreditHours,
        d.DepartmentName,
        dl.LevelName as DifficultyLevel,
        im.ModeName as InstructionMode,
        c.MaxEnrollment,
        c.Status
    FROM Courses c
    LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID
    LEFT JOIN DifficultyLevels dl ON c.DifficultyLevelID = dl.DifficultyLevelID
    LEFT JOIN InstructionModes im ON c.InstructionModeID = im.InstructionModeID
    WHERE c.Status = 'Active'
    ORDER BY c.CourseCode
    """
    return pd.read_sql_query(query, conn)

def get_course_details(conn, course_id):
    """Fetch detailed information about a specific course"""
    query = """
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        c.Description,
        c.CreditHours,
        c.LearningOutcomes,
        d.DepartmentName,
        dl.LevelName as DifficultyLevel,
        im.ModeName as InstructionMode,
        c.MaxEnrollment,
        c.Status,
        c.SyllabusURL
    FROM Courses c
    LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID
    LEFT JOIN DifficultyLevels dl ON c.DifficultyLevelID = dl.DifficultyLevelID
    LEFT JOIN InstructionModes im ON c.InstructionModeID = im.InstructionModeID
    WHERE c.CourseID = ?
    """
    result = pd.read_sql_query(query, conn, params=(course_id,))
    return result.iloc[0] if not result.empty else None

def get_course_prerequisites(conn, course_id):
    """Fetch prerequisites for a course"""
    query = """
    SELECT 
        pc.CourseCode as PrerequisiteCourseCode,
        pc.CourseName as PrerequisiteCourseName,
        p.MinimumGrade,
        p.PrerequisiteType,
        p.Notes
    FROM Prerequisites p
    JOIN Courses pc ON p.PrerequisiteCourseID = pc.CourseID
    WHERE p.CourseID = ?
    ORDER BY p.PrerequisiteType DESC
    """
    return pd.read_sql_query(query, conn, params=(course_id,))

def get_course_schedules(conn, course_id):
    """Fetch all schedules for a course"""
    query = """
    SELECT 
        s.ScheduleID,
        s.Semester,
        s.SectionNumber,
        s.ProfessorName,
        s.MeetingDays,
        s.StartTime,
        s.EndTime,
        s.Location,
        im.ModeName as InstructionMode,
        s.EnrollmentStatus,
        s.CurrentEnrollment,
        s.MaxCapacity,
        s.WaitListCount
    FROM Schedules s
    LEFT JOIN InstructionModes im ON s.InstructionModeID = im.InstructionModeID
    WHERE s.CourseID = ?
    ORDER BY s.Semester DESC, s.SectionNumber
    """
    return pd.read_sql_query(query, conn, params=(course_id,))

def get_departments(conn):
    """Fetch all departments"""
    query = """
    SELECT DISTINCT 
        DepartmentID,
        DepartmentCode,
        DepartmentName,
        DepartmentType
    FROM Departments
    WHERE IsActive = 1
    ORDER BY DepartmentName
    """
    return pd.read_sql_query(query, conn)

def get_courses_by_department(conn, department_id):
    """Fetch courses by department"""
    query = """
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        c.CreditHours,
        dl.LevelName as DifficultyLevel,
        c.Status
    FROM Courses c
    LEFT JOIN DifficultyLevels dl ON c.DifficultyLevelID = dl.DifficultyLevelID
    WHERE c.DepartmentID = ? AND c.Status = 'Active'
    ORDER BY c.CourseCode
    """
    return pd.read_sql_query(query, conn, params=(department_id,))

def get_difficulty_levels(conn):
    """Fetch all difficulty levels"""
    query = """
    SELECT * FROM DifficultyLevels
    ORDER BY DisplayOrder
    """
    return pd.read_sql_query(query, conn)

def get_instruction_modes(conn):
    """Fetch all instruction modes"""
    query = """
    SELECT * FROM InstructionModes
    ORDER BY DisplayOrder
    """
    return pd.read_sql_query(query, conn)

def get_courses_statistics(conn):
    """Fetch course statistics"""
    query = """
    SELECT 
        (SELECT COUNT(*) FROM Courses WHERE Status = 'Active') as total_active_courses,
        (SELECT COUNT(DISTINCT DepartmentID) FROM Courses WHERE Status = 'Active') as total_departments,
        (SELECT AVG(CreditHours) FROM Courses WHERE Status = 'Active') as avg_credit_hours,
        (SELECT COUNT(DISTINCT InstructionModeID) FROM Courses) as instruction_modes
    """
    result = pd.read_sql_query(query, conn)
    return result.iloc[0] if not result.empty else None

def get_courses_by_difficulty(conn):
    """Get course distribution by difficulty level"""
    query = """
    SELECT 
        dl.LevelName as DifficultyLevel,
        COUNT(c.CourseID) as CourseCount
    FROM DifficultyLevels dl
    LEFT JOIN Courses c ON dl.DifficultyLevelID = c.DifficultyLevelID AND c.Status = 'Active'
    GROUP BY dl.DifficultyLevelID, dl.LevelName, dl.DisplayOrder
    ORDER BY dl.DisplayOrder
    """
    return pd.read_sql_query(query, conn)

def get_courses_by_instruction_mode(conn):
    """Get course distribution by instruction mode"""
    query = """
    SELECT 
        im.ModeName as InstructionMode,
        COUNT(c.CourseID) as CourseCount
    FROM InstructionModes im
    LEFT JOIN Courses c ON im.InstructionModeID = c.InstructionModeID AND c.Status = 'Active'
    GROUP BY im.InstructionModeID, im.ModeName, im.DisplayOrder
    ORDER BY im.DisplayOrder
    """
    return pd.read_sql_query(query, conn)

def search_courses(conn, search_term):
    """Search courses by code or name"""
    query = """
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        c.CreditHours,
        d.DepartmentName,
        dl.LevelName as DifficultyLevel,
        c.Status
    FROM Courses c
    LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID
    LEFT JOIN DifficultyLevels dl ON c.DifficultyLevelID = dl.DifficultyLevelID
    WHERE (c.CourseCode LIKE ? OR c.CourseName LIKE ?)
    AND c.Status = 'Active'
    ORDER BY c.CourseCode
    """
    search_pattern = f"%{search_term}%"
    return pd.read_sql_query(query, conn, params=(search_pattern, search_pattern))

# ============================================================================
# PAGE: HOME
# ============================================================================

def page_home():
    """Home/Dashboard page"""
    col1, col2 = st.columns([3, 1])
    
    with col1:
        st.markdown("<div class='header-title'>🎓 Academic Course Assistant</div>", unsafe_allow_html=True)
    
    st.markdown("---")
    
    conn = get_db_connection()
    stats = get_courses_statistics(conn)
    
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.metric("📚 Active Courses", int(stats['total_active_courses']))
    
    with col2:
        st.metric("🏢 Departments", int(stats['total_departments']))
    
    with col3:
        st.metric("⏱️ Avg Credit Hours", f"{stats['avg_credit_hours']:.1f}")
    
    with col4:
        st.metric("🎯 Instruction Modes", int(stats['instruction_modes']))
    
    st.markdown("---")
    
    # Course Distribution Charts
    col1, col2 = st.columns(2)
    
    with col1:
        difficulty_data = get_courses_by_difficulty(conn)
        if not difficulty_data.empty:
            fig = px.bar(
                difficulty_data,
                x='DifficultyLevel',
                y='CourseCount',
                title='Courses by Difficulty Level',
                color='CourseCount',
                color_continuous_scale='Blues',
                labels={'DifficultyLevel': 'Difficulty Level', 'CourseCount': 'Number of Courses'}
            )
            fig.update_layout(height=400, showlegend=False)
            st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        mode_data = get_courses_by_instruction_mode(conn)
        if not mode_data.empty:
            fig = px.pie(
                mode_data,
                names='InstructionMode',
                values='CourseCount',
                title='Courses by Instruction Mode'
            )
            fig.update_layout(height=400)
            st.plotly_chart(fig, use_container_width=True)

# ============================================================================
# PAGE: COURSE BROWSER
# ============================================================================

def page_course_browser():
    """Browse all courses"""
    st.markdown("## 📚 Course Browser")
    st.markdown("---")
    
    conn = get_db_connection()
    
    # Filter options
    col1, col2, col3 = st.columns(3)
    
    with col1:
        departments = get_departments(conn)
        selected_dept = st.selectbox(
            "Filter by Department",
            ["All Departments"] + departments['DepartmentName'].tolist(),
            key="dept_filter"
        )
    
    with col2:
        difficulties = get_difficulty_levels(conn)
        selected_difficulty = st.selectbox(
            "Filter by Difficulty",
            ["All Levels"] + difficulties['LevelName'].tolist(),
            key="diff_filter"
        )
    
    with col3:
        modes = get_instruction_modes(conn)
        selected_mode = st.selectbox(
            "Filter by Instruction Mode",
            ["All Modes"] + modes['ModeName'].tolist(),
            key="mode_filter"
        )
    
    st.markdown("---")
    
    # Get courses
    courses_df = get_all_courses(conn)
    
    # Apply filters
    if selected_dept != "All Departments":
        courses_df = courses_df[courses_df['DepartmentName'] == selected_dept]
    
    if selected_difficulty != "All Levels":
        courses_df = courses_df[courses_df['DifficultyLevel'] == selected_difficulty]
    
    if selected_mode != "All Modes":
        courses_df = courses_df[courses_df['InstructionMode'] == selected_mode]
    
    st.subheader(f"Found {len(courses_df)} Courses")
    
    # Display courses
    if len(courses_df) > 0:
        for idx, course in courses_df.iterrows():
            with st.container():
                col1, col2 = st.columns([4, 1])
                
                with col1:
                    if st.button(
                        f"📖 {course['CourseCode']} - {course['CourseName']}",
                        key=f"course_{course['CourseID']}"
                    ):
                        st.session_state.selected_course_id = course['CourseID']
                        st.session_state.page = "course_details"
                        st.rerun()
                    
                    col_a, col_b, col_c, col_d = st.columns(4)
                    with col_a:
                        st.caption(f"👥 Department: {course['DepartmentName']}")
                    with col_b:
                        st.caption(f"⏱️ Credits: {course['CreditHours']}")
                    with col_c:
                        st.caption(f"📊 Level: {course['DifficultyLevel']}")
                    with col_d:
                        st.caption(f"🎯 Mode: {course['InstructionMode']}")
                    
                    st.caption(course['Description'][:200] + "..." if len(str(course['Description'])) > 200 else course['Description'])
                
                with col2:
                    enrollment_pct = (course['MaxEnrollment'] / 100) * 100 if course['MaxEnrollment'] else 0
                    st.metric("Max Enrollment", course['MaxEnrollment'])
                
                st.markdown("---")
    else:
        st.info("No courses found matching the selected filters.")

# ============================================================================
# PAGE: COURSE DETAILS
# ============================================================================

def page_course_details():
    """Display detailed information about a specific course"""
    conn = get_db_connection()
    
    if "selected_course_id" not in st.session_state:
        st.warning("No course selected")
        return
    
    course_id = st.session_state.selected_course_id
    course = get_course_details(conn, course_id)
    
    if course is None:
        st.error("Course not found")
        return
    
    # Back button
    col1, col2 = st.columns([1, 5])
    with col1:
        if st.button("← Back"):
            st.session_state.page = "course_browser"
            st.rerun()
    
    st.markdown(f"## 📖 {course['CourseCode']} - {course['CourseName']}")
    st.markdown("---")
    
    # Course basic info
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Credit Hours", course['CreditHours'])
    with col2:
        st.metric("Difficulty", course['DifficultyLevel'])
    with col3:
        st.metric("Department", course['DepartmentName'])
    with col4:
        st.metric("Instruction Mode", course['InstructionMode'])
    
    st.markdown("---")
    
    # Description
    st.subheader("📝 Course Description")
    st.write(course['Description'])
    
    # Learning Outcomes
    if pd.notna(course['LearningOutcomes']) and course['LearningOutcomes']:
        st.subheader("🎯 Learning Outcomes")
        st.write(course['LearningOutcomes'])
    
    # Syllabus link
    if pd.notna(course['SyllabusURL']) and course['SyllabusURL']:
        st.subheader("📄 Course Syllabus")
        st.markdown(f"[Download Syllabus]({course['SyllabusURL']})")
    
    st.markdown("---")
    
    # Prerequisites
    prerequisites = get_course_prerequisites(conn, course_id)
    if not prerequisites.empty:
        st.subheader("📋 Prerequisites")
        
        # Organize by type
        hard_prereqs = prerequisites[prerequisites['PrerequisiteType'] == 'Hard']
        recommended = prerequisites[prerequisites['PrerequisiteType'] == 'Recommended']
        coreqs = prerequisites[prerequisites['PrerequisiteType'] == 'Co-requisite']
        
        if not hard_prereqs.empty:
            st.markdown("**Required Prerequisites:**")
            for _, prereq in hard_prereqs.iterrows():
                st.caption(f"• {prereq['PrerequisiteCourseCode']} - {prereq['PrerequisiteCourseName']} (Min Grade: {prereq['MinimumGrade']})")
        
        if not recommended.empty:
            st.markdown("**Recommended Prerequisites:**")
            for _, prereq in recommended.iterrows():
                st.caption(f"• {prereq['PrerequisiteCourseCode']} - {prereq['PrerequisiteCourseName']}")
        
        if not coreqs.empty:
            st.markdown("**Co-requisites:**")
            for _, prereq in coreqs.iterrows():
                st.caption(f"• {prereq['PrerequisiteCourseCode']} - {prereq['PrerequisiteCourseName']}")
    
    st.markdown("---")
    
    # Schedules
    schedules = get_course_schedules(conn, course_id)
    if not schedules.empty:
        st.subheader("📅 Available Schedules")
        
        # Display as table
        display_cols = ['Semester', 'SectionNumber', 'ProfessorName', 'MeetingDays', 
                       'StartTime', 'EndTime', 'Location', 'InstructionMode', 
                       'EnrollmentStatus', 'CurrentEnrollment', 'MaxCapacity']
        
        schedule_display = schedules[display_cols].copy()
        schedule_display.columns = ['Semester', 'Section', 'Professor', 'Days', 
                                   'Start', 'End', 'Location', 'Mode', 
                                   'Status', 'Enrolled', 'Capacity']
        
        st.dataframe(schedule_display, use_container_width=True, hide_index=True)
        
        # Enrollment overview
        col1, col2 = st.columns(2)
        with col1:
            status_counts = schedules['EnrollmentStatus'].value_counts()
            fig = px.pie(
                values=status_counts.values,
                names=status_counts.index,
                title='Schedule Enrollment Status',
                color_discrete_map={
                    'Open': '#2ecc71',
                    'Full': '#e74c3c',
                    'Closed': '#95a5a6',
                    'Waitlist': '#f39c12'
                }
            )
            st.plotly_chart(fig, use_container_width=True)
        
        with col2:
            total_enrolled = schedules['CurrentEnrollment'].sum()
            total_capacity = schedules['MaxCapacity'].sum()
            fig = go.Figure(data=[
                go.Bar(name='Enrolled', x=['Total'], y=[total_enrolled]),
                go.Bar(name='Available', x=['Total'], y=[total_capacity - total_enrolled])
            ])
            fig.update_layout(
                title='Overall Enrollment',
                barmode='stack',
                height=400,
                xaxis_title='',
                yaxis_title='Students'
            )
            st.plotly_chart(fig, use_container_width=True)
    else:
        st.info("No schedules available for this course.")

# ============================================================================
# PAGE: SEARCH
# ============================================================================

def page_search():
    """Search courses by code or name"""
    st.markdown("## 🔍 Course Search")
    st.markdown("---")
    
    search_term = st.text_input(
        "Search by course code or name",
        placeholder="e.g., 'BUS101' or 'Introduction to Business'"
    )
    
    if search_term:
        conn = get_db_connection()
        results = search_courses(conn, search_term)
        
        st.subheader(f"Found {len(results)} Results")
        
        if len(results) > 0:
            for idx, course in results.iterrows():
                col1, col2 = st.columns([4, 1])
                
                with col1:
                    if st.button(
                        f"📖 {course['CourseCode']} - {course['CourseName']}",
                        key=f"search_course_{course['CourseID']}"
                    ):
                        st.session_state.selected_course_id = course['CourseID']
                        st.session_state.page = "course_details"
                        st.rerun()
                    
                    col_a, col_b, col_c = st.columns(3)
                    with col_a:
                        st.caption(f"👥 {course['DepartmentName']}")
                    with col_b:
                        st.caption(f"⏱️ {course['CreditHours']} Credits")
                    with col_c:
                        st.caption(f"📊 {course['DifficultyLevel']}")
                
                st.markdown("---")
        else:
            st.info("No courses found.")
    else:
        st.info("Enter a search term to find courses.")

# ============================================================================
# PAGE: STATISTICS
# ============================================================================

def page_statistics():
    """Display database statistics"""
    st.markdown("## 📊 Course Statistics")
    st.markdown("---")
    
    conn = get_db_connection()
    
    # Overall statistics
    query_stats = """
    SELECT 
        (SELECT COUNT(*) FROM Courses WHERE Status = 'Active') as total_courses,
        (SELECT COUNT(DISTINCT DepartmentID) FROM Courses) as total_depts,
        (SELECT COUNT(*) FROM Schedules) as total_schedules,
        (SELECT COUNT(DISTINCT Semester) FROM Schedules) as semesters,
        (SELECT AVG(CreditHours) FROM Courses WHERE Status = 'Active') as avg_credits,
        (SELECT SUM(MaxCapacity) FROM Schedules) as total_capacity
    """
    stats = pd.read_sql_query(query_stats, conn)
    stats = stats.iloc[0]
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("Total Active Courses", int(stats['total_courses']))
    with col2:
        st.metric("Total Departments", int(stats['total_depts']))
    with col3:
        st.metric("Total Schedules", int(stats['total_schedules']))
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("Semesters Offered", int(stats['semesters']))
    with col2:
        st.metric("Avg Credit Hours", f"{stats['avg_credits']:.1f}")
    with col3:
        st.metric("Total Capacity", int(stats['total_capacity']))
    
    st.markdown("---")
    
    # Courses per department
    dept_query = """
    SELECT 
        d.DepartmentName,
        COUNT(c.CourseID) as CourseCount
    FROM Departments d
    LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID AND c.Status = 'Active'
    WHERE d.IsActive = 1
    GROUP BY d.DepartmentID, d.DepartmentName
    ORDER BY CourseCount DESC
    """
    dept_data = pd.read_sql_query(dept_query, conn)
    
    col1, col2 = st.columns(2)
    with col1:
        fig = px.bar(
            dept_data,
            x='DepartmentName',
            y='CourseCount',
            title='Courses per Department',
            labels={'DepartmentName': 'Department', 'CourseCount': 'Number of Courses'},
            color='CourseCount',
            color_continuous_scale='Blues'
        )
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)
    
    # Credit hours distribution
    with col2:
        credit_query = """
        SELECT 
            CreditHours,
            COUNT(*) as CourseCount
        FROM Courses
        WHERE Status = 'Active'
        GROUP BY CreditHours
        ORDER BY CreditHours
        """
        credit_data = pd.read_sql_query(credit_query, conn)
        
        fig = px.bar(
            credit_data,
            x='CreditHours',
            y='CourseCount',
            title='Course Distribution by Credit Hours',
            labels={'CreditHours': 'Credit Hours', 'CourseCount': 'Number of Courses'},
            color='CourseCount',
            color_continuous_scale='Greens'
        )
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)
    
    st.markdown("---")
    
    # Enrollment by semester
    semester_query = """
    SELECT 
        Semester,
        SUM(CurrentEnrollment) as TotalEnrolled,
        SUM(MaxCapacity) as TotalCapacity
    FROM Schedules
    GROUP BY Semester
    ORDER BY Semester DESC
    LIMIT 10
    """
    semester_data = pd.read_sql_query(semester_query, conn)
    
    if not semester_data.empty:
        fig = go.Figure(data=[
            go.Bar(name='Enrolled', x=semester_data['Semester'], y=semester_data['TotalEnrolled']),
            go.Bar(name='Capacity', x=semester_data['Semester'], y=semester_data['TotalCapacity'])
        ])
        fig.update_layout(
            title='Enrollment by Semester',
            barmode='group',
            height=400,
            xaxis_title='Semester',
            yaxis_title='Number of Students'
        )
        st.plotly_chart(fig, use_container_width=True)

# ============================================================================
# MAIN APP
# ============================================================================

def main():
    """Main application"""
    
    # Initialize session state
    if "page" not in st.session_state:
        st.session_state.page = "home"
    if "selected_course_id" not in st.session_state:
        st.session_state.selected_course_id = None
    
    # Sidebar navigation
    with st.sidebar:
        st.title("🎓 Course Assistant")
        st.markdown("---")
        
        page = st.radio(
            "Navigation",
            ["Home", "Browse Courses", "Search", "Statistics"],
            key="nav_radio"
        )
        
        if page == "Home":
            st.session_state.page = "home"
        elif page == "Browse Courses":
            st.session_state.page = "course_browser"
        elif page == "Search":
            st.session_state.page = "search"
        elif page == "Statistics":
            st.session_state.page = "statistics"
        
        st.markdown("---")
        st.markdown("""
        ### About
        This application allows students to explore courses offered by the Cox School of Business.
        Browse courses, view schedules, and learn about prerequisites.
        """)
        
        st.markdown("---")
        st.caption(f"Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    
    # Main content
    if st.session_state.page == "home":
        page_home()
    elif st.session_state.page == "course_browser":
        page_course_browser()
    elif st.session_state.page == "course_details":
        page_course_details()
    elif st.session_state.page == "search":
        page_search()
    elif st.session_state.page == "statistics":
        page_statistics()

if __name__ == "__main__":
    main()
