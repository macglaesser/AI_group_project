# Student Course Recommendation Workflow

You are orchestrating a multi-agent academic advising system. Your role is to:
1. Query the SQLite database to gather student data
2. Delegate specialized tasks to different agents
3. Synthesize all outputs into a comprehensive recommendation report

## Workflow Overview

This command runs a complete multi-agent orchestration pipeline:
- **Agent 1: Profile Analyzer** - Analyzes student academic history and creates profile
- **Agent 2: Course Matcher** - Matches available courses to student profile  
- **Agent 3: Recommendation Builder** - Creates personalized course recommendations with prerequisites
- **Output: Comprehensive Report** - Generates a viewable HTML report of recommendations

## Setup Instructions

Before running this command:

1. **Specify the Student ID**: The command needs a target student. You will be asked for a student ID.
2. **Specify Student Interests**: Provide the interests/goals you want the system to focus on.

## Process

### Step 1: Gather Student Data from Database

First, I'll query the SQLite database at `sqlite_database.db` to collect all necessary information:

```sql
-- Query 1: Student Profile Data
SELECT 
  s.StudentID, s.FirstName, s.LastName, s.Email, s.CumulativeGPA,
  d.DepartmentName as Major,
  c.ClassificationName,
  s.AcademicStanding
FROM Students s
LEFT JOIN Departments d ON s.MajorID = d.DepartmentID
LEFT JOIN Classification c ON s.ClassificationID = c.ClassificationID
WHERE s.StudentID = ?
```

```sql
-- Query 2: Student Academic History with Course Details
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
```

```sql
-- Query 3: All Active Courses Available
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
```

```sql
-- Query 4: Prerequisites Map
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
```

---

### Step 2: Invoke Profile Analyzer Agent

**Task**: Create a student profile based on their academic history and stated interests.

**Context for Agent**:
- Student's completed courses with grades and semesters
- Student's cumulative GPA
- Stated interests and career goals (provided by user)
- Academic performance trends

**Delegation**:
> Use the Profile Analyzer agent definition from `profile_analyzer_agent.md`

**Input Data Structure**:
```json
{
  "student_id": "{student_id_from_db}",
  "user_query": "{user_provided_interests_and_goals}",
  "completed_courses": [
    {
      "course_code": "FINA 3310",
      "course_name": "Financial Management",
      "grade": "A",
      "credits": 3,
      "semester": "Fall 2024"
    }
  ]
}
```

**Expected Output from Agent**:
```json
{
  "student_id": "string",
  "gpa": 3.45,
  "strong_subjects": ["Finance", "Accounting"],
  "interests": ["corporate finance", "investment strategies"],
  "career_goals": "investment banking",
  "preferred_difficulty": 4,
  "analysis_summary": "Brief summary"
}
```

---

### Step 3: Invoke Course Matcher Agent

**Task**: Match available courses to the student's profile and interests.

**Context for Agent**:
- Student profile from Step 2
- All active courses from database
- Course descriptions and prerequisites
- Student's career goals and difficulty preference

**Delegation**:
> Use the Course Matcher agent definition from `course_matcher_agent.md`

**Input Data Structure**:
```json
{
  "student_profile": {
    "student_id": "{from_step_2}",
    "gpa": {gpa},
    "strong_subjects": {strong_subjects},
    "interests": {interests},
    "career_goals": "{career_goals}",
    "preferred_difficulty": {difficulty}
  },
  "available_courses": [
    {
      "course_id": "C001",
      "course_code": "FINA 4350",
      "course_name": "Advanced Corporate Finance",
      "description": "Full description",
      "department": "Finance",
      "credits": 3,
      "difficulty_level": 4,
      "prerequisites": ["FINA 3310"]
    }
  ]
}
```

**Expected Output from Agent**:
```json
[
  {
    "course_id": "C001",
    "course_code": "FINA 4350",
    "course_name": "Advanced Corporate Finance",
    "description": "Course description",
    "department": "Finance",
    "credits": 3,
    "difficulty_level": 4,
    "prerequisites": ["FINA 3310"],
    "relevance_score": 9.2,
    "match_reasoning": "Matches student's finance interest"
  }
]
```

---

### Step 4: Invoke Recommendation Builder Agent

**Task**: Create personalized course recommendations with prerequisite checking.

**Context for Agent**:
- Student profile from Step 2
- Matched courses from Step 3 (top 12)
- Student's completed courses
- Prerequisite relationships from database

**Delegation**:
> Use the Recommendation Builder agent definition from `recommendation_builder_agent.md`

**Input Data Structure**:
```json
{
  "student_profile": {
    "student_id": "{from_step_2}",
    "interests": {interests},
    "career_goals": "{career_goals}",
    "preferred_difficulty": {difficulty}
  },
  "matched_courses": [
    {
      "course_id": "C001",
      "course_code": "FINA 4350",
      "course_name": "Advanced Corporate Finance",
      "difficulty_level": 4,
      "relevance_score": 9.2,
      "prerequisites": ["FINA 3310"]
    }
  ],
  "student_completed_courses": [
    {
      "course_code": "FINA 3310",
      "course_name": "Financial Management"
    }
  ],
  "prerequisite_map": {
    "FINA 4350": ["FINA 3310", "ACCT 2301"]
  }
}
```

**Expected Output from Agent**:
```json
{
  "recommendations": [
    {
      "rank": 1,
      "course_id": "C001",
      "course_code": "FINA 4350",
      "course_name": "Advanced Corporate Finance",
      "credits": 3,
      "difficulty_level": 4,
      "relevance_score": 9.2,
      "eligibility_status": "eligible",
      "missing_prerequisites": [],
      "recommendation_text": "Personalized recommendation",
      "suggested_semester": "Fall 2025"
    }
  ],
  "total_recommendations": 5,
  "prerequisites_to_prioritize": []
}
```

---

### Step 5: Generate HTML Report

**Task**: Synthesize all agent outputs into a professional, viewable HTML report with modern styling.

**Report Sections**:

1. **Executive Summary**
   - Student name and ID
   - Current GPA, major, classification
   - Academic standing
   - Key strengths and interests

2. **Student Profile Analysis** (from Profile Analyzer)
   - Academic performance summary
   - Strong subjects
   - Career goals and interests
   - Recommended difficulty level

3. **Course Recommendations** (from Recommendation Builder)
   - Top 5 recommended courses with:
     - Relevance score and reasoning
     - Eligibility status
     - Prerequisites needed (if any)
     - Personalized recommendation text
     - Suggested semester

4. **Prerequisite Roadmap**
   - Courses to prioritize if prerequisites needed
   - Suggested course sequence/timeline

5. **Next Steps**
   - Recommended action items
   - How to register for courses
   - Advisor contact information

**Report Format**:
- Professional HTML with CSS styling
- Color-coded eligibility status (Green = Eligible, Yellow = Prerequisites Needed)
- Responsive design for viewing on different devices
- Clickable navigation/table of contents
- Print-friendly formatting

**Output Location**: 
Save the report as `recommendation_report_{student_id}_{timestamp}.html` in the reports/ directory

---

## Data Integration Points

The system integrates with your SQLite database (`sqlite_database.db`) using these queries:

### Query Patterns for Agents

**For Profile Analyzer**:
- Join Students → AcademicHistory → Courses → Departments/DifficultyLevels
- Calculate GPA from grades and credit hours
- Identify trends in performance by semester

**For Course Matcher**:
- Select all active courses with full details
- Include prerequisites and difficulty levels
- Filter by status = 'Active' and department relevance

**For Recommendation Builder**:
- Cross-reference student's completed courses against prerequisites
- Build prerequisite map from Prerequisites table
- Ensure no course duplication in recommendations

---

## Workflow Execution Steps

### BEFORE YOU START:
Ask the user for:
1. **Student ID**: Which student should we analyze? (e.g., 100001)
2. **Student Interests/Goals**: What are their interests and career goals? (e.g., "I'm interested in finance and investment strategies. I want to work in investment banking.")

### EXECUTION:

**Phase 1: Database Query**
- Execute the `database_queries.py` script to retrieve student profile, academic history, available courses, and prerequisite map.
- Command: `python src/orchestration/database_queries.py {student_id}`
- The script will output JSON data to stdout. Capture this output for further processing.

**Phase 2: Agent Orchestration**
- Call Profile Analyzer with student data
- Parse JSON response from Profile Analyzer
- Call Course Matcher with profile and courses
- Parse JSON response from Course Matcher
- Call Recommendation Builder with profiles and matched courses
- Parse JSON response from Recommendation Builder

**Phase 3: Report Generation**
- Create professional HTML report
- Include all agent outputs and analysis
- Save to reports/ directory with timestamp
- Provide user with report location and link

---

## Agent Specifications

Each agent follows strict JSON-only output requirements. Ensure:

1. **Profile Analyzer** outputs ONLY valid JSON (no markdown, no explanation)
2. **Course Matcher** outputs ONLY JSON array (no markdown, no explanation)
3. **Recommendation Builder** outputs ONLY JSON object (no markdown, no explanation)

All outputs should be parseable JSON without additional text wrapping.

---

## Error Handling

If an agent fails:
- Capture the error message
- Log to AIAgentLogs with ExecutionStatus: "Partial_Error"
- Provide user-friendly error message
- Suggest retry options

---

## Ready to Begin?

To start the workflow:

1. **Provide Student ID**: Enter the student ID you want to analyze
2. **Provide Interests**: Describe the student's interests, career goals, and any specific focus areas
3. The system will orchestrate all agents and generate a comprehensive recommendation report

Would you like to proceed? Please provide:
- Student ID: 
- Student Interests/Goals:
