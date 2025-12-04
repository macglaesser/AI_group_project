# Student Course Recommendation Workflow

Generates personalized course recommendations for students by analyzing academic history, interests, and career goals using a multi-agent orchestration system.

## Usage
```bash
/student-eval-analysis <student_id> <interests_and_goals>
```

**Examples**:
```bash
# Analyze student 10001 interested in accounting and computer science
/student-eval-analysis 10001 "accounting and computer science"

# Analyze student 10002 interested in investment banking
/student-eval-analysis 10002 "investment banking and corporate finance"
```

## What This Command Does

This workflow orchestrates three specialized agents to create personalized course recommendations:
- **Profile Analysis**: Analyzes student academic history, calculates GPA, identifies strong subjects
- **Course Matching**: Scores available courses based on interest alignment, career relevance, and difficulty fit
- **Recommendation Building**: Creates personalized recommendations with prerequisite verification
- **Report Generation**: Produces a comprehensive HTML report with actionable insights

---

## Implementation Instructions

You are the orchestrator for this workflow. Follow these steps carefully:

### Step 1: Validate Arguments

1. Check that you received exactly 2 arguments: `<student_id>` and `<interests_and_goals>`
2. If arguments are missing, display usage information and exit
3. Verify the student exists in the database by checking the StudentID in the Students table
4. Display: "Starting course recommendation analysis for student: {student_id}"

### Step 2: Query Student Data from Database

Execute the database query script to gather all necessary information. This script will output four JSON objects. Save each of these to a file in the `reports/{student_id}` directory: `student_profile.json`, `academic_history.json`, `available_courses.json`, and `prerequisites_map.json`.

```bash
python src/orchestration/database_queries.py {student_id}
```

If student not found:
- Display: "Error: Student ID '{student_id}' not found in database"
- Display: "Verify the student ID and try again"
- Exit

If reviews found:
- Display: "Found student profile for ID: {student_id}"
- Display: "Academic history: {N} completed courses"
- Display: "Course database: {M} active courses available"

### Step 3: Prepare Output Directory

1. Create a sub-directory in `reports/` named `{student_id}`.
2. Use output directory: `reports/{student_id}/`
3. Create a timestamp: `{YYYYMMDD}_{HHMMSS}`
4. Display: "Output directory ready: reports/{student_id}/"
5. Display: "Timestamp: {timestamp}"

### Step 4: Run Analysis Scripts

Display: "Running analysis scripts..."

**1. Profile Analyzer**

Manually analyze the student's profile, academic history, and interests to create a JSON file named `reports/{student_id}/profile_output.json`. The structure of this file should be as follows:

```json
{
  "student_id": "string",
  "FirstName": "string",
  "LastName": "string",
  "gpa": float,
  "Major": "string",
  "AcademicStanding": "string",
  "strong_subjects": ["string"],
  "interests": ["string"],
  "career_goals": "string",
  "preferred_difficulty": int,
  "analysis_summary": "string"
}
```

**2. Course Matcher**

Execute the course matcher script. This script reads `reports/{student_id}/profile_output.json`, `reports/{student_id}/available_courses.json`, and `reports/{student_id}/prerequisites_map.json`, and writes the top 12 matched courses to `reports/{student_id}/matched_courses.json`.

```bash
python src/orchestration/course_matcher.py
```

**3. Recommendation Builder**

Execute the recommendation builder script. This script reads `reports/{student_id}/profile_output.json`, `reports/{student_id}/matched_courses.json`, `reports/{student_id}/academic_history.json`, and `reports/{student_id}/prerequisites_map.json`, and writes the top 5 recommendations to `reports/{student_id}/recommendations.json`.

```bash
python src/orchestration/recommendation_builder.py
```

### Step 5: Aggregate Agent Outputs

This step is now integrated into the execution of the scripts in Step 4. The output files are:
1. `reports/{student_id}/profile_output.json`
2. `reports/{student_id}/matched_courses.json`
3. `reports/{student_id}/recommendations.json`

Validate that these files are valid JSON.

### Step 6: Generate Comprehensive HTML Report

Execute the report generator script. This script reads the JSON files from the previous steps and generates a comprehensive HTML report.

```bash
python src/orchestration/report_generator.py
```

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
Save the report as `recommendation_report_{student_id}_{timestamp}.html` in the `reports/{student_id}/` directory

Display: "Report generated successfully: reports/{student_id}/recommendation_report_{student_id}_{timestamp}.html"

### Step 7: Summary and Next Steps

Display completion summary:
- Report location
- Number of recommendations generated
- Any prerequisite requirements identified
- Suggestion to view recommendations in dashboard or share with advisor

---

## Database Query Details

First, the SQLite database at `sqlite_database.db` will be queried to collect all necessary information:

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

## Agent Specifications

Each agent follows strict JSON-only output requirements:

### Profile Analyzer Agent (.claude/agents/profile_analyzer_agent.md)
- Input: Student ID, user interests query, completed courses list
- Output: ONLY valid JSON object with student profile
- Required fields: student_id, gpa, strong_subjects, interests, career_goals, preferred_difficulty, analysis_summary

### Course Matcher Agent (.claude/agents/course_matcher_agent.md)
- Input: Student profile, available courses list
- Output: ONLY valid JSON array of top 12 courses
- Required fields per course: course_id, course_code, course_name, relevance_score, match_reasoning
- Scoring: Interest (40%) + Career (30%) + Difficulty (20%) + Strategy (10%)

### Recommendation Builder Agent (.claude/agents/recommendation_builder_agent.md)
- Input: Student profile, matched courses, completed courses, prerequisite map
- Output: ONLY valid JSON object with top 5 recommendations
- Required fields per recommendation: rank, course_code, eligibility_status, missing_prerequisites, recommendation_text, suggested_semester
- Logic: Skip completed courses, check prerequisites, prioritize eligible courses

---

## Error Handling

If any step fails:
- Capture error details and display to user
- Log execution status
- Suggest retry with different parameters
- Provide troubleshooting steps

---

## Example Workflow Execution

```
Input: /student-eval-analysis 10001 "accounting and computer science"

Step 1: Validate arguments ✓
Step 2: Query database with python src/orchestration/database_queries.py 10001 ✓
Step 3: Prepare output directory (reports/10001/) ✓
Step 4: Launch 3 agents in parallel
  Agent 1: Profile Analyzer → 10001/profile_output.json ✓
  Agent 2: Course Matcher → 10001/matched_courses.json ✓
  Agent 3: Recommendation Builder → 10001/recommendations.json ✓
Step 5: Aggregate outputs ✓
Step 6: Generate HTML report ✓
Step 7: Display completion summary

Output: reports/10001/recommendation_report_10001_20251203_120000.html
```
