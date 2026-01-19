/* =============================================
   ITServiceFlow - ITSM Database
   DBMS: SQL Server
   ============================================= */

-- 1. TẠO DATABASE
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ITServiceFlowDB')
BEGIN
    CREATE DATABASE ITServiceFlowDB;
END
GO

USE ITServiceFlowDB;
GO

/* =============================================
   2. CORE SYSTEM (USERS & DEPARTMENTS)
   ============================================= */

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL
);

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Username NVARCHAR(50) UNIQUE,
    Role NVARCHAR(20) CHECK (Role IN ('EndUser','Agent','Manager','Admin','CAB')),
    DepartmentID INT,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Manager
FOREIGN KEY (ManagerID) REFERENCES Users(UserID);

GO

/* =============================================
   3. WORKFLOW & SLA
   ============================================= */

CREATE TABLE TicketStatuses (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL,
    IsFinal BIT DEFAULT 0
);

CREATE TABLE SLAPolicies (
    SLAID INT IDENTITY(1,1) PRIMARY KEY,
    PriorityLevel NVARCHAR(20),
    TargetResponseMinutes INT,
    TargetResolutionMinutes INT
);

GO

/* =============================================
   4. CMDB (ASSETS)
   ============================================= */

CREATE TABLE Assets (
    AssetID INT IDENTITY(1,1) PRIMARY KEY,
    AssetName NVARCHAR(100) NOT NULL,
    AssetTag NVARCHAR(50) UNIQUE,
    AssetType NVARCHAR(50),
    Status NVARCHAR(50),
    OwnerID INT,
    Description NVARCHAR(MAX),
    PurchaseDate DATE,
    ExpiryDate DATE,
    CONSTRAINT FK_Assets_Owner
        FOREIGN KEY (OwnerID) REFERENCES Users(UserID)
);

CREATE TABLE AssetRelationships (
    RelationshipID INT IDENTITY(1,1) PRIMARY KEY,
    ParentAssetID INT,
    ChildAssetID INT,
    RelationshipType NVARCHAR(50),
    CONSTRAINT FK_AssetRel_Parent FOREIGN KEY (ParentAssetID) REFERENCES Assets(AssetID),
    CONSTRAINT FK_AssetRel_Child FOREIGN KEY (ChildAssetID) REFERENCES Assets(AssetID)
);

GO

/* =============================================
   5. INCIDENT MANAGEMENT
   ============================================= */

CREATE TABLE Incidents (
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),

    RequesterID INT,
    AssigneeID INT,

    Category NVARCHAR(50),
    Impact INT,
    Urgency INT,
    Priority NVARCHAR(20),

    StatusID INT,
    AssetID INT,
    ParentIncidentID INT,

    SLAID INT,
    DueAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    ResolvedAt DATETIME,
    SLABreach BIT DEFAULT 0,

    CONSTRAINT FK_Incident_Requester FOREIGN KEY (RequesterID) REFERENCES Users(UserID),
    CONSTRAINT FK_Incident_Assignee FOREIGN KEY (AssigneeID) REFERENCES Users(UserID),
    CONSTRAINT FK_Incident_Status FOREIGN KEY (StatusID) REFERENCES TicketStatuses(StatusID),
    CONSTRAINT FK_Incident_Asset FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    CONSTRAINT FK_Incident_Parent FOREIGN KEY (ParentIncidentID) REFERENCES Incidents(IncidentID),
    CONSTRAINT FK_Incident_SLA FOREIGN KEY (SLAID) REFERENCES SLAPolicies(SLAID)
);

GO

/* =============================================
   6. SERVICE REQUEST
   ============================================= */

CREATE TABLE ServiceCatalog (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100),
    Description NVARCHAR(MAX),
    EstimatedCost DECIMAL(10,2),
    RequiresApproval BIT DEFAULT 0
);

CREATE TABLE ServiceRequests (
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceID INT,
    RequesterID INT,
    AssigneeID INT,
    StatusID INT,

    ApproverID INT,
    ApprovalStatus NVARCHAR(20) DEFAULT 'Pending',
    ApprovalDate DATETIME,

    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_SR_Service FOREIGN KEY (ServiceID) REFERENCES ServiceCatalog(ServiceID),
    CONSTRAINT FK_SR_Requester FOREIGN KEY (RequesterID) REFERENCES Users(UserID),
    CONSTRAINT FK_SR_Assignee FOREIGN KEY (AssigneeID) REFERENCES Users(UserID),
    CONSTRAINT FK_SR_Status FOREIGN KEY (StatusID) REFERENCES TicketStatuses(StatusID),
    CONSTRAINT FK_SR_Approver FOREIGN KEY (ApproverID) REFERENCES Users(UserID)
);

GO

/* =============================================
   7. PROBLEM & CHANGE MANAGEMENT
   ============================================= */

CREATE TABLE Problems (
    ProblemID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200),
    RootCauseAnalysis NVARCHAR(MAX),
    Workaround NVARCHAR(MAX),
    StatusID INT,
    CreatedBy INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Problem_Status FOREIGN KEY (StatusID) REFERENCES TicketStatuses(StatusID),
    CONSTRAINT FK_Problem_Creator FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

CREATE TABLE ProblemIncidentLinks (
    ProblemID INT,
    IncidentID INT,
    PRIMARY KEY (ProblemID, IncidentID),
    CONSTRAINT FK_PIL_Problem FOREIGN KEY (ProblemID) REFERENCES Problems(ProblemID),
    CONSTRAINT FK_PIL_Incident FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

CREATE TABLE ChangeRequests (
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200),
    Description NVARCHAR(MAX),
    AssetID INT,
    RiskLevel NVARCHAR(20),
    PlannedStart DATETIME,
    PlannedEnd DATETIME,
    StatusID INT,
    RequesterID INT,
    CABApproverID INT,
    CONSTRAINT FK_CR_Asset FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    CONSTRAINT FK_CR_Status FOREIGN KEY (StatusID) REFERENCES TicketStatuses(StatusID),
    CONSTRAINT FK_CR_Requester FOREIGN KEY (RequesterID) REFERENCES Users(UserID),
    CONSTRAINT FK_CR_CAB FOREIGN KEY (CABApproverID) REFERENCES Users(UserID)
);

GO

/* =============================================
   8. KNOWLEDGE BASE
   ============================================= */

CREATE TABLE KnowledgeArticles (
    ArticleID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Keywords NVARCHAR(200),
    AuthorID INT,
    IsPublished BIT DEFAULT 0,
    SourceTicketID INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_KA_Author FOREIGN KEY (AuthorID) REFERENCES Users(UserID)
);

GO

/* =============================================
   9. TRACKING, LOGS & AUDIT
   ============================================= */

CREATE TABLE TicketHistory (
    HistoryID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TicketType NVARCHAR(20),
    TicketID INT,
    ChangedBy INT,
    OldStatusID INT,
    NewStatusID INT,
    ChangeNote NVARCHAR(MAX),
    ChangedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_TH_User FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);

CREATE TABLE WorkLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentID INT,
    AgentID INT,
    TimeSpentMinutes INT,
    LoggedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_WL_Incident FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID),
    CONSTRAINT FK_WL_Agent FOREIGN KEY (AgentID) REFERENCES Users(UserID)
);

CREATE TABLE CustomerSurveys (
    SurveyID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Feedback NVARCHAR(MAX),
    SubmittedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_CS_Incident FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

CREATE TABLE AuditLogs (
    LogID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),
    RecordID INT,
    ActionType NVARCHAR(20),
    ChangedBy INT,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ChangeDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_AL_User FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);

GO

