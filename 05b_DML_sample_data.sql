-- ============================================================================
-- Academic Course Assistant System - Sample Data
-- Cox School of Business
-- Version 1.0
-- Date: November 17, 2025
-- Description: DML INSERT statements with realistic sample data
-- ============================================================================

-- Enable foreign keys
PRAGMA foreign_keys = ON;

-- ============================================================================
-- REFERENCE DATA - Lookup Tables
-- ============================================================================

-- Departments
INSERT INTO Departments (DepartmentCode, DepartmentName, DepartmentType, IsActive, CreatedDate)
VALUES
  ('ACC', 'Accounting', 'Major', 1, '2024-01-01'),
  ('FIN', 'Finance', 'Concentration', 1, '2024-01-01'),
  ('MKT', 'Marketing', 'Concentration', 1, '2024-01-01'),
  ('MGT', 'Management', 'Concentration', 1, '2024-01-01'),
  ('BZAN', 'Business Analytics', 'Concentration', 1, '2024-01-01'),
  ('CS', 'Computer Science', 'Major', 1, '2024-01-01'),
  ('ECON', 'Economics', 'Support', 1, '2024-01-01'),
  ('MATH', 'Mathematics', 'Support', 1, '2024-01-01');

-- Difficulty Levels (3 total)

INSERT INTO DifficultyLevels (LevelCode, LevelName, DisplayOrder, CreatedDate)
VALUES
  ('INT', 'Introductory', 1, '2024-01-01'),    -- DifficultyLevelID 1
  ('MID', 'Intermediate', 2, '2024-01-01'),    -- DifficultyLevelID 2
  ('ADV', 'Advanced', 3, '2024-01-01');        -- DifficultyLevelID 3

-- Instruction Modes

INSERT INTO InstructionModes (ModeCode, ModeName, DisplayOrder, CreatedDate)
VALUES
  ('INP', 'In-Person', 1, '2024-01-01'),
  ('ONL', 'Online', 2, '2024-01-01'),
  ('HYB', 'Hybrid', 3, '2024-01-01');

-- Classifications
INSERT INTO Classification (ClassificationCode, ClassificationName, MinCreditsRequired, MaxCreditsRequired, DisplayOrder, CreatedDate)
VALUES
  ('FR', 'Freshman', 0, 29, 1, '2024-01-01'),
  ('SO', 'Sophomore', 30, 59, 2, '2024-01-01'),
  ('JR', 'Junior', 60, 89, 3, '2024-01-01'),
  ('SR', 'Senior', 90, 999, 4, '2024-01-01');

-- ============================================================================
-- COURSES (30 total) - Diverse across disciplines
-- ============================================================================

-- Accounting Courses (6)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('ACCT 2301', 'Intro to Financial Accounting', 'Foundational accounting principles and financial statement preparation', 3, 1, 1, 'Active', 40, 1, '2024-01-01'),
  ('ACCT 2302', 'Intro to Managerial Accounting', 'Cost accounting and management decision-making', 3, 1, 1, 'Active', 40, 1, '2024-01-01'),
  ('ACCT 3301', 'Intermediate Financial Accounting', 'Advanced financial accounting concepts and standards', 3, 1, 2, 'Active', 35, 1, '2024-01-01'),
  ('ACCT 4301', 'Advanced Financial Accounting', 'Complex accounting transactions and consolidations', 3, 1, 3, 'Active', 30, 1, '2024-01-01'),
  ('ACCT 4302', 'Auditing Principles', 'Audit procedures and professional standards', 3, 1, 3, 'Active', 30, 1, '2024-01-01'),
  ('ACCT 4303', 'Taxation', 'Individual and corporate tax planning', 3, 1, 3, 'Active', 35, 1, '2024-01-01');

-- Finance Courses (6)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('FIN 2301', 'Principles of Finance', 'Time value of money and financial decision making', 3, 2, 1, 'Active', 45, 1, '2024-01-01'),
  ('FIN 3301', 'Corporate Finance', 'Capital budgeting and investment analysis', 3, 2, 2, 'Active', 40, 1, '2024-01-01'),
  ('FIN 3302', 'Investments', 'Portfolio theory and security analysis', 3, 2, 2, 'Active', 35, 1, '2024-01-01'),
  ('FIN 4301', 'Advanced Corporate Finance', 'Mergers, acquisitions, and valuation', 3, 2, 3, 'Active', 30, 1, '2024-01-01'),
  ('FIN 4302', 'International Finance', 'Foreign exchange and global financial markets', 3, 2, 3, 'Active', 30, 2, '2024-01-01'),
  ('FIN 4303', 'Financial Risk Management', 'Derivatives and risk hedging strategies', 3, 2, 3, 'Active', 25, 1, '2024-01-01');

-- Marketing Courses (4)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('MKT 2301', 'Principles of Marketing', 'Marketing fundamentals and strategy', 3, 3, 1, 'Active', 45, 1, '2024-01-01'),
  ('MKT 3301', 'Market Research', 'Quantitative and qualitative research methods', 3, 3, 2, 'Active', 35, 1, '2024-01-01'),
  ('MKT 3302', 'Digital Marketing', 'Social media, SEO, and online advertising', 3, 3, 2, 'Active', 40, 1, '2024-01-01'),
  ('MKT 4301', 'Strategic Marketing', 'Brand strategy and competitive positioning', 3, 3, 3, 'Active', 30, 1, '2024-01-01');

-- Management/Business Courses (4)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('MGT 2301', 'Principles of Management', 'Management fundamentals and organizational structure', 3, 4, 1, 'Active', 50, 1, '2024-01-01'),
  ('MGT 3301', 'Organizational Behavior', 'Motivation, groups, and organizational dynamics', 3, 4, 2, 'Active', 40, 1, '2024-01-01'),
  ('BZAN 2301', 'Intro to Business Analytics', 'Data analysis fundamentals for business', 3, 5, 1, 'Active', 35, 1, '2024-01-01'),
  ('BZAN 3301', 'Data Mining', 'Predictive analytics and data exploration', 3, 5, 2, 'Active', 30, 1, '2024-01-01');

-- Computer Science Courses (4)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('CS 1301', 'Intro to Computer Science', 'Fundamentals of programming and computation', 3, 6, 1, 'Active', 40, 1, '2024-01-01'),
  ('CS 1302', 'Computer Programming', 'Object-oriented programming in Python', 3, 6, 1, 'Active', 35, 1, '2024-01-01'),
  ('CS 2301', 'Data Structures', 'Arrays, linked lists, trees, and algorithms', 3, 6, 2, 'Active', 30, 1, '2024-01-01'),
  ('CS 4301', 'Artificial Intelligence', 'Machine learning and AI fundamentals', 3, 6, 3, 'Active', 25, 1, '2024-01-01');

-- Economics & Math Courses (6)
INSERT INTO Courses (CourseCode, CourseName, Description, CreditHours, DepartmentID, DifficultyLevelID, Status, MaxEnrollment, InstructionModeID, CreatedDate)
VALUES
  ('ECON 2301', 'Principles of Microeconomics', 'Consumer behavior and market equilibrium', 3, 7, 1, 'Active', 50, 1, '2024-01-01'),
  ('ECON 2302', 'Principles of Macroeconomics', 'National income and economic growth', 3, 7, 1, 'Active', 50, 1, '2024-01-01'),
  ('ECON 3301', 'Intermediate Microeconomics', 'Advanced supply and demand analysis', 3, 7, 2, 'Active', 35, 1, '2024-01-01'),
  ('MATH 1309', 'College Algebra', 'Functions, equations, and mathematical modeling', 3, 8, 1, 'Active', 50, 1, '2024-01-01'),
  ('MATH 2309', 'Precalculus', 'Trigonometry and advanced algebra', 3, 8, 1, 'Active', 45, 1, '2024-01-01'),
  ('STAT 2301', 'Business Statistics', 'Probability, distributions, and hypothesis testing', 3, 8, 1, 'Active', 45, 1, '2024-01-01');

-- ============================================================================
-- PREREQUISITES (25 relationships) - Corrected CourseIDs
-- ============================================================================
INSERT INTO Prerequisites (CourseID, PrerequisiteCourseID, MinimumGrade, PrerequisiteType, EffectiveTerm, CreatedDate)
VALUES
  (3, 1, 'C', 'Hard', 'ALL', '2024-01-01'),      -- ACCT 3301 requires ACCT 2301
  (4, 3, 'C', 'Hard', 'ALL', '2024-01-01'),      -- ACCT 4301 requires ACCT 3301
  (5, 3, 'C', 'Hard', 'ALL', '2024-01-01'),      -- ACCT 4302 requires ACCT 3301
  (6, 1, 'C', 'Recommended', 'ALL', '2024-01-01'),  -- ACCT 4303 recommends ACCT 2301
  (8, 7, 'C', 'Hard', 'ALL', '2024-01-01'),      -- FIN 3301 requires FIN 2301
  (9, 7, 'C', 'Hard', 'ALL', '2024-01-01'),      -- FIN 3302 requires FIN 2301
  (10, 8, 'C', 'Hard', 'ALL', '2024-01-01'),     -- FIN 4301 requires FIN 3301
  (11, 8, 'C', 'Hard', 'ALL', '2024-01-01'),     -- FIN 4302 requires FIN 3301
  (12, 8, 'C', 'Hard', 'ALL', '2024-01-01'),     -- FIN 4303 requires FIN 3301
  (12, 30, 'C', 'Hard', 'ALL', '2024-01-01'),    -- FIN 4303 requires STAT 2301
  (8, 1, 'C', 'Recommended', 'ALL', '2024-01-01'),  -- FIN 3301 recommends ACCT 2301
  (14, 13, 'C', 'Hard', 'ALL', '2024-01-01'),    -- MKT 3301 requires MKT 2301
  (15, 13, 'C', 'Hard', 'ALL', '2024-01-01'),    -- MKT 3302 requires MKT 2301
  (16, 14, 'C', 'Hard', 'ALL', '2024-01-01'),    -- MKT 4301 requires MKT 3301
  (16, 19, 'C', 'Recommended', 'ALL', '2024-01-01'),  -- MKT 4301 recommends BZAN 2301
  (19, 28, 'C', 'Hard', 'ALL', '2024-01-01'),    -- BZAN 2301 requires MATH 1309
  (20, 19, 'C', 'Hard', 'ALL', '2024-01-01'),    -- BZAN 3301 requires BZAN 2301
  (20, 30, 'C', 'Hard', 'ALL', '2024-01-01'),    -- BZAN 3301 requires STAT 2301
  (22, 21, 'C', 'Hard', 'ALL', '2024-01-01'),    -- CS 1302 requires CS 1301
  (23, 22, 'C', 'Hard', 'ALL', '2024-01-01'),    -- CS 2301 requires CS 1302
  (24, 23, 'C', 'Hard', 'ALL', '2024-01-01'),    -- CS 4301 requires CS 2301
  (29, 28, 'C', 'Hard', 'ALL', '2024-01-01'),    -- MATH 2309 requires MATH 1309
  (30, 28, 'C', 'Hard', 'ALL', '2024-01-01'),    -- STAT 2301 requires MATH 1309
  (27, 25, 'C', 'Hard', 'ALL', '2024-01-01');    -- ECON 3301 requires ECON 2301

-- ============================================================================
-- SCHEDULES (15 sections across 3 semesters)
-- ============================================================================

-- Fall 2024 Schedules
INSERT INTO Schedules (CourseID, Semester, SectionNumber, ProfessorName, MeetingDays, StartTime, EndTime, Location, InstructionModeID, EnrollmentStatus, CurrentEnrollment, MaxCapacity, CreatedDate)
VALUES
  (1, 'Fall2024', '01', 'Dr. Patricia Chen', 'MW', '09:00', '10:30', 'Cox 101', 1, 'Open', 28, 40, '2024-08-01'),  -- ScheduleID 1
  (1, 'Fall2024', '02', 'Dr. Michael Torres', 'TR', '13:00', '14:30', 'Cox 102', 1, 'Open', 35, 40, '2024-08-01'),  -- ScheduleID 2
  (13, 'Fall2024', '01', 'Dr. Sarah Johnson', 'MWF', '10:00', '10:50', 'Cox 103', 1, 'Open', 42, 45, '2024-08-01'),  -- ScheduleID 3
  (19, 'Fall2024', '01', 'Dr. Rajesh Patel', 'TR', '14:00', '15:30', 'Cox 104', 1, 'Full', 35, 35, '2024-08-01'),  -- ScheduleID 4
  (28, 'Fall2024', '01', 'Dr. Linda Martinez', 'MWF', '11:00', '11:50', 'Cox 105', 1, 'Open', 38, 50, '2024-08-01'),  -- ScheduleID 5
  (30, 'Fall2024', '01', 'Dr. James Wilson', 'TR', '10:00', '11:30', 'Cox 106', 1, 'Open', 40, 45, '2024-08-01');  -- ScheduleID 6

-- Spring 2025 Schedules
INSERT INTO Schedules (CourseID, Semester, SectionNumber, ProfessorName, MeetingDays, StartTime, EndTime, Location, InstructionModeID, EnrollmentStatus, CurrentEnrollment, MaxCapacity, CreatedDate)
VALUES
  (3, 'Spring2025', '01', 'Dr. Patricia Chen', 'MW', '09:00', '10:30', 'Cox 101', 1, 'Open', 22, 35, '2024-12-15'),  -- ScheduleID 7
  (8, 'Spring2025', '01', 'Dr. Robert Lee', 'TR', '13:00', '14:30', 'Cox 102', 1, 'Open', 32, 40, '2024-12-15'),  -- ScheduleID 8
  (9, 'Spring2025', '01', 'Dr. Angela Davis', 'MWF', '10:00', '10:50', 'Cox 103', 1, 'Open', 28, 35, '2024-12-15'),  -- ScheduleID 9
  (14, 'Spring2025', '01', 'Dr. Jennifer Kim', 'TR', '15:00', '16:30', 'Cox 104', 1, 'Open', 31, 40, '2024-12-15'),  -- ScheduleID 10
  (22, 'Spring2025', '01', 'Dr. David Miller', 'MWF', '14:00', '14:50', 'Cox 105', 1, 'Open', 29, 40, '2024-12-15');  -- ScheduleID 11

-- Fall 2025 Schedules
INSERT INTO Schedules (CourseID, Semester, SectionNumber, ProfessorName, MeetingDays, StartTime, EndTime, Location, InstructionModeID, EnrollmentStatus, CurrentEnrollment, MaxCapacity, CreatedDate)
VALUES
  (4, 'Fall2025', '01', 'Dr. Patricia Chen', 'MW', '09:00', '10:30', 'Cox 101', 1, 'Open', 18, 30, '2025-06-15'),  -- ScheduleID 12
  (10, 'Fall2025', '01', 'Dr. Robert Lee', 'TR', '13:00', '14:30', 'Cox 102', 1, 'Open', 24, 30, '2025-06-15'),  -- ScheduleID 13
  (16, 'Fall2025', '01', 'Dr. Jennifer Kim', 'MWF', '10:00', '10:50', 'Cox 103', 1, 'Open', 26, 30, '2025-06-15'),  -- ScheduleID 14
  (24, 'Fall2025', '01', 'Dr. Christopher Brown', 'TR', '15:00', '16:30', 'Cox 104', 1, 'Open', 20, 25, '2025-06-15');  -- ScheduleID 15

-- ============================================================================
-- STUDENTS (3 profiles)
-- ============================================================================

INSERT INTO Students (StudentID, FirstName, LastName, Email, MajorID, ConcentrationID, GraduationTargetDate, AcademicStanding, CumulativeGPA, TotalCreditsEarned, ClassificationID, SISImportDate, CreatedDate)
VALUES
  (10001, 'Alex', 'Chen', 'achen@smu.edu', 1, 2, '2025-05-15', 'Good Standing', 3.65, 66, 3, '2024-08-01', '2024-08-01'),
  (10002, 'Jordan', 'Rodriguez', 'jrodriguez@smu.edu', 3, 5, '2025-05-15', 'Good Standing', 3.52, 95, 4, '2024-08-01', '2024-08-01'),
  (10003, 'Sam', 'Patel', 'spatel@smu.edu', 5, 6, '2026-05-15', 'Good Standing', 3.78, 48, 2, '2024-08-01', '2024-08-01');

-- ============================================================================
-- ACADEMIC HISTORY (10-12 courses per student)
-- ============================================================================

-- Alex Chen: Accounting/Finance Track (11 courses)
INSERT INTO AcademicHistory (StudentID, CourseID, ScheduleID, Grade, GradePoints, TermCompleted, CreditHoursEarned, CompletionDate, GradePointsContribution, CreatedDate)
VALUES
  (10001, 28, NULL, 'A', 4.0, 'Fall2022', 3, '2022-12-15', 12.0, '2024-01-01'),
  (10001, 30, NULL, 'A', 4.0, 'Fall2022', 3, '2022-12-15', 12.0, '2024-01-01'),
  (10001, 25, NULL, 'A', 4.0, 'Spring2023', 3, '2023-05-15', 12.0, '2024-01-01'),
  (10001, 1, NULL, 'A', 4.0, 'Spring2023', 3, '2023-05-15', 12.0, '2024-01-01'),
  (10001, 7, NULL, 'A', 4.0, 'Spring2023', 3, '2023-05-15', 12.0, '2024-01-01'),
  (10001, 3, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10001, 8, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10001, 2, NULL, 'B+', 3.7, 'Spring2024', 3, '2024-05-15', 11.1, '2024-01-01'),
  (10001, 9, NULL, 'A', 4.0, 'Spring2024', 3, '2024-05-15', 12.0, '2024-01-01'),
  (10001, 18, NULL, 'B+', 3.7, 'Fall2024', 3, '2024-12-15', 11.1, '2024-01-01'),
  (10001, 12, NULL, 'A', 4.0, 'Fall2024', 3, '2024-12-15', 12.0, '2024-01-01');

-- Jordan Rodriguez: Marketing/Analytics Track (12 courses)
INSERT INTO AcademicHistory (StudentID, CourseID, ScheduleID, Grade, GradePoints, TermCompleted, CreditHoursEarned, CompletionDate, GradePointsContribution, CreatedDate)
VALUES
  (10002, 28, NULL, 'A', 4.0, 'Fall2021', 3, '2021-12-15', 12.0, '2024-01-01'),
  (10002, 25, NULL, 'A', 4.0, 'Fall2021', 3, '2021-12-15', 12.0, '2024-01-01'),
  (10002, 30, NULL, 'B+', 3.7, 'Spring2022', 3, '2022-05-15', 11.1, '2024-01-01'),
  (10002, 13, NULL, 'A', 4.0, 'Spring2022', 3, '2022-05-15', 12.0, '2024-01-01'),
  (10002, 7, NULL, 'A', 4.0, 'Fall2022', 3, '2022-12-15', 12.0, '2024-01-01'),
  (10002, 19, NULL, 'A', 4.0, 'Fall2022', 3, '2022-12-15', 12.0, '2024-01-01'),
  (10002, 14, NULL, 'A', 4.0, 'Spring2023', 3, '2023-05-15', 12.0, '2024-01-01'),
  (10002, 20, NULL, 'B', 3.3, 'Spring2023', 3, '2023-05-15', 9.9, '2024-01-01'),
  (10002, 15, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10002, 1, NULL, 'B+', 3.7, 'Spring2024', 3, '2024-05-15', 11.1, '2024-01-01'),
  (10002, 16, NULL, 'A', 4.0, 'Fall2024', 3, '2024-12-15', 12.0, '2024-01-01'),
  (10002, 9, NULL, 'A', 4.0, 'Fall2024', 3, '2024-12-15', 12.0, '2024-01-01');

-- Sam Patel: Analytics/CS Track (10 courses)
INSERT INTO AcademicHistory (StudentID, CourseID, ScheduleID, Grade, GradePoints, TermCompleted, CreditHoursEarned, CompletionDate, GradePointsContribution, CreatedDate)
VALUES
  (10003, 28, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10003, 21, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10003, 29, NULL, 'A', 4.0, 'Fall2023', 3, '2023-12-15', 12.0, '2024-01-01'),
  (10003, 30, NULL, 'B+', 3.7, 'Spring2024', 3, '2024-05-15', 11.1, '2024-01-01'),
  (10003, 22, NULL, 'A', 4.0, 'Spring2024', 3, '2024-05-15', 12.0, '2024-01-01'),
  (10003, 19, NULL, 'A', 4.0, 'Spring2024', 3, '2024-05-15', 12.0, '2024-01-01'),
  (10003, 23, NULL, 'B', 3.3, 'Fall2024', 3, '2024-12-15', 9.9, '2024-01-01'),
  (10003, 25, NULL, 'A', 4.0, 'Fall2024', 3, '2024-12-15', 12.0, '2024-01-01'),
  (10003, 1, NULL, 'B+', 3.7, 'Fall2024', 3, '2024-12-15', 11.1, '2024-01-01'),
  (10003, 24, NULL, 'A', 4.0, 'Fall2024', 3, '2024-12-15', 12.0, '2024-01-01');

-- ============================================================================
-- STUDENT PREFERENCES
-- ============================================================================

INSERT INTO StudentPreferences (StudentID, AcademicGoals, CareerInterests, PreferredInstructionModeID, PreferredStartTime, PreferredEndTime, PreferredDaysAvailable, DifficultyPreference, WorkloadPreference, NotificationPreferences, ProfileCompleteness, CreatedDate)
VALUES
  (10001, 'Pass CPA exam and become auditor', 'Big 4 accounting firm', 1, '09:00', '14:00', 'MWF', 'Intermediate', 'Moderate', '{"email": true, "sms": true, "notification": true}', 85, '2024-08-01'),
  (10002, 'Marketing director role at Fortune 500', 'Digital marketing in tech industry', 1, '10:00', '15:00', 'TR', 'Intermediate', 'Heavy', '{"email": true, "sms": false, "notification": true}', 90, '2024-08-01'),
  (10003, 'Data science career in fintech', 'AI/ML opportunities at startups', 1, '09:00', '17:00', 'MWF', 'Advanced', 'Heavy', '{"email": true, "sms": true, "notification": true}', 88, '2024-08-01');

-- ============================================================================
-- AI AGENT LOGS (5 example executions)
-- ============================================================================

INSERT INTO AIAgentLogs (AgentName, StudentID, ExecutionStartTime, ExecutionEndTime, ExecutionDurationMS, InputParameters, OutputData, ExecutionStatus, RecommendationCount, QueryCount, AIModelUsed, TokensUsed, CostUSD, CreatedDate)
VALUES
  ('RecommendationEngine', 10001, '2024-11-15 10:30:00', '2024-11-15 10:35:00', 5200, '{"studentId": 10001, "limitToMajor": false, "maxRecommendations": 5}', '{"recommendations": 5, "topCourseId": 4, "averageScore": 0.92}', 'Success', 5, 12, 'GPT-4', 1500, 0.0225, '2024-11-15'),
  ('PrerequisiteValidator', 10002, '2024-11-15 11:00:00', '2024-11-15 11:00:15', 850, '{"studentId": 10002, "proposedCourseId": 16}', '{"prerequisitesMet": true, "missingPrereqs": [], "waiverNeeded": false}', 'Success', 0, 8, 'GPT-3.5', 400, 0.0006, '2024-11-15'),
  ('ScheduleOptimizer', 10003, '2024-11-15 11:30:00', '2024-11-15 11:32:30', 2100, '{"studentId": 10003, "semester": "Spring2025", "preferredTimes": ["09:00-12:00"]}', '{"optimalSchedule": [22, 30, 8], "conflictDetected": false, "totalHours": 9}', 'Success', 0, 15, 'GPT-4', 2100, 0.0315, '2024-11-15'),
  ('RecommendationEngine', 10002, '2024-11-16 09:00:00', '2024-11-16 09:04:45', 4300, '{"studentId": 10002, "focusArea": "Analytics", "includeElectives": true}', '{"recommendations": 3, "topCourseId": 19, "averageScore": 0.88}', 'Success', 3, 10, 'GPT-4', 1800, 0.0270, '2024-11-16'),
  ('PrerequisiteValidator', 10001, '2024-11-16 14:15:00', '2024-11-16 14:15:20', 650, '{"studentId": 10001, "proposedCourseIds": [10, 4, 12]}', '{"allMetPrereqs": true, "courseStatus": [{"courseId": 10, "status": "ready"}, {"courseId": 4, "status": "ready"}, {"courseId": 12, "status": "ready"}]}', 'Success', 0, 9, 'GPT-3.5', 350, 0.0005, '2024-11-16');

-- ============================================================================
-- RECOMMENDATIONS (8 total - mix of active and expired)
-- ============================================================================

INSERT INTO Recommendations (StudentID, CourseID, ScheduleID, Rank, RelevanceScore, RecommendationReason, PrerequisiteStatus, LogID, GeneratedDate, ExpiryDate, UserFeedback, IsActive, CreatedDate)
VALUES
  (10001, 4, NULL, 1, 0.95, 'Aligns with accounting major and prerequisite requirements', 'Met', 1, '2024-11-15 10:35:00', '2025-02-15', 'Helpful', 1, '2024-11-15'),
  (10001, 10, NULL, 2, 0.88, 'Advanced corporate finance builds on completed FIN 3301', 'Met', 1, '2024-11-15 10:35:00', '2025-02-15', NULL, 1, '2024-11-15'),
  (10002, 16, NULL, 1, 0.92, 'Strategic marketing aligns with career goals in corporate marketing', 'Met', 4, '2024-11-16 09:04:45', '2025-02-16', 'Helpful', 1, '2024-11-16'),
  (10002, 19, NULL, 2, 0.87, 'Data mining complements marketing analytics interests', 'Met', 4, '2024-11-16 09:04:45', '2025-02-16', NULL, 1, '2024-11-16'),
  (10003, 22, NULL, 1, 0.96, 'Data structures prerequisite for AI coursework', 'Met', 1, '2024-11-15 10:35:00', '2025-02-15', 'Helpful', 1, '2024-11-15'),
  (10003, 24, NULL, 2, 0.91, 'AI fundamentals aligns with career in machine learning', 'Met', 1, '2024-11-15 10:35:00', '2025-02-15', 'Helpful', 1, '2024-11-15'),
  (10001, 5, NULL, 3, 0.82, 'Auditing internship prepares for CPA requirements', 'Met', 1, '2024-11-15 10:35:00', '2025-05-15', NULL, 1, '2024-11-15'),
  (10002, 14, NULL, 3, 0.79, 'Market research methodology course for research specialization', 'Met', 4, '2024-11-16 09:04:45', '2025-05-16', NULL, 1, '2024-11-16');

-- ============================================================================
-- WAIVERS (2 example requests)
-- ============================================================================

INSERT INTO Waivers (StudentID, PrerequisiteID, CourseID, WaiverReason, SupportingDocumentation, RequestDate, Status, ApprovalDate, ApprovedByID, ApprovedByName, ApprovalReason, ExpiryDate, CreatedDate)
VALUES
  (10001, 5, 10, 'Completed equivalent advanced finance course at community college', 'Community_College_Transcript.pdf', '2024-10-01 14:30:00', 'Approved', '2024-10-05 09:00:00', 1001, 'Dr. Robert Lee', 'Community college course equivalent to FIN 3301', '2025-10-05', '2024-10-01'),
  (10002, 14, 16, 'Extensive professional marketing experience and self-study of foundational concepts', 'Professional_Experience_Letter.pdf', '2024-09-15 10:00:00', 'Pending', NULL, NULL, NULL, NULL, NULL, '2024-09-15');

-- ============================================================================
-- RECOMMENDATION HISTORY (Audit trail)
-- ============================================================================

INSERT INTO RecommendationHistory (RecommendationID, StudentID, Action, OldValues, NewValues, ChangeReason, CreatedDate)
VALUES
  (1, 10001, 'Created', NULL, '{"rank": 1, "relevanceScore": 0.95, "status": "Active"}', 'Initial recommendation generated', '2024-11-15'),
  (1, 10001, 'Updated', '{"userFeedback": null}', '{"userFeedback": "Helpful"}', 'Student marked as helpful', '2024-11-16'),
  (3, 10002, 'Created', NULL, '{"rank": 1, "relevanceScore": 0.92, "status": "Active"}', 'Initial recommendation generated', '2024-11-16'),
  (5, 10003, 'Created', NULL, '{"rank": 1, "relevanceScore": 0.96, "status": "Active"}', 'Initial recommendation generated', '2024-11-15'),
  (6, 10003, 'Updated', '{"userFeedback": null}', '{"userFeedback": "Helpful"}', 'Student endorsed recommendation', '2024-11-17');

-- ============================================================================
-- AUDIT LOG (Sample FERPA-compliant audit trail)
-- ============================================================================

INSERT INTO AuditLog (EntityType, EntityID, Action, UserID, UserType, OldValues, NewValues, IPAddress, UserAgent, CreatedDate)
VALUES
  ('Student', 10001, 'Read', 10001, 'Student', NULL, NULL, '192.168.1.100', 'Mozilla/5.0', '2024-11-15 10:30:00'),
  ('Recommendation', 1, 'Create', NULL, 'System', NULL, '{"courseId": 4, "rank": 1, "score": 0.95}', '10.0.0.1', 'RecommendationEngine/1.0', '2024-11-15 10:35:00'),
  ('AcademicHistory', 1, 'Read', 10001, 'Student', NULL, NULL, '192.168.1.100', 'Mozilla/5.0', '2024-11-15 11:00:00'),
  ('StudentPreferences', 1, 'Update', 10001, 'Student', '{"workloadPreference": "Light"}', '{"workloadPreference": "Moderate"}', '192.168.1.100', 'Mozilla/5.0', '2024-11-15 14:30:00'),
  ('Recommendation', 1, 'Update', 10001, 'Student', '{"userFeedback": null}', '{"userFeedback": "Helpful"}', '192.168.1.100', 'Mozilla/5.0', '2024-11-16 09:15:00'),
  ('Waiver', 1, 'Create', 10001, 'Student', NULL, '{"status": "Approved", "approvedBy": "Dr. Robert Lee"}', '192.168.1.100', 'Mozilla/5.0', '2024-10-01 14:30:00'),
  ('Waiver', 1, 'Read', 1001, 'Faculty', NULL, NULL, '10.0.0.5', 'Firefox/95.0', '2024-10-05 08:45:00'),
  ('Student', 10002, 'Read', 10002, 'Student', NULL, NULL, '192.168.1.101', 'Chrome/96.0', '2024-11-16 09:00:00'),
  ('Recommendation', 4, 'Create', NULL, 'System', NULL, '{"courseId": 19, "rank": 2, "score": 0.87}', '10.0.0.1', 'RecommendationEngine/1.0', '2024-11-16 09:04:45');

-- ============================================================================
-- SCHEDULE HISTORY (Enrollment changes)
-- ============================================================================

INSERT INTO ScheduleHistory (ScheduleID, Action, OldValues, NewValues, ChangeReason, ChangedByID, CreatedDate)
VALUES
  (1, 'Created', NULL, '{"semester": "Fall2024", "professor": "Dr. Patricia Chen", "status": "Open"}', 'Schedule section created', NULL, '2024-08-01'),
  (1, 'Updated', '{"currentEnrollment": 25}', '{"currentEnrollment": 28}', 'Student enrollment', 10001, '2024-08-15'),
  (4, 'Created', NULL, '{"semester": "Fall2024", "professor": "Dr. Rajesh Patel", "status": "Open"}', 'Schedule section created', NULL, '2024-08-01'),
  (4, 'Updated', '{"enrollmentStatus": "Open"}', '{"enrollmentStatus": "Full"}', 'Course reached capacity', NULL, '2024-09-10');

-- ============================================================================
-- SYSTEM CONFIGURATION
-- ============================================================================

INSERT INTO SystemConfiguration (ConfigKey, ConfigValue, ConfigType, Description, IsActive, LastModifiedDate)
VALUES
  ('MIN_GPA_RECOMMENDATION', '2.0', 'Float', 'Minimum GPA required for course recommendations', 1, '2024-01-01'),
  ('MAX_CONCURRENT_RECOMMENDATIONS', '10', 'Integer', 'Maximum active recommendations per student', 1, '2024-01-01'),
  ('RECOMMENDATION_EXPIRY_DAYS', '90', 'Integer', 'Days before recommendations expire', 1, '2024-01-01'),
  ('DEFAULT_INSTRUCTION_MODE', 'InPerson', 'String', 'Default instruction mode for schedules', 1, '2024-01-01'),
  ('API_RATE_LIMIT', '1000', 'Integer', 'API requests per hour per client', 1, '2024-01-01'),
  ('AUDIT_LOG_RETENTION_DAYS', '2555', 'Integer', 'Days to retain audit logs (7 years)', 1, '2024-01-01');

-- ============================================================================
-- END OF DML SAMPLE DATA
-- ============================================================================
