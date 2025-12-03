# Workflow Architecture Documentation

## 1. Overview

### Workflow: Student Course Recommendation System

**Purpose**: A comprehensive multi-agent orchestration system that analyzes student academic history and provides personalized course recommendations based on interests, career goals, and academic performance.

**CLI Tool Used**: Claude AI (via `.claude/commands/` integration) - The system uses Claude as the orchestrator to delegate tasks to specialized agents and synthesize results.

**Workflow Definition Location**: `.claude/commands/student-eval-analysis.md`

**Key Capabilities**:
- Automated student profile analysis from academic history
- Intelligent course matching based on interests and goals
- Prerequisite-aware recommendation generation
- Professional HTML report generation with timestamps

---

## 2. Workflow Diagram

Since Mermaid rendering can be inconsistent, here's the workflow visualized as an ASCII flow diagram:

```
┌─────────────────────────────────────────────────────────────────────────┐
│  STUDENT COURSE RECOMMENDATION WORKFLOW - COMPLETE FLOW                 │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: USER INPUT
┌──────────────────────────┐
│ Student ID: 10001        │
│ Interests: accounting &  │
│            comp science  │
└────────────┬─────────────┘
             │
             ▼
STEP 2: DATABASE QUERIES (4 Parallel Queries)
┌──────────────────────────┬──────────────────────────┬──────────────────────────┬──────────────────────────┐
│ Query 1:                 │ Query 2:                  │ Query 3:                 │ Query 4:                 │
│ Student Profile          │ Academic History         │ Available Courses        │ Prerequisites Map        │
│ - StudentID              │ - Completed courses      │ - Course catalog         │ - Prerequisites          │
│ - Name                   │ - Grades                 │ - Descriptions           │ - Relationships          │
│ - GPA                    │ - Terms                  │ - Difficulty levels      │ - Min grades             │
│ - Major                  │ - Credits                │ - Credits                │                          │
└────────────┬─────────────┴──────────────────────┬────┴──────────────────┬────┴──────────────────────┘
             │                                   │                       │
             └───────────────────┬───────────────┘                       │
                                 │                                       │
                                 ▼                                       │
                    DATABASE OUTPUT (JSON)◄────────────────────────────┘
                                 │
                                 ▼
STEP 3: AGENT 1 - PROFILE ANALYZER
┌────────────────────────────────────────────────┐
│ Input: Student ID, interests, completed courses │
├────────────────────────────────────────────────┤
│ Process:                                        │
│  • Calculate GPA from grades                   │
│  • Extract interests from user query           │
│  • Identify strong subjects                    │
│  • Recommend difficulty level (1-5)            │
├────────────────────────────────────────────────┤
│ Output: Student Profile JSON                   │
│ {                                              │
│   "student_id": "10001",                       │
│   "gpa": 3.45,                                 │
│   "strong_subjects": ["Accounting", "Finance"],│
│   "interests": ["accounting", "comp science"], │
│   "career_goals": "investment banking",        │
│   "preferred_difficulty": 4                    │
│ }                                              │
└────────────┬─────────────────────────────────┘
             │
             ▼
STEP 4: AGENT 2 - COURSE MATCHER
┌────────────────────────────────────────────────┐
│ Input: Student profile + Available courses      │
├────────────────────────────────────────────────┤
│ Scoring (weighted):                             │
│  • Interest Alignment:     40%                 │
│  • Career Relevance:       30%                 │
│  • Difficulty Match:       20%                 │
│  • Strategic Value:        10%                 │
│                                                │
│ Output: Top 12 Courses JSON                    │
│ [                                              │
│   {                                            │
│     "course_code": "FINA 4350",                │
│     "course_name": "Advanced Corp Finance",   │
│     "relevance_score": 9.2,                    │
│     "match_reasoning": "..."                   │
│   },                                           │
│   ... (11 more)                               │
│ ]                                              │
└────────────┬─────────────────────────────────┘
             │
             ▼
STEP 5: AGENT 3 - RECOMMENDATION BUILDER
┌────────────────────────────────────────────────┐
│ Input: Profile, matched courses, prerequisites │
├────────────────────────────────────────────────┤
│ Process:                                        │
│  • Check if course already completed           │
│  • Verify prerequisite requirements            │
│  • Determine eligibility status                │
│  • Create personalized recommendation          │
│  • Suggest semester                            │
│                                                │
│ Output: Top 5 Recommendations JSON             │
│ {                                              │
│   "recommendations": [                         │
│     {                                          │
│       "rank": 1,                               │
│       "course_code": "FINA 4350",              │
│       "eligibility_status": "eligible",        │
│       "recommendation_text": "...",            │
│       "suggested_semester": "Fall 2025"        │
│     },                                         │
│     ... (4 more)                              │
│   ]                                            │
│ }                                              │
└────────────┬─────────────────────────────────┘
             │
             ▼
STEP 6: REPORT GENERATION
┌────────────────────────────────────────────────┐
│ Synthesize all outputs into HTML Report        │
├────────────────────────────────────────────────┤
│ Report Sections:                                │
│  1. Executive Summary                          │
│  2. Student Profile Analysis                   │
│  3. Course Recommendations (Top 5)             │
│  4. Prerequisite Roadmap                       │
│  5. Next Steps                                 │
│                                                │
│ Styling:                                       │
│  • Professional CSS layout                     │
│  • Color-coded eligibility                     │
│  • Responsive design                           │
│  • Print-friendly                              │
└────────────┬─────────────────────────────────┘
             │
             ▼
STEP 7: OUTPUT
┌────────────────────────────────────────────────┐
│ File: recommendation_report_10001_20251202.html│
│ Location: reports/ directory                   │
│ Status: Ready for viewing/download             │
└────────────────────────────────────────────────┘
```

---

## 3. Components Table

| Component Type | Name | Purpose | Dependencies |
|----------------|------|---------|--------------|
| **Main Workflow** | Student Course Recommendation System | Orchestrate multi-agent pipeline for course recommendations | `.claude/commands/student-eval-analysis.md`, SQLite database |
| **Sub-Agent** | Profile Analyzer | Analyze student academic history and create profile | Student ID, completed courses data, user interests |
| **Sub-Agent** | Course Matcher | Match available courses to student profile using weighted scoring | Student profile (from Agent 1), course catalog |
| **Sub-Agent** | Recommendation Builder | Create personalized recommendations with prerequisite checking | Student profile (from Agent 1), matched courses (from Agent 2), prerequisite map |
| **Tool** | Database Query Script | Execute SQL queries against SQLite database | `src/orchestration/database_queries.py`, `sqlite_database.db` |
| **Tool** | HTML Report Generator | Synthesize agent outputs into professional HTML report | All agent outputs, CSS styling templates |
| **Data Source** | SQLite Database | Central repository for student, course, and prerequisite data | `sqlite_database.db` |
| **Reference Data** | Agent Definitions | JSON output specifications and processing rules | `.claude/agents/profile_analyzer_agent.md`, `.claude/agents/course_matcher_agent.md`, `.claude/agents/recommendation_builder_agent.md` |

---

## 4. Tool Usage

### 4.1 Built-in Tools Used

| Tool | Purpose | Usage Location | Method |
|------|---------|-----------------|--------|
| **SQLite Query Execution** | Execute parameterized SQL queries | Database Query Phase | `database_queries.py` uses `sqlite3.connect()` and `cursor.execute()` |
| **JSON Parsing/Serialization** | Convert data between Python objects and JSON | Throughout workflow | `json.dumps()` and `json.loads()` |
| **File I/O** | Read agent definitions and write output reports | Report generation | Write HTML to `reports/` directory with timestamp |
| **System Arguments** | Accept student ID from command line | `database_queries.py main()` | `sys.argv[1]` captures student ID parameter |

### 4.2 MCP Servers / Custom Tools

**None configured in current implementation.** The system uses:
- Standard Python SQLite3 library
- Claude AI API for agent processing
- Native file system operations

### 4.3 External APIs/Services Integrated

| Service | Purpose | Integration Point |
|---------|---------|-------------------|
| **Claude AI API** | LLM backbone for agent processing | Invoked during "Agent Orchestration Phase" |
| **SQLite Database** | Data persistence and querying | All database operations |

### 4.4 Database Tools & Operations

| Operation | SQL Location | Purpose |
|-----------|--------------|---------|
| **Student Profile Query** | `database_queries.py` lines 27-34 | Retrieve student info, major, GPA, classification |
| **Academic History Query** | `database_queries.py` lines 37-47 | Get completed courses with grades and semesters |
| **Available Courses Query** | `database_queries.py` lines 50-63 | Fetch all active courses with difficulty and prerequisites |
| **Prerequisites Map Query** | `database_queries.py` lines 66-76 | Build prerequisite relationships and grade requirements |

---

## 5. Data Flow

### 5.1 Input Requirements

**User Inputs**:
1. **Student ID**: Target student for analysis (e.g., `10001`)
2. **Interests/Career Goals**: Text describing student's interests and objectives (e.g., "accounting and computer science")

**System Inputs**:
- `sqlite_database.db`: Complete academic database with all student, course, and prerequisite data
- Agent definitions in `.claude/agents/` directory

### 5.2 Data Movement Between Agents

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      DATABASE QUERY PHASE                               │
│  Output: 4 JSON objects (profile, history, courses, prerequisites)      │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ AGENT 1: PROFILE ANALYZER                                               │
│                                                                         │
│ Input:  - student_id, user_query, completed_courses                    │
│ Process: Calculate GPA, extract interests, determine difficulty level   │
│                                                                         │
│ Output: {                                                              │
│   "student_id": "10001",                                               │
│   "gpa": 3.45,                                                         │
│   "strong_subjects": ["Accounting", "Finance"],                        │
│   "interests": ["accounting", "computer science"],                     │
│   "career_goals": "investment banking",                                │
│   "preferred_difficulty": 4,                                           │
│   "analysis_summary": "..."                                            │
│ }                                                                       │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ AGENT 2: COURSE MATCHER                                                │
│                                                                         │
│ Input:  - student_profile (from Agent 1)                               │
│         - available_courses (from DB)                                  │
│                                                                         │
│ Process: Score courses using 4 criteria:                               │
│  • Interest Alignment (40%)                                            │
│  • Career Relevance (30%)                                              │
│  • Difficulty Match (20%)                                              │
│  • Strategic Value (10%)                                               │
│  Rank top 12 courses by relevance_score                               │
│                                                                         │
│ Output: [                                                              │
│   {                                                                    │
│     "course_id": "C001",                                               │
│     "course_code": "FINA 4350",                                        │
│     "course_name": "Advanced Corporate Finance",                       │
│     "description": "...",                                              │
│     "department": "Finance",                                           │
│     "credits": 3,                                                      │
│     "difficulty_level": 4,                                             │
│     "prerequisites": ["FINA 3310", "ACCT 2301"],                      │
│     "relevance_score": 9.2,                                            │
│     "match_reasoning": "Matches student's finance interest..."        │
│   },                                                                   │
│   ... (11 more courses)                                               │
│ ]                                                                      │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ AGENT 3: RECOMMENDATION BUILDER                                         │
│                                                                         │
│ Input:  - student_profile (from Agent 1)                               │
│         - matched_courses (from Agent 2)                               │
│         - student_completed_courses (from DB)                          │
│         - prerequisite_map (from DB)                                   │
│                                                                         │
│ Process: For top 5 courses:                                            │
│  • Check if already completed (skip if yes)                            │
│  • Verify all prerequisites met                                        │
│  • Determine eligibility_status                                        │
│  • Create personalized recommendation_text                             │
│  • Suggest semester                                                    │
│                                                                         │
│ Output: {                                                              │
│   "recommendations": [                                                 │
│     {                                                                  │
│       "rank": 1,                                                       │
│       "course_code": "FINA 4350",                                      │
│       "course_name": "Advanced Corporate Finance",                     │
│       "eligibility_status": "eligible|prerequisites_needed",          │
│       "missing_prerequisites": ["FINA 3320"],                         │
│       "recommendation_text": "This course directly aligns with...",   │
│       "suggested_semester": "Fall 2025"                                │
│     },                                                                 │
│     ... (4 more recommendations)                                      │
│   ],                                                                   │
│   "prerequisites_to_prioritize": [...]                                │
│ }                                                                      │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│               HTML REPORT GENERATION & OUTPUT                           │
│                                                                         │
│ Synthesizes all outputs into structured HTML report:                  │
│  1. Executive Summary (student name, GPA, major, standing)            │
│  2. Student Profile Analysis (from Agent 1)                           │
│  3. Course Recommendations (from Agent 3)                             │
│  4. Prerequisite Roadmap (sequence suggestions)                       │
│  5. Next Steps (action items, contact info)                           │
│                                                                         │
│ Output: recommendation_report_10001_20251202_152915.html               │
│         (saved to reports/ directory)                                  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.3 Output Produced

**Primary Output**:
- **HTML Report** (`reports/recommendation_report_[StudentID]_[Timestamp].html`)
  - Professional, styled, viewable in browser
  - Sections: Executive Summary, Profile Analysis, Recommendations, Roadmap, Next Steps
  - Color-coded eligibility (Green=Eligible, Yellow=Prerequisites Needed)
  - Print-friendly formatting
  - Responsive design for multiple devices

**Intermediate Outputs** (captured during execution):
- JSON from Profile Analyzer (student profile object)
- JSON from Course Matcher (array of 12 scored courses)
- JSON from Recommendation Builder (5 recommendations with metadata)

**Side Effects**:
- All agent outputs logged for audit trail
- Timestamped files enable tracking of multiple recommendation runs

---

## 6. Agent Communication Protocol

### JSON-Only Output Requirement

Each agent follows **strict JSON-only output** specifications:

**Profile Analyzer**:
- Returns: Single JSON object
- No markdown, no explanation, no additional text
- Output must be valid JSON parseable

**Course Matcher**:
- Returns: JSON array (exactly 12 courses or fewer)
- No markdown, no explanation, no additional text
- Sorted by `relevance_score` descending
- Output must be valid JSON parseable

**Recommendation Builder**:
- Returns: Single JSON object with `recommendations` array
- No markdown, no explanation, no additional text
- Maximum 5 recommendations (ranked)
- Includes `prerequisites_to_prioritize` array
- Output must be valid JSON parseable

### Error Handling

If agent fails:
1. Error captured and logged
2. System logs to AIAgentLogs with ExecutionStatus: "Partial_Error"
3. User receives friendly error message
4. Retry options provided

---

## 7. Workflow Execution Steps

### Phase 1: Input & Initialization
1. User provides Student ID (e.g., `10001`)
2. User provides interests/career goals (free text)
3. System validates student exists in database

### Phase 2: Database Query
1. Execute 4 parameterized SQL queries:
   - Student profile (basic info + GPA)
   - Academic history (completed courses with grades)
   - Available courses catalog
   - Prerequisites map
2. Compile results into JSON structures
3. Pass to Agent 1

### Phase 3: Agent 1 - Profile Analysis
1. Receive: student_id, user_query, completed_courses
2. Calculate GPA from grades (A=4.0, A-=3.7, B+=3.3, B=3.0, etc.)
3. Identify strong subjects from high grades
4. Extract interests from user_query
5. Infer career_goals from interests or use explicit mention
6. Recommend difficulty level (1-5):
   - GPA 3.5+: difficulty 4-5
   - GPA 3.0-3.5: difficulty 3-4
   - GPA 2.5-3.0: difficulty 2-3
   - GPA <2.5: difficulty 1-2
7. Output: Comprehensive student profile

### Phase 4: Agent 2 - Course Matching
1. Receive: student_profile, available_courses
2. For each course, calculate relevance_score:
   - Interest Alignment (40%): keyword matching against interests
   - Career Relevance (30%): alignment with career_goals
   - Difficulty Match (20%): closeness to preferred_difficulty
   - Strategic Value (10%): builds on strong subjects
3. Scoring scale:
   - 9.0-10.0: Excellent match
   - 7.0-8.9: Strong match
   - 5.0-6.9: Moderate match
   - 3.0-4.9: Weak match
   - 0.0-2.9: Poor match
4. Rank all courses by relevance_score
5. Output: Top 12 courses with scores and reasoning

### Phase 5: Agent 3 - Recommendation Building
1. Receive: student_profile, matched_courses (top 12), completed_courses, prerequisite_map
2. For each of top 12 courses:
   - Skip if already completed
   - Check prerequisites:
     - All met → eligibility_status = "eligible"
     - Some missing → eligibility_status = "prerequisites_needed"
   - Generate personalized recommendation_text (3-4 sentences)
     - How it matches interests
     - Why valuable for career
     - When to take (next semester or after prerequisites)
     - What opportunities it creates
3. Build prerequisite_to_prioritize list (courses needed for multiple recommendations)
4. Select top 5 recommendations (prioritize eligible courses)
5. Output: Structured recommendation object with 5 courses

### Phase 6: Report Generation
1. Synthesize all outputs into HTML
2. Create sections:
   - **Executive Summary**: Name, ID, GPA, major, classification, standing
   - **Profile Analysis**: Academic performance, strong subjects, interests, goals
   - **Recommendations**: Top 5 courses with eligibility, prerequisites, reasoning
   - **Prerequisite Roadmap**: Course sequence suggestions
   - **Next Steps**: Action items, registration guidance, advisor contact
3. Apply CSS styling:
   - Professional layout
   - Color-coded eligibility
   - Responsive design
4. Generate timestamp: `YYYYMMDD_HHMMSS`
5. Save: `reports/recommendation_report_[StudentID]_[Timestamp].html`

### Phase 7: Completion
1. Return report location to user
2. Log successful execution
3. Make report available for viewing/download

---

## 8. Database Schema Integration

### Tables Queried

| Table | Purpose | Fields Used |
|-------|---------|-------------|
| **Students** | Student profiles | StudentID, FirstName, LastName, Email, CumulativeGPA, MajorID, ClassificationID, AcademicStanding |
| **AcademicHistory** | Completed courses & grades | HistoryID, StudentID, CourseID, Grade, TermCompleted |
| **Courses** | Course catalog | CourseID, CourseCode, CourseName, Description, DepartmentID, CreditHours, DifficultyLevelID, Status |
| **Departments** | Academic departments | DepartmentID, DepartmentName, DepartmentCode |
| **Prerequisites** | Prerequisite requirements | PrerequisiteID, CourseID, PrerequisiteCourseID, MinimumGrade, PrerequisiteType |
| **DifficultyLevels** | Course difficulty scale | DifficultyLevelID, LevelName, DisplayOrder |
| **Classification** | Student class standing | ClassificationID, ClassificationName |
| **InstructionModes** | Course delivery method | InstructionModeID, ModeName |

### Query Join Patterns

**Profile Query**:
```
Students 
  LEFT JOIN Departments (on MajorID)
  LEFT JOIN Classification (on ClassificationID)
```

**History Query**:
```
AcademicHistory
  JOIN Courses (on CourseID)
  JOIN Departments (on DepartmentID)
```

**Courses Query**:
```
Courses
  LEFT JOIN Departments
  LEFT JOIN DifficultyLevels
  LEFT JOIN InstructionModes
  LEFT JOIN Prerequisites (grouped)
```

**Prerequisites Query**:
```
Prerequisites
  JOIN Courses (course_side)
  JOIN Courses (prerequisite_side)
```

---

## 9. Workflow Configuration

### Environment Setup

**Required Files**:
- `.claude/commands/student-eval-analysis.md` - Main workflow definition
- `.claude/agents/profile_analyzer_agent.md` - Agent 1 specification
- `.claude/agents/course_matcher_agent.md` - Agent 2 specification
- `.claude/agents/recommendation_builder_agent.md` - Agent 3 specification
- `src/orchestration/database_queries.py` - Database query tool
- `sqlite_database.db` - SQLite database (must exist and be populated)

**Expected Directories**:
- `reports/` - Output directory for HTML reports (created if missing)
- `.claude/` - Configuration directory (must exist)

**Python Dependencies**:
- `sqlite3` (built-in)
- `json` (built-in)
- `sys` (built-in)
- `datetime` (built-in)

### Execution Command

```bash
# Run the orchestrator via Claude AI
python src/orchestration/database_queries.py [student_id]
```

Then invoke in Claude:
```
Please run student-eval-analysis.md file found in .claude/commands/ for student [ID] who has interests in [INTERESTS]
```

---

## 10. Performance & Scalability

### Query Performance

- **Student Profile Query**: O(1) - Single student lookup via primary key
- **Academic History Query**: O(n) - Linear in number of completed courses
- **Available Courses Query**: O(m) - Linear in total courses
- **Prerequisites Query**: O(p) - Linear in prerequisite relationships

Typical execution:
- DB queries: <1 second (for ~300 courses, ~500 students)
- Agent processing: 5-15 seconds (Claude API latency)
- Report generation: <1 second
- Total workflow: 10-20 seconds

### Scalability Considerations

- Database indexes on StudentID, CourseCode, DepartmentID
- Prerequisite map loaded entirely into memory (OK for <5000 prerequisites)
- JSON outputs kept in memory (OK for <500 courses)
- Batch processing not implemented (single student at a time)

### Future Optimization Opportunities

- Implement caching for frequently accessed courses
- Batch process multiple students in parallel
- Async agent invocations instead of sequential
- Stream large reports to browser instead of file storage

---

## 11. Architecture Decisions & Rationale

| Decision | Rationale | Trade-offs |
|----------|-----------|-----------|
| **JSON-only Agent Output** | Ensures structured, parseable results | Less human-readable intermediate outputs |
| **Three-Agent Pipeline** | Separation of concerns; each agent specialized | More complex orchestration |
| **SQLite for Data** | Lightweight, single-file database | Not suitable for concurrent writes |
| **HTML Report Output** | Human-readable, shareable, print-friendly | Not machine-parseable |
| **Parameterized Queries** | SQL injection prevention | Slightly less flexible queries |
| **Synchronous Workflow** | Simpler error handling and ordering | Slower than async (can be optimized) |

---

## 12. Extensibility & Future Enhancements

### Potential Extensions

1. **Additional Agents**:
   - Career Path Analyzer (recommend 4-year course sequences)
   - Study Group Recommender (match students with similar interests)
   - Prerequisite Planner (optimize sequence of prerequisites)

2. **Enhanced Data Sources**:
   - Faculty research interests (match to student goals)
   - Alumni career outcomes (show which courses led to jobs)
   - Course reviews/ratings from students

3. **User Interface**:
   - Web dashboard for recommendations
   - Real-time report generation UI
   - Student preferences/filtering interface

4. **ML Enhancements**:
   - Predictive GPA improvement based on course selection
   - Personalized difficulty recommendations via ML
   - Course recommendation ranking via learned weights

5. **Integration Points**:
   - MCP servers for additional tools
   - External APIs for career data
   - LMS integration for real-time enrollment data

---

## 13. Troubleshooting Guide

| Issue | Cause | Resolution |
|-------|-------|-----------|
| Agent outputs invalid JSON | JSON-only requirement violated | Check agent output format strictly |
| Missing course data | `Status` != 'Active' | Verify courses marked as 'Active' in database |
| Prerequisite mismatch | Course removed from curriculum | Update prerequisites table and course status |
| Report not generated | `reports/` directory missing | Create reports/ directory |
| Database query fails | `sqlite_database.db` not in project root | Verify database path in `database_queries.py` |
| Student not found | Incorrect StudentID | Verify student exists: `SELECT * FROM Students WHERE StudentID = ?` |

---

## 14. Workflow Evolution Timeline

**Current Version**: 1.0 (Dec 2025)
- Three-agent architecture
- SQLite backend
- HTML report generation
- JSON communication protocol

**Roadmap**:
- v1.1: Add caching for repeated student queries
- v1.2: Support batch student processing
- v2.0: Web UI for recommendation dashboard
- v2.1: ML-based weight optimization
- v3.0: Multi-semester planning agent

---

## Summary

The Student Course Recommendation System is a sophisticated **three-agent orchestration pipeline** that transforms raw academic data into personalized, actionable course recommendations. By separating concerns (profile analysis, course matching, recommendation building), the system achieves both modularity and accuracy. The strict JSON communication protocol ensures reliable agent interaction, while the SQLite backend provides scalable data storage. Future enhancements can easily extend the agent roster or integrate additional data sources without disrupting core workflow.
