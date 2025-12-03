# Multi-Agent Student Course Recommendation Workflow

## Overview

This workflow implements a sophisticated multi-agent orchestration system for personalized academic course recommendations. It analyzes student academic history, interests, and career goals to provide tailored course suggestions with prerequisite guidance.

## Workflow Components

### Agents

The system uses three specialized AI agents that work together:

1. **Profile Analyzer Agent** (`.claude/agents/profile_analyzer_agent.md`)
   - Analyzes student academic history and performance
   - Extracts interests and career goals from student input
   - Calculates GPA and identifies strong subject areas
   - Recommends appropriate course difficulty levels

2. **Course Matcher Agent** (`.claude/agents/course_matcher_agent.md`)
   - Evaluates available courses against the student profile
   - Scores courses on interest alignment (40%), career relevance (30%), difficulty match (20%), and strategic value (10%)
   - Returns top 12 courses ranked by relevance

3. **Recommendation Builder Agent** (`.claude/agents/recommendation_builder_agent.md`)
   - Creates personalized recommendations from matched courses
   - Checks prerequisites and student eligibility
   - Generates compelling, actionable recommendations
   - Provides prerequisite guidance for courses not yet eligible

### Command

**Student Evaluation Analysis** (`.claude/commands/student-eval-analysis.md`)
- Orchestrates the complete multi-agent pipeline
- Queries SQLite database for student and course data
- Synthesizes agent outputs into a comprehensive HTML report
- Generates viewable recommendation reports saved to `reports/` directory

## How to Run the Workflow

### Prerequisites

1. **Database Setup**
   - Ensure `sqlite_database.db` exists in the project root
   - The database should be populated with student, course, and academic history data

2. **Virtual Environment** (Optional but Recommended)
   ```powershell
   python -m venv .venv
   .venv\Scripts\activate
   ```

### Running the Workflow

Execute the student evaluation analysis for a specific student:

```bash
# Run the multi-agent orchestration using Claude
gemini
```

Then execute the command (see example below):
```
Please run student-eval-analysis.md file found in .claude/commands/ to generate a report for student 10001 who has interests in accounting and computer science
```

**You will be prompted to provide:**
- Student ID (e.g., `10001`)
- Student interests and career goals (e.g., `accounting and computer science`)

### Output

The workflow generates:
- **Recommendation Report**: HTML file saved to `reports/recommendation_report_[StudentID]_[Timestamp].html`


## Workflow Process

1. **Data Collection**: Queries database for student profile, completed courses, and available courses
2. **Profile Analysis**: Agent 1 creates comprehensive student profile with GPA, interests, and goals
3. **Course Matching**: Agent 2 scores all available courses against the profile
4. **Recommendation Building**: Agent 3 creates top 5 personalized recommendations with prerequisite checks
5. **Report Generation**: HTML report created with full recommendation details and visualizations

## Database Schema

The workflow queries the following tables:
- **Students**: Student profile and GPA data
- **AcademicHistory**: Student completed courses and grades
- **Courses**: Available courses with descriptions and difficulty levels
- **Prerequisites**: Course prerequisite requirements
- **Departments**: Academic department information
- **Classification**: Student class standing information

See `05_DDL_schema_v1.sql` for complete database schema details.

## Example Use Cases

- **New Student**: Analyze first-semester student to find appropriate foundational courses
- **Major Declaration**: Help student transitioning to new major find relevant courses
- **Career Planning**: Recommend courses aligned with specific career goals (e.g., investment banking, data science)
- **Recovery Plan**: Suggest courses to improve GPA and build missing skills

## Troubleshooting

- **Database Connection Issues**: Verify `sqlite_database.db` exists and is accessible
- **Agent Output Errors**: Check that student ID exists in database
- **Missing Prerequisites**: Agents will identify required courses to take first
- **Report Generation**: Ensure `reports/` directory exists and is writable

## Architecture Diagram

```
User Input (Student ID + Interests)
           ↓
    Database Queries
           ↓
    Profile Analyzer Agent
           ↓
    Course Matcher Agent
           ↓
    Recommendation Builder Agent
           ↓
    HTML Report Generation
           ↓
    reports/recommendation_report_[StudentID]_[Timestamp].html
```
