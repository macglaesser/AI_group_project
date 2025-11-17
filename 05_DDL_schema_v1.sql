-- ============================================================================
-- Academic Course Assistant System - SQLite Database Schema
-- Cox School of Business
-- Version 1.0
-- Date: November 17, 2025
-- Description: Complete DDL script for SQLite database implementation
-- ============================================================================

-- Enable foreign keys (required for SQLite)
PRAGMA foreign_keys = ON;

-- ============================================================================
-- REFERENCE/LOOKUP ENTITIES
-- ============================================================================

-- Departments lookup table
CREATE TABLE Departments (
  DepartmentID INTEGER PRIMARY KEY AUTOINCREMENT,
  DepartmentCode VARCHAR(20) UNIQUE NOT NULL,
  DepartmentName VARCHAR(100) NOT NULL,
  Description TEXT,
  DepartmentType TEXT CHECK(DepartmentType IN ('Major', 'Concentration', 'Support')) NOT NULL,
  IsActive BOOLEAN DEFAULT 1,
  DepartmentChairID INTEGER,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_Departments_DepartmentCode ON Departments(DepartmentCode);
CREATE INDEX idx_Departments_DepartmentName ON Departments(DepartmentName);
CREATE INDEX idx_Departments_IsActive ON Departments(IsActive);

-- Difficulty Levels lookup table
CREATE TABLE DifficultyLevels (
  DifficultyLevelID INTEGER PRIMARY KEY AUTOINCREMENT,
  LevelCode VARCHAR(20) UNIQUE NOT NULL,
  LevelName VARCHAR(50) NOT NULL,
  Description TEXT,
  DisplayOrder INTEGER NOT NULL,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_DifficultyLevels_LevelCode ON DifficultyLevels(LevelCode);
CREATE INDEX idx_DifficultyLevels_DisplayOrder ON DifficultyLevels(DisplayOrder);

-- Instruction Modes lookup table
CREATE TABLE InstructionModes (
  InstructionModeID INTEGER PRIMARY KEY AUTOINCREMENT,
  ModeCode VARCHAR(20) UNIQUE NOT NULL,
  ModeName VARCHAR(50) NOT NULL,
  Description TEXT,
  DisplayOrder INTEGER NOT NULL,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_InstructionModes_ModeCode ON InstructionModes(ModeCode);
CREATE INDEX idx_InstructionModes_DisplayOrder ON InstructionModes(DisplayOrder);

-- Classification lookup table
CREATE TABLE Classification (
  ClassificationID INTEGER PRIMARY KEY AUTOINCREMENT,
  ClassificationCode VARCHAR(20) UNIQUE NOT NULL,
  ClassificationName VARCHAR(50) NOT NULL,
  MinCreditsRequired INTEGER NOT NULL,
  MaxCreditsRequired INTEGER NOT NULL,
  DisplayOrder INTEGER NOT NULL,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_Classification_ClassificationCode ON Classification(ClassificationCode);
CREATE INDEX idx_Classification_DisplayOrder ON Classification(DisplayOrder);

-- ============================================================================
-- CORE DOMAIN ENTITIES
-- ============================================================================

-- Courses table
CREATE TABLE Courses (
  CourseID INTEGER PRIMARY KEY AUTOINCREMENT,
  CourseCode VARCHAR(20) UNIQUE NOT NULL,
  CourseName VARCHAR(255) NOT NULL,
  Description TEXT NOT NULL,
  CreditHours DECIMAL(3,1) NOT NULL,
  DepartmentID INTEGER NOT NULL,
  DifficultyLevelID INTEGER NOT NULL,
  Status TEXT CHECK(Status IN ('Active', 'Inactive', 'Archived')) DEFAULT 'Active' NOT NULL,
  MaxEnrollment INTEGER NOT NULL,
  InstructionModeID INTEGER NOT NULL,
  SyllabusURL VARCHAR(255),
  LearningOutcomes TEXT,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (DifficultyLevelID) REFERENCES DifficultyLevels(DifficultyLevelID),
  FOREIGN KEY (InstructionModeID) REFERENCES InstructionModes(InstructionModeID)
);

CREATE INDEX idx_Courses_CourseCode ON Courses(CourseCode);
CREATE INDEX idx_Courses_DepartmentID ON Courses(DepartmentID);
CREATE INDEX idx_Courses_DifficultyLevelID ON Courses(DifficultyLevelID);
CREATE INDEX idx_Courses_Status ON Courses(Status);
CREATE INDEX idx_Courses_InstructionModeID ON Courses(InstructionModeID);
CREATE INDEX idx_Courses_DepartmentID_Status ON Courses(DepartmentID, Status);

-- Prerequisites table (self-referencing)
CREATE TABLE Prerequisites (
  PrerequisiteID INTEGER PRIMARY KEY AUTOINCREMENT,
  CourseID INTEGER NOT NULL,
  PrerequisiteCourseID INTEGER NOT NULL,
  MinimumGrade VARCHAR(5) NOT NULL,
  PrerequisiteType TEXT CHECK(PrerequisiteType IN ('Hard', 'Recommended', 'Co-requisite')) NOT NULL,
  EffectiveTerm VARCHAR(20) NOT NULL,
  Notes TEXT,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
  FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID)
);

CREATE INDEX idx_Prerequisites_CourseID ON Prerequisites(CourseID);
CREATE INDEX idx_Prerequisites_PrerequisiteCourseID ON Prerequisites(PrerequisiteCourseID);
CREATE INDEX idx_Prerequisites_EffectiveTerm ON Prerequisites(EffectiveTerm);
CREATE INDEX idx_Prerequisites_CourseID_EffectiveTerm ON Prerequisites(CourseID, EffectiveTerm);

-- Schedules table
CREATE TABLE Schedules (
  ScheduleID INTEGER PRIMARY KEY AUTOINCREMENT,
  CourseID INTEGER NOT NULL,
  Semester VARCHAR(20) NOT NULL,
  SectionNumber VARCHAR(10) NOT NULL,
  ProfessorID INTEGER,
  ProfessorName VARCHAR(255) NOT NULL,
  MeetingDays VARCHAR(20) NOT NULL,
  StartTime TIME NOT NULL,
  EndTime TIME NOT NULL,
  Location VARCHAR(255),
  InstructionModeID INTEGER NOT NULL,
  EnrollmentStatus TEXT CHECK(EnrollmentStatus IN ('Open', 'Full', 'Closed', 'Waitlist')) NOT NULL,
  CurrentEnrollment INTEGER DEFAULT 0,
  WaitListCount INTEGER DEFAULT 0,
  MaxCapacity INTEGER NOT NULL,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
  FOREIGN KEY (InstructionModeID) REFERENCES InstructionModes(InstructionModeID)
);

CREATE INDEX idx_Schedules_CourseID_Semester_SectionNumber ON Schedules(CourseID, Semester, SectionNumber);
CREATE INDEX idx_Schedules_CourseID ON Schedules(CourseID);
CREATE INDEX idx_Schedules_Semester ON Schedules(Semester);
CREATE INDEX idx_Schedules_InstructionModeID ON Schedules(InstructionModeID);
CREATE INDEX idx_Schedules_StartTime_EndTime ON Schedules(StartTime, EndTime);
CREATE INDEX idx_Schedules_Semester_EnrollmentStatus ON Schedules(Semester, EnrollmentStatus);

-- Students table
CREATE TABLE Students (
  StudentID INTEGER PRIMARY KEY,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Email VARCHAR(255) UNIQUE NOT NULL,
  MajorID INTEGER NOT NULL,
  ConcentrationID INTEGER,
  GraduationTargetDate DATE,
  AcademicStanding TEXT CHECK(AcademicStanding IN ('Good Standing', 'Probation', 'Suspended')) NOT NULL,
  CumulativeGPA DECIMAL(3,2) DEFAULT 0.0,
  TotalCreditsEarned DECIMAL(5,1) DEFAULT 0,
  ClassificationID INTEGER NOT NULL,
  SISImportDate TIMESTAMP,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (MajorID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (ConcentrationID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (ClassificationID) REFERENCES Classification(ClassificationID)
);

CREATE INDEX idx_Students_Email ON Students(Email);
CREATE INDEX idx_Students_MajorID ON Students(MajorID);
CREATE INDEX idx_Students_ConcentrationID ON Students(ConcentrationID);
CREATE INDEX idx_Students_ClassificationID ON Students(ClassificationID);
CREATE INDEX idx_Students_AcademicStanding ON Students(AcademicStanding);
CREATE INDEX idx_Students_MajorID_AcademicStanding ON Students(MajorID, AcademicStanding);

-- Academic History table
CREATE TABLE AcademicHistory (
  HistoryID INTEGER PRIMARY KEY AUTOINCREMENT,
  StudentID INTEGER NOT NULL,
  CourseID INTEGER NOT NULL,
  ScheduleID INTEGER,
  Grade VARCHAR(5) NOT NULL,
  GradePoints DECIMAL(3,2) NOT NULL,
  TermCompleted VARCHAR(20) NOT NULL,
  CreditHoursEarned DECIMAL(3,1) NOT NULL,
  PassFail BOOLEAN DEFAULT 0,
  CompletionDate DATE NOT NULL,
  GradePointsContribution DECIMAL(5,2),
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
  FOREIGN KEY (ScheduleID) REFERENCES Schedules(ScheduleID)
);

CREATE INDEX idx_AcademicHistory_StudentID_CourseID_TermCompleted ON AcademicHistory(StudentID, CourseID, TermCompleted);
CREATE INDEX idx_AcademicHistory_StudentID ON AcademicHistory(StudentID);
CREATE INDEX idx_AcademicHistory_CourseID ON AcademicHistory(CourseID);
CREATE INDEX idx_AcademicHistory_TermCompleted ON AcademicHistory(TermCompleted);
CREATE INDEX idx_AcademicHistory_Grade ON AcademicHistory(Grade);

-- Student Preferences table
CREATE TABLE StudentPreferences (
  PreferenceID INTEGER PRIMARY KEY AUTOINCREMENT,
  StudentID INTEGER UNIQUE NOT NULL,
  AcademicGoals TEXT,
  CareerInterests VARCHAR(500),
  PreferredInstructionModeID INTEGER,
  PreferredStartTime TIME,
  PreferredEndTime TIME,
  PreferredDaysAvailable VARCHAR(20),
  PreferredDaysUnavailable VARCHAR(20),
  DifficultyPreference VARCHAR(50),
  WorkloadPreference TEXT CHECK(WorkloadPreference IN ('Light', 'Moderate', 'Heavy')),
  PreferredDepartments VARCHAR(500),
  NotificationPreferences JSON,
  ProfileCompleteness DECIMAL(3,0),
  LastUpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (PreferredInstructionModeID) REFERENCES InstructionModes(InstructionModeID)
);

CREATE INDEX idx_StudentPreferences_StudentID ON StudentPreferences(StudentID);
CREATE INDEX idx_StudentPreferences_PreferredInstructionModeID ON StudentPreferences(PreferredInstructionModeID);

-- ============================================================================
-- SUPPORTING FEATURE ENTITIES
-- ============================================================================

-- AI Agent Logs table
CREATE TABLE AIAgentLogs (
  LogID INTEGER PRIMARY KEY AUTOINCREMENT,
  AgentName VARCHAR(100) NOT NULL,
  StudentID INTEGER NOT NULL,
  ExecutionStartTime TIMESTAMP NOT NULL,
  ExecutionEndTime TIMESTAMP NOT NULL,
  ExecutionDurationMS INTEGER NOT NULL,
  InputParameters JSON NOT NULL,
  OutputData JSON NOT NULL,
  ErrorMessage TEXT,
  ExecutionStatus TEXT CHECK(ExecutionStatus IN ('Success', 'Error', 'Partial_Error')) NOT NULL,
  RecommendationCount INTEGER,
  QueryCount INTEGER,
  AIModelUsed VARCHAR(100),
  TokensUsed INTEGER,
  CostUSD DECIMAL(8,4),
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE INDEX idx_AIAgentLogs_StudentID ON AIAgentLogs(StudentID);
CREATE INDEX idx_AIAgentLogs_StudentID_ExecutionStartTime ON AIAgentLogs(StudentID, ExecutionStartTime);
CREATE INDEX idx_AIAgentLogs_AgentName ON AIAgentLogs(AgentName);
CREATE INDEX idx_AIAgentLogs_ExecutionStatus ON AIAgentLogs(ExecutionStatus);

-- Recommendations table
CREATE TABLE Recommendations (
  RecommendationID INTEGER PRIMARY KEY AUTOINCREMENT,
  StudentID INTEGER NOT NULL,
  CourseID INTEGER NOT NULL,
  ScheduleID INTEGER,
  Rank INTEGER NOT NULL,
  RelevanceScore DECIMAL(3,2) NOT NULL,
  RecommendationReason TEXT NOT NULL,
  AlignmentWithGoals VARCHAR(255),
  SkillDevelopment TEXT,
  CareerRelevance VARCHAR(255),
  PrerequisiteStatus TEXT CHECK(PrerequisiteStatus IN ('Met', 'Missing', 'Waiver_Pending', 'Alternative_Available')) NOT NULL,
  SuggestedPrerequisites VARCHAR(500),
  LogID INTEGER NOT NULL,
  GeneratedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ExpiryDate DATE,
  UserFeedback TEXT CHECK(UserFeedback IN ('Helpful', 'Not_Helpful', 'Ignored')),
  UserFeedbackDate TIMESTAMP,
  IsActive BOOLEAN DEFAULT 1,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
  FOREIGN KEY (ScheduleID) REFERENCES Schedules(ScheduleID),
  FOREIGN KEY (LogID) REFERENCES AIAgentLogs(LogID)
);

CREATE INDEX idx_Recommendations_StudentID ON Recommendations(StudentID);
CREATE INDEX idx_Recommendations_CourseID ON Recommendations(CourseID);
CREATE INDEX idx_Recommendations_StudentID_GeneratedDate ON Recommendations(StudentID, GeneratedDate);
CREATE INDEX idx_Recommendations_StudentID_IsActive ON Recommendations(StudentID, IsActive);
CREATE INDEX idx_Recommendations_Rank ON Recommendations(Rank);

-- Waivers table
CREATE TABLE Waivers (
  WaiverID INTEGER PRIMARY KEY AUTOINCREMENT,
  StudentID INTEGER NOT NULL,
  PrerequisiteID INTEGER NOT NULL,
  CourseID INTEGER NOT NULL,
  WaiverReason TEXT NOT NULL,
  SupportingDocumentation VARCHAR(255),
  RequestDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Status TEXT CHECK(Status IN ('Pending', 'Approved', 'Denied', 'Withdrawn')) NOT NULL,
  ApprovalDate TIMESTAMP,
  ApprovedByID INTEGER,
  ApprovedByName VARCHAR(255),
  ApprovalReason TEXT,
  ExpiryDate DATE,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (PrerequisiteID) REFERENCES Prerequisites(PrerequisiteID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE INDEX idx_Waivers_StudentID_CourseID_PrerequisiteID ON Waivers(StudentID, CourseID, PrerequisiteID);
CREATE INDEX idx_Waivers_StudentID ON Waivers(StudentID);
CREATE INDEX idx_Waivers_PrerequisiteID ON Waivers(PrerequisiteID);
CREATE INDEX idx_Waivers_Status ON Waivers(Status);
CREATE INDEX idx_Waivers_StudentID_Status ON Waivers(StudentID, Status);

-- ============================================================================
-- AUDIT/HISTORY ENTITIES
-- ============================================================================

-- Recommendation History table
CREATE TABLE RecommendationHistory (
  HistoryID INTEGER PRIMARY KEY AUTOINCREMENT,
  RecommendationID INTEGER NOT NULL,
  StudentID INTEGER NOT NULL,
  Action TEXT CHECK(Action IN ('Created', 'Updated', 'Accepted', 'Rejected', 'Expired')) NOT NULL,
  OldValues JSON,
  NewValues JSON,
  ChangeReason VARCHAR(255),
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (RecommendationID) REFERENCES Recommendations(RecommendationID),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE INDEX idx_RecommendationHistory_RecommendationID ON RecommendationHistory(RecommendationID);
CREATE INDEX idx_RecommendationHistory_StudentID ON RecommendationHistory(StudentID);
CREATE INDEX idx_RecommendationHistory_StudentID_CreatedDate ON RecommendationHistory(StudentID, CreatedDate);

-- Schedule History table
CREATE TABLE ScheduleHistory (
  HistoryID INTEGER PRIMARY KEY AUTOINCREMENT,
  ScheduleID INTEGER NOT NULL,
  Action TEXT CHECK(Action IN ('Created', 'Updated', 'Deleted', 'Enrollment_Changed')) NOT NULL,
  OldValues JSON,
  NewValues JSON,
  ChangeReason VARCHAR(255),
  ChangedByID INTEGER,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ScheduleID) REFERENCES Schedules(ScheduleID)
);

CREATE INDEX idx_ScheduleHistory_ScheduleID ON ScheduleHistory(ScheduleID);
CREATE INDEX idx_ScheduleHistory_ScheduleID_CreatedDate ON ScheduleHistory(ScheduleID, CreatedDate);

-- Waiver History table
CREATE TABLE WaiverHistory (
  HistoryID INTEGER PRIMARY KEY AUTOINCREMENT,
  WaiverID INTEGER NOT NULL,
  StatusChange VARCHAR(50) NOT NULL,
  PreviousStatus TEXT NOT NULL,
  NewStatus TEXT NOT NULL,
  ChangeReason VARCHAR(255),
  ChangedByID INTEGER,
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (WaiverID) REFERENCES Waivers(WaiverID)
);

CREATE INDEX idx_WaiverHistory_WaiverID ON WaiverHistory(WaiverID);
CREATE INDEX idx_WaiverHistory_WaiverID_CreatedDate ON WaiverHistory(WaiverID, CreatedDate);

-- Audit Log table (FERPA compliance)
CREATE TABLE AuditLog (
  AuditID INTEGER PRIMARY KEY AUTOINCREMENT,
  EntityType VARCHAR(100) NOT NULL,
  EntityID INTEGER NOT NULL,
  Action TEXT CHECK(Action IN ('Create', 'Read', 'Update', 'Delete')) NOT NULL,
  UserID INTEGER,
  UserType VARCHAR(50) NOT NULL,
  OldValues JSON,
  NewValues JSON,
  IPAddress VARCHAR(45),
  UserAgent VARCHAR(500),
  CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_AuditLog_EntityType ON AuditLog(EntityType);
CREATE INDEX idx_AuditLog_EntityID ON AuditLog(EntityID);
CREATE INDEX idx_AuditLog_UserID ON AuditLog(UserID);
CREATE INDEX idx_AuditLog_EntityType_EntityID ON AuditLog(EntityType, EntityID);
CREATE INDEX idx_AuditLog_UserID_CreatedDate ON AuditLog(UserID, CreatedDate);

-- ============================================================================
-- SYSTEM CONFIGURATION ENTITY
-- ============================================================================

-- System Configuration table
CREATE TABLE SystemConfiguration (
  ConfigID INTEGER PRIMARY KEY AUTOINCREMENT,
  ConfigKey VARCHAR(100) UNIQUE NOT NULL,
  ConfigValue VARCHAR(1000) NOT NULL,
  ConfigType VARCHAR(50) NOT NULL,
  Description TEXT,
  IsActive BOOLEAN DEFAULT 1,
  LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_SystemConfiguration_ConfigKey ON SystemConfiguration(ConfigKey);
CREATE INDEX idx_SystemConfiguration_IsActive ON SystemConfiguration(IsActive);

-- ============================================================================
-- SAMPLE REFERENCE DATA (Optional - Uncomment to populate)
-- ============================================================================

-- Insert sample departments
-- INSERT INTO Departments (DepartmentCode, DepartmentName, DepartmentType, IsActive)
-- VALUES
--   ('BUS', 'Business Administration', 'Major', 1),
--   ('FIN', 'Finance', 'Concentration', 1),
--   ('MKT', 'Marketing', 'Concentration', 1),
--   ('ACC', 'Accounting', 'Concentration', 1),
--   ('MGT', 'Management', 'Concentration', 1);

-- -- Insert sample difficulty levels
-- INSERT INTO DifficultyLevels (LevelCode, LevelName, DisplayOrder)
-- VALUES
--   ('INT', 'Introductory', 1),
--   ('INT', 'Intermediate', 2),
--   ('ADV', 'Advanced', 3);

-- -- Insert sample instruction modes
-- INSERT INTO InstructionModes (ModeCode, ModeName, DisplayOrder)
-- VALUES
--   ('INP', 'In-Person', 1),
--   ('ONL', 'Online', 2),
--   ('HYB', 'Hybrid', 3);

-- -- Insert sample classifications
-- INSERT INTO Classification (ClassificationCode, ClassificationName, MinCreditsRequired, MaxCreditsRequired, DisplayOrder)
-- VALUES
--   ('FR', 'Freshman', 0, 29, 1),
--   ('SO', 'Sophomore', 30, 59, 2),
--   ('JR', 'Junior', 60, 89, 3),
--   ('SR', 'Senior', 90, 999, 4);

-- ============================================================================
-- SCHEMA DOCUMENTATION
-- ============================================================================
-- 
-- FOREIGN KEY CONFIGURATION:
-- PRAGMA foreign_keys = ON must be enabled for referential integrity
-- 
-- AUDIT REQUIREMENTS:
-- - AuditLog tracks all CRUD operations for FERPA compliance
-- - History tables track entity lifecycle and changes
-- - All modifications timestamped automatically
-- 
-- AI AGENT INTEGRATION:
-- - AIAgentLogs track agent execution for debugging
-- - Recommendations include agent source and confidence
-- - Parameters/output stored as JSON for flexibility
-- 
-- PERFORMANCE OPTIMIZATION:
-- - Composite indexes on frequent query combinations
-- - Denormalized fields (CumulativeGPA, TotalCreditsEarned) for performance
-- - Time-based indexes for range queries
-- - Student/Course indexes for join operations
-- 
-- CORE ENTITIES (6):
-- 1. Courses - Course catalog (400-500 records)
-- 2. Prerequisites - Prerequisite relationships (1,200-1,500 records)
-- 3. Schedules - Course sections (2,000-3,000 records)
-- 4. Students - Student profiles (2,500-5,000 records)
-- 5. AcademicHistory - Enrollments (50,000-100,000 records)
-- 6. StudentPreferences - Goals/constraints (1,500-2,500 records)
-- 
-- SUPPORTING FEATURE ENTITIES (4):
-- 1. Recommendations - AI recommendations (20,000-50,000 records)
-- 2. Waivers - Waiver requests (100-500 records)
-- 3. AIAgentLogs - Agent execution logs (100,000-500,000 records)
-- 4. RecommendationHistory - Recommendation audit trail
-- 
-- REFERENCE ENTITIES (4):
-- 1. Departments - Department definitions (10-15 records)
-- 2. DifficultyLevels - Difficulty classes (3-5 records)
-- 3. InstructionModes - Delivery modes (3-5 records)
-- 4. Classification - Student year levels (4 records)
-- 
-- DATA TYPE MAPPINGS (SQLite):
-- - INTEGER PRIMARY KEY AUTOINCREMENT: ID generation
-- - TEXT with CHECK constraints: ENUM-like values
-- - DECIMAL(p,s): Stored as TEXT for precision
-- - JSON: Native SQLite JSON support (v3.9.0+)
-- - TIMESTAMP: TEXT ISO 8601 format with CURRENT_TIMESTAMP
-- - DATE: TEXT ISO 8601 format (YYYY-MM-DD)
-- - TIME: TEXT HH:MM:SS format
-- 
-- RELATIONSHIP CARDINALITY:
-- 1:1 - Unique foreign key (StudentPreferences → Students)
-- 1:M - Foreign key without unique constraint (Courses → Departments)
-- M:M - Supported through junction tables if needed
-- 
-- INDEXES:
-- - 60+ indexes defined across all tables
-- - Composite indexes on frequent query combinations
-- - Individual indexes on foreign keys for join performance
-- - Status and date-based indexes for filtering
-- 
-- CONSTRAINTS:
-- - PRIMARY KEY: Ensures unique row identification
-- - UNIQUE: Applied to business keys (CourseCode, Email, ConfigKey)
-- - NOT NULL: Enforced on critical required fields
-- - CHECK: Validates enum-like values and constraints
-- - FOREIGN KEY: Enforces referential integrity
-- 
-- NOTES FOR SQLITE:
-- - Foreign keys must be explicitly enabled: PRAGMA foreign_keys = ON;
-- - JSON functions available in SQLite 3.9.0+
-- - For older versions, store JSON as TEXT
-- - AUTOINCREMENT available but slower; use rowid for auto-increment
-- - No native enum type; use TEXT with CHECK constraints
-- - DECIMAL stored as TEXT to preserve precision; cast to REAL for math
-- 
-- END OF SCHEMA DEFINITION
