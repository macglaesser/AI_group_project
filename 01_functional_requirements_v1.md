# Academic Course Assistant System - Functional Requirements
## Cox School of Business

**Document Version:** 1.0  
**Date Created:** November 17, 2025  
**Project:** Database-Driven AI Agentic Workflow for Course Recommendation

---

## 1. Executive Summary

The Academic Course Assistant System is a database-driven web application designed to help students at Cox School of Business discover, plan, and enroll in courses that align with their academic interests and career goals. The system leverages multiple AI agents to analyze student academic profiles and provide personalized course recommendations, while automatically validating prerequisites and course availability.

### Key Objectives
- Enable students to discover courses based on their academic interests and goals
- Automate prerequisite validation to ensure course eligibility
- Provide AI-powered personalized course recommendations
- Maintain comprehensive course catalog and schedule information
- Track student academic progress and history
- Streamline course planning and enrollment workflows

---

## 2. System Overview

### 2.1 Architecture Approach
- **Database Layer:** Relational database storing all course, student, and academic data
- **Application Layer:** Web-based interface for students to interact with the system
- **AI Agent Layer:** Multiple specialized agents for course analysis, recommendation, and prerequisite validation
- **Integration Point:** Agents query database and utilize business logic to provide recommendations

### 2.2 Scope
- Course discovery and exploration
- Prerequisite validation
- Academic history tracking
- Personalized course recommendations via AI agents
- Course schedule management
- Student profile management

### 2.3 Out of Scope
- Third-party system integration (initially)
- Enrollment management (future phase)
- Degree audit functionality
- Grade posting system
- Email/notification system (future enhancement)

---

## 3. Functional Requirements

### 3.1 Course Management

#### FR-3.1.1: Course Information Storage
The system SHALL store comprehensive course information including:
- **Course Code** (unique identifier, e.g., BUSI 3301)
- **Course Name** (full course title)
- **Course Description** (detailed course overview, learning outcomes)
- **Credit Hours** (semester credits)
- **Department** (e.g., Finance, Marketing, Accounting, Management)
- **Difficulty Level** (e.g., Introductory, Intermediate, Advanced)
- **Course Status** (Active, Inactive, Archived)
- **Maximum Enrollment Capacity**
- **Instruction Mode** (In-Person, Online, Hybrid)
- **Course URL/Syllabus Link**

#### FR-3.1.2: Course Catalog Display
The system SHALL allow students to:
- Browse the complete course catalog filtered by department
- View detailed course information pages
- Search courses by course code, name, or keyword
- Filter courses by difficulty level
- Filter courses by instruction mode
- Sort courses by various attributes (code, name, credits)

#### FR-3.1.3: Course Curriculum Mapping
The system SHALL maintain course curriculum mapping information:
- Primary department association
- Cross-listed departments
- Core/Elective designation
- Program/Track association (e.g., Finance Track, Marketing Track)
- Course categorization tags (e.g., Quantitative, Communication, Strategic)

### 3.2 Prerequisites and Course Dependencies

#### FR-3.2.1: Prerequisite Definition
The system SHALL store prerequisite relationships with:
- **Prerequisite Course Code** (required prerequisite course)
- **Target Course Code** (course requiring the prerequisite)
- **Minimum Grade Required** (e.g., C, B-, B, etc.)
- **Prerequisite Type** (Hard Requirement, Recommended, Co-requisite)
- **Effective Term** (when the prerequisite becomes effective)

#### FR-3.2.2: Prerequisite Chain Tracking
The system SHALL support:
- Multiple prerequisites per course
- Prerequisite chains (A requires B, B requires C, etc.)
- Alternative prerequisite paths (Take A OR B)
- Co-requisite courses (must take simultaneously)
- Waived prerequisites (with approval flag)

#### FR-3.2.3: Prerequisite Validation
The system SHALL validate student eligibility by:
- Checking if student has completed all prerequisites
- Verifying minimum grades achieved in prerequisite courses
- Identifying prerequisite gaps
- Supporting prerequisite waiver requests with approval workflow
- Displaying validation results with clear explanations

### 3.3 Course Scheduling

#### FR-3.3.1: Schedule Information Storage
The system SHALL store course schedule details including:
- **Semester/Term** (e.g., Fall 2024, Spring 2025, Summer 2025)
- **Section Number** (e.g., 01, 02, 03)
- **Professor Name** (instructor(s) teaching the section)
- **Meeting Days** (e.g., MWF, TR, Online)
- **Meeting Times** (start and end times)
- **Location/Building/Room** (physical or virtual meeting location)
- **Enrollment Status** (Open, Full, Closed)
- **Current Enrollment Count**
- **Wait List Status** and count

#### FR-3.3.2: Schedule Filtering
The system SHALL allow students to filter courses by:
- Specific semester/term
- Meeting days (e.g., find no Monday classes)
- Meeting times (time range preferences)
- Instruction mode (in-person, online, hybrid)
- Specific professor preferences
- Time conflict detection

#### FR-3.3.3: Schedule Visualization
The system SHALL provide:
- Calendar view of course schedules
- Time conflict identification
- Visual schedule builder
- Workload indicators (credit hours per term)

### 3.4 Student Academic History

#### FR-3.4.1: Academic Record Management
The system SHALL maintain student academic records including:
- **Student ID** (unique identifier)
- **Completed Courses** (list of all courses taken)
- **Course Grade** (final grade received: A, B+, B, B-, C, etc.)
- **Grade Points** (numeric equivalent of grade)
- **Term Completed** (semester/year course was taken)
- **Credit Hours Completed**
- **Cumulative GPA** (calculated from all completed courses)
- **Major/Concentration** (primary area of study)
- **Academic Standing** (Good Standing, Probation, etc.)
- **Total Credits Earned**

#### FR-3.4.2: Academic History Display
The system SHALL allow students to:
- View complete academic transcript
- Filter history by department, term, or time period
- View GPA calculations and breakdowns
- Identify patterns in course performance
- Export academic record

#### FR-3.4.3: Academic Progress Tracking
The system SHALL calculate and display:
- Courses completed toward degree requirements
- Remaining requirements by category
- Concentration progress
- Suggested course sequence

### 3.5 Student Profile and Preferences

#### FR-3.5.1: Student Profile Storage
The system SHALL maintain student profile information:
- **Basic Information** (name, student ID, email)
- **Academic Major/Concentration**
- **Graduation Target Date**
- **Academic Goals** (text field for student input)
- **Career Interests** (e.g., Corporate Finance, Investment Banking, Consulting)
- **Learning Preferences** (instruction mode, time preferences, instructor preferences)
- **Course Preferences** (departments of interest, difficulty level preference)
- **Schedule Constraints** (time windows available, days available)

#### FR-3.5.2: Preference Management
The system SHALL allow students to:
- Create and update academic profile
- Set course preferences and interests
- Specify schedule constraints
- Indicate career goals and learning objectives
- Manage notification preferences

---

## 4. AI Agent Workflow Requirements

### 4.1 Agent Architecture

#### FR-4.1.1: Multi-Agent System
The system SHALL implement multiple specialized AI agents:
- **Course Analysis Agent** - Analyzes course content and requirements
- **Prerequisite Validation Agent** - Validates student eligibility
- **Recommendation Engine Agent** - Generates personalized recommendations
- **Schedule Optimization Agent** - Suggests optimal course schedules
- **Academic Planning Agent** - Provides degree planning guidance

#### FR-4.1.2: Agent Collaboration
The system SHALL support:
- Inter-agent communication and data sharing
- Coordinated analysis across agents
- Consensus-building for recommendations
- Fallback mechanisms when agents disagree

### 4.2 Course Analysis Agent

#### FR-4.2.1: Course Content Analysis
The Course Analysis Agent SHALL:
- Parse course descriptions and identify key topics
- Extract skill requirements from course content
- Identify course categories and themes
- Analyze course difficulty indicators
- Assess workload and course intensity

#### FR-4.2.2: Skill and Topic Extraction
The Course Analysis Agent SHALL:
- Identify core skills developed by each course
- Extract technical and soft skills
- Map courses to competency frameworks
- Identify interdisciplinary connections
- Highlight industry-relevant outcomes

### 4.3 Prerequisite Validation Agent

#### FR-4.3.1: Eligibility Assessment
The Prerequisite Validation Agent SHALL:
- Query student academic history from database
- Check completed courses against prerequisites
- Verify minimum grades for all prerequisites
- Identify missing prerequisites
- Flag co-requisite requirements

#### FR-4.3.2: Prerequisite Reports
The Prerequisite Validation Agent SHALL:
- Generate detailed eligibility reports
- Provide clear explanations of ineligibility reasons
- Suggest prerequisite courses to complete
- Identify alternative pathways to course eligibility
- Recommend prerequisite waiver candidates

### 4.4 Recommendation Engine Agent

#### FR-4.4.1: Personalized Recommendations
The Recommendation Engine Agent SHALL:
- Analyze student academic profile and history
- Evaluate student academic goals and interests
- Consider career interests and trajectory
- Review course schedule preferences
- Generate ranked list of recommended courses

#### FR-4.4.2: Recommendation Rationale
The Recommendation Engine Agent SHALL:
- Provide explanations for each recommendation
- Explain how course aligns with student goals
- Highlight skill development opportunities
- Note career relevance
- Suggest prerequisite courses if needed

#### FR-4.4.3: Recommendation Customization
The Recommendation Engine Agent SHALL:
- Prioritize courses based on student preferences
- Consider prerequisite depth (suggest prerequisites if needed)
- Account for schedule constraints
- Balance core requirements with electives
- Adjust recommendations based on academic performance trends

### 4.5 Schedule Optimization Agent

#### FR-4.5.1: Schedule Building
The Schedule Optimization Agent SHALL:
- Suggest optimal course combinations for next semester
- Identify time conflicts
- Balance credit hour load
- Consider course availability
- Suggest alternative sections when conflicts exist

#### FR-4.5.2: Workload Management
The Schedule Optimization Agent SHALL:
- Assess total workload (credit hours + difficulty)
- Recommend workload balancing
- Suggest pacing strategies
- Consider prerequisite ordering

### 4.6 Academic Planning Agent

#### FR-4.6.1: Degree Planning
The Academic Planning Agent SHALL:
- Suggest long-term course sequence toward degree
- Ensure prerequisite sequencing
- Balance coursework across semesters
- Align with graduation timeline
- Identify potential bottlenecks

#### FR-4.6.2: Progress Planning
The Academic Planning Agent SHALL:
- Track progress toward degree requirements
- Recommend focus areas
- Suggest elective strategies
- Identify opportunities for specialization

---

## 5. Database Requirements

### 5.1 Core Entities

#### FR-5.1.1: Courses Table
Stores all course information:
- CourseID (Primary Key)
- CourseCode (unique)
- CourseName
- Description
- CreditHours
- Department
- DifficultyLevel
- Status
- MaxEnrollment
- InstructionMode
- SyllabusURL

#### FR-5.1.2: Prerequisites Table
Stores prerequisite relationships:
- PrerequisiteID (Primary Key)
- CourseID (Foreign Key)
- PrerequisiteID (Foreign Key)
- MinimumGrade
- PrerequisiteType (Hard/Recommended/Co-requisite)
- EffectiveTerm

#### FR-5.1.3: Schedules Table
Stores course schedule information:
- ScheduleID (Primary Key)
- CourseID (Foreign Key)
- Semester
- SectionNumber
- Professor
- MeetingDays
- StartTime
- EndTime
- Location
- EnrollmentStatus
- CurrentEnrollment
- WaitListCount

#### FR-5.1.4: Students Table
Stores student information:
- StudentID (Primary Key)
- FirstName
- LastName
- Email
- Major
- GraduationTargetDate
- AcademicStanding

#### FR-5.1.5: Academic History Table
Stores student course completion records:
- HistoryID (Primary Key)
- StudentID (Foreign Key)
- CourseID (Foreign Key)
- Grade
- GradePoints
- TermCompleted
- CreditHoursEarned

#### FR-5.1.6: Student Preferences Table
Stores student preferences and goals:
- PreferenceID (Primary Key)
- StudentID (Foreign Key)
- AcademicGoals
- CareerInterests
- PreferredInstructionMode
- ScheduleConstraints
- PreferredDepartments

### 5.2 Data Integrity Requirements

#### FR-5.2.1: Referential Integrity
The system SHALL maintain:
- Foreign key constraints on all relationships
- Cascade delete policies where appropriate
- Referential integrity validation

#### FR-5.2.2: Data Validation
The system SHALL validate:
- Course codes follow naming conventions
- Grades are valid values
- Credit hours are positive numbers
- Times are valid format
- GPAs are within valid range (0.0-4.0)

#### FR-5.2.3: Data Consistency
The system SHALL ensure:
- Prerequisite courses exist in course database
- Student academic records reference valid courses
- Grade point calculations are accurate
- GPA calculations are correct and current

---

## 6. User Interface Requirements

### 6.1 Student Interface

#### FR-6.1.1: Dashboard
The system SHALL provide a student dashboard with:
- Quick links to course discovery
- Academic profile summary
- GPA and academic standing display
- Recommended courses widget
- Upcoming deadlines/important dates

#### FR-6.1.2: Course Discovery Interface
The system SHALL provide:
- Course search and filter functionality
- Detailed course information view
- Related courses suggestions
- Prerequisite information display
- Schedule options by semester
- Availability/enrollment status indicator

#### FR-6.1.3: Academic Profile Interface
The system SHALL provide:
- View and edit student profile
- View academic history and transcript
- Update career interests and goals
- Manage course preferences
- Track academic progress

#### FR-6.1.4: Recommendation Interface
The system SHALL provide:
- View AI-generated course recommendations
- Read recommendation explanations
- Filter recommendations by criteria
- Schedule recommended courses
- Save recommendations for later

#### FR-6.1.5: Schedule Builder Interface
The system SHALL provide:
- Visual course schedule builder
- Time conflict detection
- Alternative section suggestions
- Schedule balancing recommendations
- Save and export schedule

### 6.2 Administrative Interface (Future Phase)

#### FR-6.2.1: Course Management
The system SHALL allow administrators to:
- Add, edit, delete courses
- Manage course schedules
- Update prerequisites
- Manage instructor assignments

#### FR-6.2.2: System Configuration
The system SHALL allow administrators to:
- Configure grading scales
- Manage academic terms/semesters
- Configure academic standing rules

---

## 7. Non-Functional Requirements

### 7.1 Performance Requirements

#### FR-7.1.1: Response Time
- Course search results shall load within 2 seconds
- Recommendation generation shall complete within 5 seconds
- Prerequisite validation shall complete within 1 second
- Page load time shall not exceed 3 seconds

#### FR-7.1.2: Scalability
- System shall support up to 5,000 concurrent students
- Database shall efficiently handle 100,000+ course records
- Support for 1,000+ course schedules per semester

#### FR-7.1.3: Availability
- System shall maintain 99.5% uptime during academic term
- Planned maintenance windows during breaks
- Automatic backup of all data

### 7.2 Security Requirements

#### FR-7.2.1: Authentication
- All students must authenticate before accessing system
- Secure password requirements
- Session management with timeouts
- Multi-factor authentication (future enhancement)

#### FR-7.2.2: Data Privacy
- Student data shall be protected and not shared without consent
- FERPA compliance for educational records
- Secure data storage with encryption
- Audit logs for data access

#### FR-7.2.3: Authorization
- Students can only view their own academic records
- Students cannot modify academic history
- Role-based access control for administrative functions

### 7.3 Accessibility Requirements

#### FR-7.3.1: Web Accessibility
- WCAG 2.1 Level AA compliance
- Keyboard navigation support
- Screen reader compatibility
- Sufficient color contrast

#### FR-7.3.2: Usability
- Intuitive user interface
- Clear error messages
- Helpful documentation and tooltips
- Mobile-responsive design

### 7.4 Data Quality Requirements

#### FR-7.4.1: Data Accuracy
- Course information regularly updated
- Academic records accurately reflect student history
- Prerequisites maintained current with catalog

#### FR-7.4.2: Data Completeness
- All required fields populated for courses
- Complete academic history for all students
- Comprehensive schedule information

---

## 8. Integration Points

### 8.1 AI Agent Integration

#### FR-8.1.1: Agent Execution Framework
- Agents access database through secure interfaces
- Query results processed by agent logic
- Recommendations stored for audit/review
- Agent logs maintained for troubleshooting

#### FR-8.1.2: Data Flow
- Student profile → Agents analyze
- Course catalog + academic history → Agents evaluate
- Agent outputs → Stored and presented to student

### 8.2 Future Integration Points

#### FR-8.2.1: Student Information System (SIS)
- One-way sync of student academic records
- Course catalog updates from SIS

#### FR-8.2.2: Email/Notification System
- Send course recommendations to students
- Academic milestone notifications
- Deadline reminders

---

## 9. Acceptance Criteria

### 9.1 Course Management
- [ ] All course information types can be stored and retrieved
- [ ] Course search works across all searchable fields
- [ ] Filtering by multiple criteria works correctly
- [ ] Course relationships (prerequisites, cross-lists) maintained accurately

### 9.2 Prerequisite Validation
- [ ] Prerequisite chains correctly identified
- [ ] Student eligibility accurately assessed
- [ ] Minimum grade requirements enforced
- [ ] Validation results clearly communicated

### 9.3 AI Agents
- [ ] Recommendation Engine produces relevant recommendations
- [ ] Prerequisite Validation Agent correctly identifies missing prerequisites
- [ ] Schedule Optimization Agent suggests workload-appropriate schedules
- [ ] Academic Planning Agent produces multi-semester plans

### 9.4 Database
- [ ] All data persists correctly
- [ ] Referential integrity maintained
- [ ] Data validation rules enforced
- [ ] Performance metrics met

### 9.5 User Interface
- [ ] Students can discover courses easily
- [ ] Students can view academic profile
- [ ] Students can access recommendations
- [ ] Schedule builder functions correctly
- [ ] All required information visible and accessible

---

## 10. Glossary

| Term | Definition |
|------|-----------|
| **AI Agent** | Autonomous software component with specialized business logic |
| **Co-requisite** | Course that must be taken at the same time as another course |
| **Credit Hour** | Unit of academic credit (typically 1 hour = 1 week of instruction) |
| **Difficulty Level** | Classification of course complexity (Introductory, Intermediate, Advanced) |
| **GPA** | Grade Point Average; cumulative average of all grades |
| **FERPA** | Family Educational Rights and Privacy Act |
| **Hard Requirement** | Prerequisite that must be completed before taking course |
| **Prerequisite** | Course that must be completed before taking another course |
| **Recommendation** | Suggested course based on student profile and goals |
| **Waiver** | Exception granted to bypass a requirement |

---

## 11. Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-17 | Project Team | Initial functional requirements document |

---

## Appendix A: Example AI Agent Interactions

### Example 1: Course Recommendation Workflow
1. Student accesses "Course Recommendations" page
2. System loads student profile from database
3. Recommendation Engine Agent queries:
   - Student academic history (completed courses, grades)
   - Student preferences (goals, interests, schedule constraints)
   - Available courses for upcoming semester
4. Agent analyzes:
   - Courses aligned with student's academic goals
   - Courses building on student's strengths
   - Prerequisites student has completed
   - Workload balancing with credit hours
5. Agent ranks recommendations and provides rationale
6. System displays recommendations with explanations to student

### Example 2: Prerequisite Validation Workflow
1. Student views course detail page
2. Clicks "Check My Eligibility" button
3. Prerequisite Validation Agent queries:
   - Course prerequisites from database
   - Student's completed courses and grades
   - Any approved waivers
4. Agent validates:
   - Each prerequisite completion
   - Minimum grade requirements
   - Co-requisite status
5. System displays eligibility status:
   - "Eligible" - with start date
   - "Not Eligible" - with list of missing prerequisites
   - "Pending Waiver" - with waiver status

### Example 3: Schedule Optimization Workflow
1. Student enters desired courses for next semester
2. Clicks "Optimize My Schedule" button
3. Schedule Optimization Agent queries:
   - All sections of desired courses
   - Student's schedule constraints (preferences from profile)
   - Course meeting times and locations
4. Agent analyzes:
   - Time conflicts between courses
   - Total credit hour load
   - Course difficulty combinations
   - Travel time between classes
5. Agent suggests:
   - Conflict-free combinations
   - Alternative sections with better times
   - Workload balancing recommendations
6. System displays optimized schedule options

---

**End of Functional Requirements Document**
