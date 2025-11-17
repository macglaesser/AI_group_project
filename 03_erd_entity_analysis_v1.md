# Entity-Relationship Diagram (ERD) Analysis
## Academic Course Assistant System
### Cox School of Business

**Document Version:** 1.0  
**Date Created:** November 17, 2025  
**Purpose:** Identify all entities and relationships for database design

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Core Entities](#2-core-entities)
3. [Supporting Entities](#3-supporting-entities)
4. [Reference/Lookup Entities](#4-referencelookup-entities)
5. [Audit & System Entities](#5-audit--system-entities)
6. [Entity Relationships](#6-entity-relationships)
7. [Relationship Matrix](#7-relationship-matrix)
8. [Proposed ERD Structure](#8-proposed-erd-structure)
9. [Data Types and Constraints](#9-data-types-and-constraints)
10. [Indexing Strategy](#10-indexing-strategy)

---

## 1. Executive Summary

Based on comprehensive analysis of the Functional Requirements Document (01_functional_requirements_v1.md) and Product Requirements Document (02_product_requirements_document_v1.md), this document identifies **17 core entities** organized into four categories:

- **Core Domain Entities (6):** Courses, Prerequisites, Schedules, Students, Academic History, Student Preferences
- **Supporting Feature Entities (6):** Recommendations, Recommendation History, Waivers, Waiver History, AI Agent Logs, Schedule History
- **Reference/Lookup Entities (3):** Departments, Difficulty Levels, Instruction Modes
- **Audit & System Entities (2):** Audit Log, System Configuration

This ERD will support all functional requirements including course discovery, prerequisite validation, personalized recommendations, and schedule optimization through AI agents.

---

## 2. Core Entities

Core entities represent the primary business objects central to the system's functionality.

### 2.1 Courses Entity

**Purpose:** Store comprehensive course information for discovery and planning

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| CourseID | INT | PRIMARY KEY, Auto-increment | Unique course identifier |
| CourseCode | VARCHAR(20) | UNIQUE, NOT NULL | e.g., BUSI 3301 |
| CourseName | VARCHAR(255) | NOT NULL | Full course title |
| Description | TEXT | NOT NULL | Detailed course overview |
| CreditHours | DECIMAL(3,1) | NOT NULL, >0 | Semester credits |
| DepartmentID | INT | FOREIGN KEY, NOT NULL | References Departments |
| DifficultyLevelID | INT | FOREIGN KEY, NOT NULL | References Difficulty Levels |
| Status | ENUM | NOT NULL, DEFAULT 'Active' | Active, Inactive, Archived |
| MaxEnrollment | INT | >=0 | Maximum students allowed |
| InstructionModeID | INT | FOREIGN KEY, NOT NULL | References Instruction Modes |
| SyllabusURL | VARCHAR(255) | NULL | Link to syllabus |
| LearningOutcomes | TEXT | NULL | Course learning objectives |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** CourseID  
**Unique Constraints:** CourseCode (unique per term)  
**Relationships:** 
- One-to-Many with Schedules
- Many-to-Many with Prerequisites (self-referencing)
- Many-to-Many with Departments (cross-listed)
- One-to-Many with Recommendations

**Notes:**
- Must support multiple sections per semester
- Course code may repeat across terms but should be unique within a term
- Description feeds into Course Analysis Agent

---

### 2.2 Prerequisites Entity

**Purpose:** Store prerequisite relationships between courses and validation rules

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| PrerequisiteID | INT | PRIMARY KEY, Auto-increment | Unique prerequisite relationship ID |
| CourseID | INT | FOREIGN KEY, NOT NULL | Course requiring prerequisite |
| PrerequisiteCourseID | INT | FOREIGN KEY, NOT NULL | Required prerequisite course |
| MinimumGrade | VARCHAR(5) | NOT NULL | e.g., C, B-, B, B+ |
| PrerequisiteType | ENUM | NOT NULL | Hard, Recommended, Co-requisite |
| EffectiveTerm | VARCHAR(20) | NOT NULL | Term this prerequisite applies (e.g., Fall2025) |
| Notes | TEXT | NULL | Additional context |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** PrerequisiteID  
**Composite Unique:** (CourseID, PrerequisiteCourseID, EffectiveTerm)  
**Relationships:**
- Many-to-One with Courses (course requiring prerequisite)
- Many-to-One with Courses (prerequisite course) - self-referencing
- One-to-Many with Waiver History

**Notes:**
- Supports prerequisite chains (A requires B, B requires C)
- Supports alternative paths (A requires B OR C)
- Prerequisite Validation Agent queries this heavily
- EffectiveTerm tracks when prerequisites change

---

### 2.3 Schedules Entity

**Purpose:** Store course section information and enrollment details

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| ScheduleID | INT | PRIMARY KEY, Auto-increment | Unique schedule/section ID |
| CourseID | INT | FOREIGN KEY, NOT NULL | References Courses |
| Semester | VARCHAR(20) | NOT NULL | e.g., Fall2025, Spring2026 |
| SectionNumber | VARCHAR(10) | NOT NULL | Section identifier (01, 02, etc.) |
| ProfessorID | INT | FOREIGN KEY, NULL | References Faculty (future) |
| ProfessorName | VARCHAR(255) | NOT NULL | Instructor name (for Phase 1) |
| MeetingDays | VARCHAR(20) | NOT NULL | MWF, TR, Online, etc. |
| StartTime | TIME | NOT NULL | Course start time |
| EndTime | TIME | NOT NULL | Course end time |
| Location | VARCHAR(255) | NULL | Building/Room or "Online" |
| InstructionModeID | INT | FOREIGN KEY, NOT NULL | In-Person, Online, Hybrid |
| EnrollmentStatus | ENUM | NOT NULL | Open, Full, Closed, Waitlist |
| CurrentEnrollment | INT | DEFAULT 0, >=0 | Current student count |
| WaitListCount | INT | DEFAULT 0, >=0 | Students on wait list |
| MaxCapacity | INT | NOT NULL, >0 | Maximum enrollment |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** ScheduleID  
**Composite Unique:** (CourseID, Semester, SectionNumber)  
**Relationships:**
- Many-to-One with Courses
- One-to-Many with Recommendations (for schedule suggestions)
- One-to-Many with Schedule History (audit trail)

**Notes:**
- Multiple sections per course per semester
- Enrollment status computed from current enrollment vs. capacity
- Time-based conflict detection relies on StartTime/EndTime
- Schedule Optimization Agent uses this data heavily

---

### 2.4 Students Entity

**Purpose:** Store student profile and academic standing information

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| StudentID | INT | PRIMARY KEY | Primary key (could match SIS ID) |
| FirstName | VARCHAR(100) | NOT NULL | Student first name |
| LastName | VARCHAR(100) | NOT NULL | Student last name |
| Email | VARCHAR(255) | UNIQUE, NOT NULL | Institutional email |
| MajorID | INT | FOREIGN KEY, NOT NULL | References Departments (primary major) |
| ConcentrationID | INT | FOREIGN KEY, NULL | References Departments (concentration/track) |
| GraduationTargetDate | DATE | NULL | Expected graduation date |
| AcademicStanding | ENUM | NOT NULL | Good Standing, Probation, Suspended |
| CumulativeGPA | DECIMAL(3,2) | DEFAULT 0.0, BETWEEN 0-4 | Current GPA |
| TotalCreditsEarned | DECIMAL(5,1) | DEFAULT 0 | Cumulative credits completed |
| ClassificationID | INT | FOREIGN KEY, NOT NULL | Freshman, Sophomore, Junior, Senior |
| SISImportDate | TIMESTAMP | NULL | Last SIS data sync |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** StudentID  
**Unique Constraints:** Email  
**Relationships:**
- One-to-Many with Academic History
- One-to-Many with Student Preferences
- One-to-Many with Recommendations
- One-to-Many with Waivers
- Many-to-One with Departments (major and concentration)
- Many-to-One with Classification

**Notes:**
- StudentID should sync with SIS
- GPA calculated from Academic History but denormalized for performance
- SISImportDate tracks when student data was last updated from SIS
- Classification (year level) can be computed or stored

---

### 2.5 Academic History Entity

**Purpose:** Track student course completion and performance

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| HistoryID | INT | PRIMARY KEY, Auto-increment | Unique history record ID |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students |
| CourseID | INT | FOREIGN KEY, NOT NULL | References Courses |
| ScheduleID | INT | FOREIGN KEY, NULL | References Schedules (which section) |
| Grade | VARCHAR(5) | NOT NULL | A, A-, B+, B, B-, C, D, F |
| GradePoints | DECIMAL(3,2) | NOT NULL, BETWEEN 0-4 | Numeric grade equivalent |
| TermCompleted | VARCHAR(20) | NOT NULL | Semester course was taken |
| CreditHoursEarned | DECIMAL(3,1) | NOT NULL | Credits toward degree |
| PassFail | BOOLEAN | DEFAULT FALSE | P/F grading if applicable |
| CompletionDate | DATE | NOT NULL | Date grade posted |
| GradePointsContribution | DECIMAL(5,2) | COMPUTED | (GradePoints × CreditHours) |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** HistoryID  
**Composite Unique:** (StudentID, CourseID, TermCompleted)  
**Relationships:**
- Many-to-One with Students
- Many-to-One with Courses
- Many-to-One with Schedules

**Notes:**
- Critical for prerequisite validation (Prerequisite Validation Agent queries this)
- Grade conversion critical for GPA calculation
- Supports Pass/Fail courses (may not contribute to GPA)
- TermCompleted allows taking same course multiple times
- One entry per course completion

---

### 2.6 Student Preferences Entity

**Purpose:** Store student goals, interests, and schedule constraints

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| PreferenceID | INT | PRIMARY KEY, Auto-increment | Unique preference record ID |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students (one per student) |
| AcademicGoals | TEXT | NULL | Student's academic objectives |
| CareerInterests | VARCHAR(500) | NULL | Comma-separated or JSON array |
| PreferredInstructionModeID | INT | FOREIGN KEY, NULL | References Instruction Modes |
| PreferredStartTime | TIME | NULL | Earliest preferred class start |
| PreferredEndTime | TIME | NULL | Latest preferred class end |
| PreferredDaysAvailable | VARCHAR(20) | NULL | MWF, TR, etc. - days available |
| PreferredDaysUnavailable | VARCHAR(20) | NULL | Days to avoid |
| DifficultyPreference | VARCHAR(50) | NULL | Introductory, Intermediate, Advanced |
| WorkloadPreference | ENUM | NULL | Light, Moderate, Heavy |
| PreferredDepartments | VARCHAR(500) | NULL | Comma-separated department preferences |
| NotificationPreferences | JSON | NULL | Email, SMS, In-app notification settings |
| ProfileCompleteness | DECIMAL(3,0) | COMPUTED | % of profile filled out |
| LastUpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Profile last modified |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** PreferenceID  
**Unique Constraints:** StudentID (one preference record per student)  
**Relationships:**
- Many-to-One with Students

**Notes:**
- Captures user preferences for recommendation personalization
- Recommendation Engine Agent uses this extensively
- Schedule Optimization Agent considers schedule constraints
- CareerInterests and PreferredDepartments could be normalized into separate tables
- JSON column for flexibility in preferences
- Supports profile completion tracking for onboarding

---

## 3. Supporting Feature Entities

Supporting entities track recommendations, waivers, and AI agent activity.

### 3.1 Recommendations Entity

**Purpose:** Store AI-generated course recommendations with rationale

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| RecommendationID | INT | PRIMARY KEY, Auto-increment | Unique recommendation ID |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students |
| CourseID | INT | FOREIGN KEY, NOT NULL | References Courses |
| ScheduleID | INT | FOREIGN KEY, NULL | References Schedules (specific section) |
| Rank | INT | NOT NULL, >0 | Recommendation ranking (1=highest) |
| RelevanceScore | DECIMAL(3,2) | NOT NULL, BETWEEN 0-1 | Confidence score |
| RecommendationReason | TEXT | NOT NULL | Why this course recommended |
| AlignmentWithGoals | VARCHAR(255) | NULL | How course aligns with stated goals |
| SkillDevelopment | TEXT | NULL | Skills developed by course |
| CareerRelevance | VARCHAR(255) | NULL | How relevant to career interests |
| PrerequisiteStatus | ENUM | NOT NULL | Met, Missing, Waiver_Pending, Alternative_Available |
| SuggestedPrerequisites | VARCHAR(500) | NULL | Comma-separated prerequisite courses to take first |
| AgentID | INT | FOREIGN KEY, NOT NULL | Which AI agent generated (References AI_Agent_Logs) |
| GeneratedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When recommendation generated |
| ExpiryDate | DATE | NULL | Recommendation valid until date |
| UserFeedback | ENUM | NULL | Helpful, Not_Helpful, Ignored |
| UserFeedbackDate | TIMESTAMP | NULL | When user provided feedback |
| IsActive | BOOLEAN | DEFAULT TRUE | Whether recommendation still valid |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** RecommendationID  
**Relationships:**
- Many-to-One with Students
- Many-to-One with Courses
- Many-to-One with Schedules
- Many-to-One with AI_Agent_Logs

**Notes:**
- Generated by Recommendation Engine Agent
- Includes explanation for transparency (addresses PRD requirement)
- RelevanceScore computed by agent algorithm
- Feedback loop for recommendation improvement
- Can reference specific schedule (section) or just course

---

### 3.2 Waivers Entity

**Purpose:** Track prerequisite waiver requests and approvals

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| WaiverID | INT | PRIMARY KEY, Auto-increment | Unique waiver ID |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students |
| PrerequisiteID | INT | FOREIGN KEY, NOT NULL | References Prerequisites |
| CourseID | INT | FOREIGN KEY, NOT NULL | References Courses (course needing waiver) |
| WaiverReason | TEXT | NOT NULL | Reason for waiver request |
| SupportingDocumentation | VARCHAR(255) | NULL | Path to uploaded file |
| RequestDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When requested |
| Status | ENUM | NOT NULL | Pending, Approved, Denied, Withdrawn |
| ApprovalDate | TIMESTAMP | NULL | When decision made |
| ApprovedByID | INT | FOREIGN KEY, NULL | Faculty member who approved (future) |
| ApprovedByName | VARCHAR(255) | NULL | Approver name for Phase 1 |
| ApprovalReason | TEXT | NULL | Reason for approval/denial |
| ExpiryDate | DATE | NULL | When waiver expires |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |
| UpdatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update date |

**Primary Key:** WaiverID  
**Composite Unique:** (StudentID, CourseID, PrerequisiteID) - one waiver request per combination  
**Relationships:**
- Many-to-One with Students
- Many-to-One with Prerequisites
- Many-to-One with Courses

**Notes:**
- Workflow: Pending → Approved/Denied
- Supports appeals process implicitly (new waiver request)
- ExpiryDate allows one-time waivers
- Prerequisite Validation Agent must check waiver status

---

### 3.3 AI Agent Logs Entity

**Purpose:** Track AI agent execution for debugging and audit

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| LogID | INT | PRIMARY KEY, Auto-increment | Unique log ID |
| AgentName | VARCHAR(100) | NOT NULL | Agent type (RecommendationEngine, PrerequisiteValidator, etc.) |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students (who triggered agent) |
| ExecutionStartTime | TIMESTAMP | NOT NULL | When agent started |
| ExecutionEndTime | TIMESTAMP | NOT NULL | When agent completed |
| ExecutionDurationMS | INT | NOT NULL | Duration in milliseconds |
| InputParameters | JSON | NOT NULL | Serialized input data |
| OutputData | JSON | NOT NULL | Serialized results |
| ErrorMessage | TEXT | NULL | If execution failed |
| ExecutionStatus | ENUM | NOT NULL | Success, Error, Partial_Error |
| RecommendationCount | INT | NULL | For recommendation agent only |
| QueryCount | INT | NULL | Number of database queries |
| AIModelUsed | VARCHAR(100) | NULL | e.g., gpt-4, gpt-3.5-turbo |
| TokensUsed | INT | NULL | LLM tokens consumed |
| CostUSD | DECIMAL(8,4) | NULL | API cost if tracked |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** LogID  
**Relationships:**
- Many-to-One with Students

**Notes:**
- Critical for monitoring AI agent performance
- InputParameters and OutputData as JSON for flexibility
- Tracks performance metrics (duration, query count)
- Cost tracking for API usage
- ExecutionDurationMS important for meeting SLA (<5 seconds for recommendations)

---

### 3.4 Recommendation History Entity

**Purpose:** Audit trail for recommendation changes

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| HistoryID | INT | PRIMARY KEY, Auto-increment | Unique history record ID |
| RecommendationID | INT | FOREIGN KEY, NOT NULL | References Recommendations |
| StudentID | INT | FOREIGN KEY, NOT NULL | References Students |
| Action | ENUM | NOT NULL | Created, Updated, Accepted, Rejected, Expired |
| OldValues | JSON | NULL | Previous values before change |
| NewValues | JSON | NULL | New values after change |
| ChangeReason | VARCHAR(255) | NULL | Why change occurred |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When change happened |

**Primary Key:** HistoryID  
**Relationships:**
- Many-to-One with Recommendations
- Many-to-One with Students

**Notes:**
- Tracks recommendation lifecycle
- Supports compliance/audit requirements
- Can analyze why recommendations changed

---

### 3.5 Schedule History Entity

**Purpose:** Audit trail for schedule section changes

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| HistoryID | INT | PRIMARY KEY, Auto-increment | Unique history record ID |
| ScheduleID | INT | FOREIGN KEY, NOT NULL | References Schedules |
| Action | ENUM | NOT NULL | Created, Updated, Deleted, Enrollment_Changed |
| OldValues | JSON | NULL | Previous schedule values |
| NewValues | JSON | NULL | Updated schedule values |
| ChangeReason | VARCHAR(255) | NULL | Why changed |
| ChangedByID | INT | FOREIGN KEY, NULL | User who made change |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When change happened |

**Primary Key:** HistoryID  
**Relationships:**
- Many-to-One with Schedules

**Notes:**
- Tracks enrollment status changes, time changes, etc.
- Helps detect issues with schedules
- Supports rollback analysis

---

### 3.6 Waiver History Entity

**Purpose:** Audit trail for waiver status changes

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| HistoryID | INT | PRIMARY KEY, Auto-increment | Unique history record ID |
| WaiverID | INT | FOREIGN KEY, NOT NULL | References Waivers |
| StatusChange | VARCHAR(50) | NOT NULL | e.g., Pending→Approved |
| PreviousStatus | ENUM | NOT NULL | Prior status |
| NewStatus | ENUM | NOT NULL | Current status |
| ChangeReason | VARCHAR(255) | NULL | Why status changed |
| ChangedByID | INT | FOREIGN KEY, NULL | User/admin who made change |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When change happened |

**Primary Key:** HistoryID  
**Relationships:**
- Many-to-One with Waivers

**Notes:**
- Tracks waiver workflow
- Supports compliance tracking

---

## 4. Reference/Lookup Entities

Reference entities provide standardized lookup values.

### 4.1 Departments Entity

**Purpose:** Store business school department/concentration definitions

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| DepartmentID | INT | PRIMARY KEY, Auto-increment | Unique department ID |
| DepartmentCode | VARCHAR(20) | UNIQUE, NOT NULL | e.g., BUSI, ACCT, FINC |
| DepartmentName | VARCHAR(100) | NOT NULL | e.g., Finance, Marketing, Accounting |
| Description | TEXT | NULL | Department description |
| DepartmentType | ENUM | NOT NULL | Major, Concentration, Support |
| IsActive | BOOLEAN | DEFAULT TRUE | Active or archived |
| DepartmentChairID | INT | FOREIGN KEY, NULL | Department chair (future) |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** DepartmentID  
**Unique Constraints:** DepartmentCode  
**Relationships:**
- One-to-Many with Courses
- One-to-Many with Students (as major or concentration)

**Notes:**
- Supports multiple business school departments
- Future: Could expand to include department head contact info
- DepartmentType distinguishes between majors and concentrations

---

### 4.2 Difficulty Levels Entity

**Purpose:** Define course difficulty classifications

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| DifficultyLevelID | INT | PRIMARY KEY, Auto-increment | Unique ID |
| LevelCode | VARCHAR(20) | UNIQUE, NOT NULL | e.g., INTRO, INTER, ADV |
| LevelName | VARCHAR(50) | NOT NULL | Introductory, Intermediate, Advanced |
| Description | TEXT | NULL | Level description |
| DisplayOrder | INT | NOT NULL | Sort order for UI |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** DifficultyLevelID  
**Unique Constraints:** LevelCode  
**Relationships:**
- One-to-Many with Courses

**Notes:**
- Static lookup table
- Display order for UI sorting
- Used by Schedule Optimization Agent for workload analysis

---

### 4.3 Instruction Modes Entity

**Purpose:** Define course delivery methods

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| InstructionModeID | INT | PRIMARY KEY, Auto-increment | Unique ID |
| ModeCode | VARCHAR(20) | UNIQUE, NOT NULL | e.g., IP, ONL, HYB |
| ModeName | VARCHAR(50) | NOT NULL | In-Person, Online, Hybrid |
| Description | TEXT | NULL | Mode description |
| DisplayOrder | INT | NOT NULL | Sort order for UI |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** InstructionModeID  
**Unique Constraints:** ModeCode  
**Relationships:**
- One-to-Many with Courses
- One-to-Many with Schedules
- One-to-Many with Student Preferences

**Notes:**
- Lookup table for filtering in UI
- Used in recommendation and schedule filtering

---

### 4.4 Classification Entity (Implicit)

**Purpose:** Define student year classifications

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| ClassificationID | INT | PRIMARY KEY, Auto-increment | Unique ID |
| ClassificationCode | VARCHAR(20) | UNIQUE, NOT NULL | FR, SO, JR, SR |
| ClassificationName | VARCHAR(50) | NOT NULL | Freshman, Sophomore, Junior, Senior |
| MinCreditsRequired | INT | NOT NULL | Minimum credits for classification |
| MaxCreditsRequired | INT | NOT NULL | Maximum credits for classification |
| DisplayOrder | INT | NOT NULL | Sort order |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation date |

**Primary Key:** ClassificationID  
**Relationships:**
- One-to-Many with Students

**Notes:**
- Optional; could be computed from credits
- Included for clarity and flexibility

---

## 5. Audit & System Entities

### 5.1 Audit Log Entity

**Purpose:** Track all system changes for compliance and security

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| AuditID | INT | PRIMARY KEY, Auto-increment | Unique audit record ID |
| EntityType | VARCHAR(100) | NOT NULL | Table/entity modified |
| EntityID | INT | NOT NULL | ID of modified record |
| Action | ENUM | NOT NULL | Create, Read, Update, Delete |
| UserID | INT | FOREIGN KEY, NULL | Student/admin who made change |
| UserType | VARCHAR(50) | NOT NULL | Student, Advisor, Admin |
| OldValues | JSON | NULL | Values before change |
| NewValues | JSON | NULL | Values after change |
| IPAddress | VARCHAR(45) | NULL | User's IP address |
| UserAgent | VARCHAR(500) | NULL | Browser information |
| CreatedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When action occurred |

**Primary Key:** AuditID  
**Relationships:** None (reference only)

**Notes:**
- FERPA compliance requirement
- Tracks data access for privacy
- Supports forensic analysis

---

### 5.2 System Configuration Entity

**Purpose:** Store system-wide configuration parameters

**Attributes:**
| Attribute | Data Type | Constraints | Notes |
|-----------|-----------|-------------|-------|
| ConfigID | INT | PRIMARY KEY, Auto-increment | Unique config ID |
| ConfigKey | VARCHAR(100) | UNIQUE, NOT NULL | e.g., MAX_CONCURRENT_USERS |
| ConfigValue | VARCHAR(1000) | NOT NULL | Configuration value |
| ConfigType | VARCHAR(50) | NOT NULL | Integer, String, Boolean, JSON |
| Description | TEXT | NULL | What this config controls |
| IsActive | BOOLEAN | DEFAULT TRUE | Whether config is applied |
| LastModifiedDate | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | When modified |

**Primary Key:** ConfigID  
**Unique Constraints:** ConfigKey  
**Relationships:** None

**Notes:**
- Allows runtime configuration without code changes
- Examples: Max recommendation count, recommendation expiry days, max workload credits
- Could store AI model parameters, API endpoints, etc.

---

## 6. Entity Relationships

### 6.1 Relationship Types

#### One-to-Many Relationships
1. **Departments → Courses** - One department, many courses
2. **Courses → Schedules** - One course, many section schedules
3. **Courses → Academic History** - One course, many student enrollments
4. **Students → Academic History** - One student, many course completions
5. **Students → Recommendations** - One student, many recommendations
6. **Students → Student Preferences** - One student, one preferences record (treated as 1:1)
7. **Students → Waivers** - One student, many waiver requests
8. **Departments → Students** - One department (major), many students

#### Many-to-Many Relationships
1. **Courses ↔ Prerequisites** - Self-referencing (course A requires course B)
2. **Courses ↔ Departments** - Cross-listed courses (for future)
3. **Departments → Students** - Student can have major and concentration

#### Many-to-One Relationships (reverse of above)
- All the typical foreign key relationships

#### Recursive Relationships
1. **Prerequisites (self)** - Course prerequisites course
2. **Students** - Classification based on credits (implicit)

---

### 6.2 Relationship Cardinality Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ COURSES (1)  ──────────── (M)  SCHEDULES                    │
│    │                                                         │
│    │ (M)                                                     │
│    ├─→ PREREQUISITES (self-referencing)                      │
│    │                                                         │
│    └─→ ACADEMIC_HISTORY (M)                                  │
│         │                                                    │
│         └─→ STUDENTS (1)                                     │
│              │                                               │
│              ├─→ STUDENT_PREFERENCES (1:1)                   │
│              ├─→ RECOMMENDATIONS (M)                         │
│              ├─→ WAIVERS (M)                                 │
│              └─→ DEPARTMENTS (1) - Major                     │
│                                                              │
├─ DEPARTMENTS ──→ COURSES (1:M)                               │
│    │                                                         │
│    └─→ STUDENTS (1:M) - as Major or Concentration            │
│                                                              │
├─ DIFFICULTY_LEVELS ──→ COURSES (1:M)                         │
│                                                              │
├─ INSTRUCTION_MODES ──→ COURSES (1:M)                         │
│    │                                                         │
│    └─→ SCHEDULES (1:M)                                       │
│         │                                                    │
│         └─→ SCHEDULE_HISTORY (M)                             │
│                                                              │
├─ RECOMMENDATIONS ──→ COURSES (M:1)                           │
│    │                                                         │
│    ├─→ SCHEDULES (M:1)                                       │
│    ├─→ AI_AGENT_LOGS (M:1)                                   │
│    └─→ RECOMMENDATION_HISTORY (M)                            │
│                                                              │
├─ WAIVERS ──→ PREREQUISITES (M:1)                             │
│    │                                                         │
│    └─→ WAIVER_HISTORY (M)                                    │
│                                                              │
├─ AI_AGENT_LOGS ──→ STUDENTS (M:1)                            │
│                                                              │
└─ AUDIT_LOG (independent tracking)                            │

Legend: (1) = One, (M) = Many, ──→ = References, (1:1) = One-to-One
```

---

## 7. Relationship Matrix

Comprehensive matrix showing all entity relationships:

| From Entity | To Entity | Type | Cardinality | Foreign Key | Notes |
|-------------|-----------|------|-------------|-------------|-------|
| Courses | Departments | FK | M:1 | DepartmentID | Course belongs to department |
| Courses | Difficulty_Levels | FK | M:1 | DifficultyLevelID | Course has difficulty |
| Courses | Instruction_Modes | FK | M:1 | InstructionModeID | Course delivery mode |
| Courses | Schedules | Parent | 1:M | CourseID | One course, many sections |
| Courses | Academic_History | Parent | 1:M | CourseID | Course taken by students |
| Courses | Prerequisites | Self | M:M | CourseID + PrerequisiteCourseID | Prerequisite chains |
| Courses | Recommendations | Parent | 1:M | CourseID | Recommended course |
| Schedules | Courses | FK | M:1 | CourseID | Schedule section of course |
| Schedules | Instruction_Modes | FK | M:1 | InstructionModeID | Schedule delivery mode |
| Schedules | Recommendations | Child | 1:M | ScheduleID | Specific section recommended |
| Schedules | Schedule_History | Parent | 1:M | ScheduleID | Audit trail |
| Students | Departments | FK | M:1 | MajorID | Primary major |
| Students | Departments | FK | M:1 | ConcentrationID | Concentration focus |
| Students | Classification | FK | M:1 | ClassificationID | Year level |
| Students | Academic_History | Parent | 1:M | StudentID | Student's course history |
| Students | Student_Preferences | Parent | 1:1 | StudentID | Student's preferences |
| Students | Recommendations | Parent | 1:M | StudentID | Student's recommendations |
| Students | Waivers | Parent | 1:M | StudentID | Student's waiver requests |
| Students | AI_Agent_Logs | Parent | 1:M | StudentID | Agent activity for student |
| Academic_History | Courses | FK | M:1 | CourseID | Course taken |
| Academic_History | Students | FK | M:1 | StudentID | Student enrollment |
| Academic_History | Schedules | FK | M:1 | ScheduleID | Which section taken |
| Prerequisites | Courses | FK | M:1 | CourseID | Course requiring prerequisite |
| Prerequisites | Courses | FK | M:1 | PrerequisiteCourseID | Required course |
| Prerequisites | Waivers | Parent | 1:M | PrerequisiteID | Waiver requests |
| Student_Preferences | Students | FK | 1:1 | StudentID | Preference record |
| Recommendations | Students | FK | M:1 | StudentID | Student receiving rec |
| Recommendations | Courses | FK | M:1 | CourseID | Course recommended |
| Recommendations | Schedules | FK | M:1 | ScheduleID | Specific section |
| Recommendations | AI_Agent_Logs | FK | M:1 | LogID | Agent that generated |
| Recommendations | Recommendation_History | Parent | 1:M | RecommendationID | Audit trail |
| Waivers | Students | FK | M:1 | StudentID | Student requesting waiver |
| Waivers | Prerequisites | FK | M:1 | PrerequisiteID | Prerequisite being waived |
| Waivers | Courses | FK | M:1 | CourseID | Course needing waiver |
| Waivers | Waiver_History | Parent | 1:M | WaiverID | Audit trail |
| AI_Agent_Logs | Students | FK | M:1 | StudentID | Student triggering agent |
| Recommendation_History | Recommendations | FK | M:1 | RecommendationID | Recommendation changed |
| Schedule_History | Schedules | FK | M:1 | ScheduleID | Schedule changed |
| Waiver_History | Waivers | FK | M:1 | WaiverID | Waiver status changed |

---

## 8. Proposed ERD Structure

### 8.1 ER Diagram Text Representation

```
╔════════════════════════════════════════════════════════════════════════╗
║                       ACADEMIC COURSE ASSISTANT                        ║
║                    Entity-Relationship Diagram (ERD)                   ║
║                         Cox School of Business                         ║
╚════════════════════════════════════════════════════════════════════════╝

┌──────────────────────┐
│   DEPARTMENTS        │
├──────────────────────┤
│ DepartmentID (PK)    │
│ DepartmentCode       │◄─────┐
│ DepartmentName       │      │ (1:M)
│ Description          │      │
│ DepartmentType       │      │
│ IsActive             │      │
└──────────────────────┘      │
         △                     │
         │                     │
    (1:M)│                     │
         │                  ┌──┴────────────────────┐
         │                  │   COURSES             │
         │                  ├───────────────────────┤
         │                  │ CourseID (PK)         │
         │                  │ CourseCode            │
         │                  │ CourseName            │
         │                  │ Description           │
         │                  │ CreditHours           │
         │                  │ DepartmentID (FK)────►│
         │                  │ DifficultyLevelID(FK)─┐
         │                  │ Status                │
         │                  │ MaxEnrollment         │
         │                  │ InstructionModeID(FK)─┐
         │                  │ SyllabusURL           │
         │                  └───▲───────────┬───────┘
         │                      │           │
         │                      │      (1:M)│
         │                      │           │
         │              (1:M)   │           │
         │              ┌───────┴───────────┤
         │              │              ┌────▼──────────────┐
         │              │              │   SCHEDULES       │
         │              │              ├───────────────────┤
         │              │              │ ScheduleID (PK)   │
         │              │              │ CourseID (FK)────►│
         │              │              │ Semester          │
         │              │              │ SectionNumber     │
         │              │              │ ProfessorName     │
         │              │              │ MeetingDays       │
         │              │              │ StartTime         │
         │              │              │ EndTime           │
         │              │              │ Location          │
         │              │              │ InstructionModeID │
         │              │              │ EnrollmentStatus  │
         │              │              └──────────────────┘
         │              │
         │              └─ (Self-Reference)
         │
         ├─ PREREQUISITES
         │  ├─ PrerequisiteID (PK)
         │  ├─ CourseID (FK) ──────────┘
         │  ├─ PrerequisiteCourseID (FK) ──────┘
         │  ├─ MinimumGrade
         │  ├─ PrerequisiteType
         │  └─ EffectiveTerm
         │
         ├─ ACADEMIC_HISTORY
         │  ├─ HistoryID (PK)
         │  ├─ StudentID (FK) ────────►(to STUDENTS)
         │  ├─ CourseID (FK) ────────┘
         │  ├─ ScheduleID (FK) ──────┘
         │  ├─ Grade
         │  ├─ GradePoints
         │  ├─ TermCompleted
         │  └─ CreditHoursEarned
         │
         └─ RECOMMENDATIONS
            ├─ RecommendationID (PK)
            ├─ StudentID (FK) ─────┐
            ├─ CourseID (FK) ────┐ │
            ├─ ScheduleID (FK)──┐ │ │
            ├─ Rank             │ │ │
            ├─ RelevanceScore   │ │ │
            ├─ RecommendationReason
            └─ AgentID ─────────►(to AI_AGENT_LOGS)

┌──────────────────────┐      ┌────────────────────────┐
│   STUDENTS           │      │  STUDENT_PREFERENCES   │
├──────────────────────┤      ├────────────────────────┤
│ StudentID (PK)       │◄─────│ PreferenceID (PK)      │
│ FirstName            │ (1:1)│ StudentID (FK)         │
│ LastName             │      │ AcademicGoals          │
│ Email                │      │ CareerInterests        │
│ MajorID (FK)         │      │ PreferredInstructionID │
│ ConcentrationID(FK)  │      │ PreferredStartTime     │
│ GraduationTargetDate │      │ PreferredEndTime       │
│ AcademicStanding     │      │ PreferredDaysAvailable │
│ CumulativeGPA        │      │ PreferredDaysUnavailable
│ TotalCreditsEarned   │      │ DifficultyPreference   │
│ ClassificationID(FK) │      │ WorkloadPreference     │
└──────────────────────┘      │ PreferredDepartments   │
         │                     │ NotificationPreferences│
         │                     └────────────────────────┘
         │
         ├─ ACADEMIC_HISTORY (1:M)
         ├─ RECOMMENDATIONS (1:M)
         ├─ WAIVERS (1:M)
         │   ├─ WaiverID (PK)
         │   ├─ StudentID (FK) ────┘
         │   ├─ PrerequisiteID (FK) ──┘
         │   ├─ CourseID (FK)
         │   ├─ WaiverReason
         │   ├─ Status
         │   ├─ ApprovalDate
         │   └─ ExpiryDate
         │
         └─ AI_AGENT_LOGS (1:M)
            ├─ LogID (PK)
            ├─ StudentID (FK) ──┘
            ├─ AgentName
            ├─ ExecutionStartTime
            ├─ ExecutionEndTime
            ├─ ExecutionDurationMS
            ├─ InputParameters
            ├─ OutputData
            ├─ ErrorMessage
            ├─ ExecutionStatus
            ├─ QueryCount
            └─ TokensUsed

┌────────────────────────┐  ┌────────────────────────┐
│  DIFFICULTY_LEVELS     │  │  INSTRUCTION_MODES     │
├────────────────────────┤  ├────────────────────────┤
│ DifficultyLevelID (PK) │  │ InstructionModeID (PK) │
│ LevelCode              │  │ ModeCode               │
│ LevelName              │  │ ModeName               │
│ Description            │  │ Description            │
│ DisplayOrder           │  │ DisplayOrder           │
└────────────────────────┘  └────────────────────────┘
           △                           △
           │ (1:M)                     │ (1:M)
           └──────────COURSES◄─────────┘

┌────────────────────────┐  ┌────────────────────────┐
│  CLASSIFICATION        │  │  AUDIT_LOG             │
├────────────────────────┤  ├────────────────────────┤
│ ClassificationID (PK)  │  │ AuditID (PK)           │
│ ClassificationCode     │  │ EntityType             │
│ ClassificationName     │  │ EntityID               │
│ MinCreditsRequired     │  │ Action                 │
│ MaxCreditsRequired     │  │ UserID                 │
│ DisplayOrder           │  │ UserType               │
└────────────────────────┘  │ OldValues (JSON)       │
           △                │ NewValues (JSON)       │
           │ (1:M)          │ IPAddress              │
           │                │ CreatedDate            │
        STUDENTS            └────────────────────────┘

Audit/History Tables:
├─ RECOMMENDATION_HISTORY (RecommendationID FK)
├─ SCHEDULE_HISTORY (ScheduleID FK)
└─ WAIVER_HISTORY (WaiverID FK)

System Tables:
└─ SYSTEM_CONFIGURATION
   ├─ ConfigID (PK)
   ├─ ConfigKey (UNIQUE)
   ├─ ConfigValue
   ├─ ConfigType
   └─ Description
```

---

## 9. Data Types and Constraints

### 9.1 Standard Data Type Conventions

| Data Type | Purpose | Examples |
|-----------|---------|----------|
| INT | Integer identifiers, counts | IDs, credit hours, enrollment |
| BIGINT | Large numbers, timestamps | IDs for high-volume tables |
| DECIMAL(p,s) | Precise decimals | GPA (3,2), prices, percentages |
| VARCHAR(n) | Variable-length strings | Codes, names, URLs |
| TEXT | Long text | Descriptions, reasons, JSON |
| TIMESTAMP | Date and time | Created, updated, executed |
| DATE | Date only | Birth dates, graduation dates |
| TIME | Time only | Class start/end times |
| BOOLEAN | True/False | IsActive, PassFail |
| JSON | Structured data | Preferences, parameters |
| ENUM | Predefined values | Status, Type |

### 9.2 Common Constraints by Entity Type

**Primary Keys:**
- All entities must have PRIMARY KEY (auto-increment INT for most)
- Composite keys for junction/mapping tables (Future: Course × Department)

**Foreign Keys:**
- ON DELETE: RESTRICT or CASCADE (determine per relationship)
- ON UPDATE: CASCADE (IDs should rarely change)

**Uniqueness:**
- StudentID: UNIQUE (from SIS)
- Email: UNIQUE
- CourseCode: UNIQUE per term (consider composite with semester)
- DepartmentCode: UNIQUE
- ConfigKey: UNIQUE

**NOT NULL:**
- All critical business fields marked NOT NULL
- Optional fields allow NULL (e.g., ConcentrationID)

**Default Values:**
- CreatedDate: CURRENT_TIMESTAMP
- UpdatedDate: CURRENT_TIMESTAMP
- Status fields: Appropriate default (e.g., 'Active', 'Pending')

**Check Constraints:**
- GPA: BETWEEN 0 AND 4.0
- CreditHours: > 0
- TimeColumns: ValidateTimeFormat
- Rank: > 0
- RelevanceScore: BETWEEN 0 AND 1

---

## 10. Indexing Strategy

### 10.1 Critical Indexes for Performance

**High-Traffic Query Patterns:**

| Table | Column(s) | Index Type | Rationale |
|-------|-----------|-----------|-----------|
| Courses | CourseCode | UNIQUE | Search by code |
| Courses | Department | B-TREE | Filter by department |
| Courses | DifficultyLevel | B-TREE | Filter by difficulty |
| Courses | Status | B-TREE | Filter active courses |
| Schedules | CourseID, Semester | B-TREE | Find sections for course/term |
| Schedules | Semester | B-TREE | Filter by semester |
| Schedules | StartTime, EndTime | B-TREE | Conflict detection |
| Students | Email | UNIQUE | Authentication |
| Students | StudentID | PRIMARY | Identity |
| Academic_History | StudentID, TermCompleted | B-TREE | Get student history |
| Academic_History | CourseID | B-TREE | Find all enrollments |
| Academic_History | Grade | B-TREE | Filter by performance |
| Prerequisites | CourseID | B-TREE | Find prerequisites for course |
| Prerequisites | PrerequisiteCourseID | B-TREE | Find dependents |
| Recommendations | StudentID | B-TREE | Get student recommendations |
| Recommendations | GeneratedDate | B-TREE | Time-based queries |
| Waivers | StudentID, Status | B-TREE | Find pending waivers |
| AI_Agent_Logs | StudentID, ExecutionStartTime | B-TREE | Audit trail |

### 10.2 Full-Text Indexes (Future)

- `Courses.CourseName` - Course name search
- `Courses.Description` - Description keyword search
- `Student_Preferences.AcademicGoals` - Goal text search

### 10.3 Composite Indexes (Where Applicable)

- `(StudentID, CourseID, TermCompleted)` on Academic_History
- `(CourseID, Semester, SectionNumber)` on Schedules
- `(StudentID, PrerequisiteID, CourseID)` on Waivers

---

## 11. Summary Table: All Entities

| # | Entity Name | Primary Purpose | Record Count Estimate (Year 1) | Type |
|---|-----------|-----------------|------|------|
| 1 | Courses | Store course catalog | 400-500 | Core |
| 2 | Prerequisites | Prerequisite validation | 1,200-1,500 | Core |
| 3 | Schedules | Course sections by semester | 2,000-3,000 | Core |
| 4 | Students | Student profiles | 2,500-5,000 | Core |
| 5 | Academic_History | Course completion records | 50,000-100,000 | Core |
| 6 | Student_Preferences | Student goals/preferences | 1,500-2,500 | Core |
| 7 | Recommendations | AI recommendations | 20,000-50,000 | Supporting |
| 8 | Waivers | Prerequisite waiver requests | 100-500 | Supporting |
| 9 | AI_Agent_Logs | Agent execution tracking | 100,000-500,000 | Supporting |
| 10 | Recommendation_History | Recommendation audit trail | 20,000-100,000 | Audit |
| 11 | Schedule_History | Schedule change audit trail | 10,000-50,000 | Audit |
| 12 | Waiver_History | Waiver status changes | 200-1,000 | Audit |
| 13 | Departments | Department definitions | 10-15 | Reference |
| 14 | Difficulty_Levels | Difficulty classifications | 3-5 | Reference |
| 15 | Instruction_Modes | Delivery mode definitions | 3-5 | Reference |
| 16 | Classification | Student year levels | 4 | Reference |
| 17 | Audit_Log | System audit trail | 1,000,000+ | Audit |
| 18 | System_Configuration | Runtime configuration | 50-100 | System |

---

## Document Sign-Off

### Entity Identification Complete
**Identified Entities:** 18 (6 core + 6 supporting + 3 reference + 2 audit/system + 1 lookup table bonus)

### Next Steps
1. Create detailed ER diagram using tools (Lucidchart, Draw.io, DbSchema)
2. Define table DDL (CREATE TABLE statements)
3. Add check constraints and triggers
4. Optimize indexes for performance
5. Create stored procedures for complex queries
6. Set up views for common access patterns

---

**End of Entity-Relationship Analysis Document**

*This document serves as the foundation for database design and schema development.*
