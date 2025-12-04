# Multi-Agent Student Course Recommendation Workflow

## Overview

This workflow implements a sophisticated multi-agent orchestration system for personalized academic course recommendations. It analyzes student academic history, interests, and career goals to provide tailored course suggestions with prerequisite guidance.

The system uses **Claude AI** via the Claude Code CLI tool to orchestrate three specialized AI agents that work collaboratively through a defined command interface. Python orchestration scripts handle data processing and HTML report generation.

## Workflow Architecture

The complete workflow architecture is documented in [`workflow-architecture.md`](./workflow-architecture.md), which includes:
- Detailed system components and interactions
- Mermaid diagram showing data flow and dependencies
- Complete components table with purposes and dependencies
- Tool configurations
- Data flow specifications

## Workflow Components

### Main Command

**Student Evaluation Analysis** (`.claude/commands/student-eval-analysis.md`)
- Orchestrates the complete multi-agent pipeline using Claude AI
- Validates user inputs and student existence in database
- Coordinates execution of all three analysis agents
- Manages Python scripts for data processing and report generation
- Saves results to `reports/{student_id}/` directory

### AI Agents

The system uses three specialized Claude AI agents:

1. **Profile Analyzer Agent** (`.claude/agents/profile_analyzer_agent.md`)
   - Analyzes student academic history and performance metrics
   - Extracts interests and career goals from student input query
   - Calculates GPA from completed course grades
   - Identifies strong subject areas based on performance
   - Recommends appropriate course difficulty levels (1-5 scale)
   - **Output**: `profile_output.json` with complete student analysis

2. **Course Matcher Agent** (`.claude/agents/course_matcher_agent.md`)
   - Evaluates all available courses against the student profile
   - Scores courses using weighted criteria:
     - Interest Alignment (40%): Matches course topics to student interests
     - Career Relevance (30%): Alignment with career goals
     - Difficulty Match (20%): Courses within appropriate difficulty range
     - Strategic Value (10%): Builds on strengths and prerequisites
   - Returns top 12 courses ranked by relevance score (0-100)
   - **Output**: `matched_courses.json` with scored and ranked courses

3. **Recommendation Builder Agent** (`.claude/agents/recommendation_builder_agent.md`)
   - Creates personalized recommendations from top matched courses
   - Verifies prerequisite eligibility for each course
   - Generates compelling, personalized recommendation text
   - Suggests optimal semester for course enrollment
   - Prioritizes courses student can take immediately
   - **Output**: `recommendations.json` with top 5 recommendations and prerequisite guidance

### Python Orchestration Scripts

Executed by the main command in sequence:

1. **`src/orchestration/database_queries.py`**
   - Queries SQLite database for student and course data
   - Extracts: student profile, academic history, available courses, prerequisite map
   - Outputs: Four JSON files to `reports/{student_id}/`

2. **`src/orchestration/course_matcher.py`**
   - Implements the Course Matcher Agent's scoring algorithm
   - Reads: `profile_output.json`, `available_courses.json`, `prerequisites_map.json`
   - Outputs: `matched_courses.json` with top 12 ranked courses

3. **`src/orchestration/recommendation_builder.py`**
   - Implements the Recommendation Builder Agent's logic
   - Reads: `profile_output.json`, `matched_courses.json`, `academic_history.json`, `prerequisites_map.json`
   - Outputs: `recommendations.json` with top 5 recommendations and prerequisite roadmap

4. **`src/orchestration/report_generator.py`**
   - Generates comprehensive HTML report from agent outputs
   - Creates professional, printable recommendation document
   - Outputs: `recommendation_report_{student_id}_{timestamp}.html`

## How to Run the Workflow

### Prerequisites

1. **Database Setup**
   - Ensure `sqlite_database.db` exists in the project root
   - The database should be populated with student, course, and academic history data per schema in `05_DDL_schema_v1.sql`

2. **Python Environment** (Required)
   ```powershell
   python -m venv .venv
   .venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Claude Code CLI** (Required)
   - Install Claude Code CLI tool on your system
   - Ensure you have API credentials configured

### Running the Workflow

To generate a personalized course recommendation report:

```bash
# Launch Claude Code CLI
claude code

# Execute the student evaluation analysis command
/student-eval-analysis 10001 "accounting and computer science"
```

**Command Parameters:**
- `<student_id>`: Numeric student ID (e.g., `10001`)
- `<interests_and_goals>`: String describing student interests and career goals

**Example Commands:**
```bash
/student-eval-analysis 10001 "accounting and computer science"
/student-eval-analysis 10002 "investment banking and corporate finance"
/student-eval-analysis 10003 "data science and machine learning"
```

### Output

The workflow generates multiple output files in `reports/{student_id}/`:
- **`student_profile.json`**: Raw student data from database
- **`academic_history.json`**: List of completed courses and grades
- **`available_courses.json`**: All active courses in database
- **`prerequisites_map.json`**: Course prerequisite requirements
- **`profile_output.json`**: Claude's student analysis output
- **`matched_courses.json`**: Claude's top 12 matched courses
- **`recommendations.json`**: Claude's top 5 recommendations with prerequisite guidance
- **`recommendation_report_{student_id}_{timestamp}.html`**: Final professional report (viewable in browser)


## Workflow Execution Process

The workflow follows this sequence:

1. **Input Validation** → Verify student exists in database
2. **Data Collection** → Query SQLite for student profile, academic history, available courses, prerequisites
3. **Profile Analysis** → Claude analyzes student data and creates profile assessment
4. **Course Matching** → Claude scores all available courses against the student profile
5. **Recommendation Building** → Claude creates top 5 personalized recommendations with prerequisites
6. **Report Generation** → Python script generates professional HTML report with all findings

## Database Schema

The workflow queries the following SQLite tables:
- **Students**: Student profile, GPA, major, classification, academic standing
- **AcademicHistory**: Student completed courses, grades, and terms
- **Courses**: Available courses with descriptions, difficulty levels, credits
- **Prerequisites**: Course prerequisite requirements and minimum grades
- **Departments**: Academic department/school information
- **DifficultyLevels**: Course difficulty classifications (1-5 scale)
- **Classification**: Student class standing (Freshman, Sophomore, etc.)

See `05_DDL_schema_v1.sql` for complete database schema details.

## Example Use Cases

- **New Student**: Analyze first-semester student to find appropriate foundational courses
- **Major Declaration**: Help student transitioning to new major find relevant courses
- **Career Planning**: Recommend courses aligned with specific career goals (e.g., investment banking, data science)
- **Recovery Plan**: Suggest courses to improve GPA and build missing skills
- **Semester Planning**: Get recommendations for upcoming semester registration

## Troubleshooting

- **Database Connection Issues**: Verify `sqlite_database.db` exists in project root and is readable
- **Student Not Found**: Check that student ID exists in database using `sqlite3 sqlite_database.db`
- **Claude API Errors**: Ensure Claude Code CLI is properly configured with valid API credentials
- **Missing Python Dependencies**: Run `pip install -r requirements.txt` in activated virtual environment
- **Report Generation Issues**: Ensure `reports/` directory exists and is writable
- **Script Execution Errors**: Verify Python executable path and that all required packages are installed

## Key Features

- **Personalized Analysis**: Each recommendation is tailored to individual student's interests and goals
- **Prerequisite Verification**: Automatically checks if student is eligible for courses
- **Academic Performance Matching**: Recommends courses at appropriate difficulty levels based on GPA
- **Career-Aligned**: Scores courses based on alignment with stated career goals
- **Professional Reports**: Generates browser-viewable HTML reports with comprehensive analysis
- **Audit Trail**: All intermediate JSON outputs saved for transparency and debugging
