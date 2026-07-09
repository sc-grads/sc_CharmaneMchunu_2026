-- 02_DeploySchema.sql
USE TimesheetCMDB;
GO

/* =========================
   EMPLOYEE
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Employee')
BEGIN
    CREATE TABLE dbo.Employee (
        EmployeeID INT IDENTITY(1001,1) PRIMARY KEY,
        EmployeeName NVARCHAR(100) NOT NULL,
        EmployeeSurname NVARCHAR(100) NOT NULL,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL
    );
END
GO

/* =========================
   CLIENT
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Client')
BEGIN
    CREATE TABLE dbo.Client (
        ClientID INT IDENTITY(1,1) PRIMARY KEY,
        ClientName NVARCHAR(200) NOT NULL,
        ClientCode NVARCHAR(50),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL
    );
END
GO

/* =========================
   STAGING
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'StagingTimesheet')
BEGIN
    CREATE TABLE dbo.StagingTimesheet (
        StagingID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        Date NVARCHAR(255),
        DayOfWeek NVARCHAR(255),
        Client NVARCHAR(255),
        ProjectName NVARCHAR(255),
        Description NVARCHAR(MAX),
        BillableType NVARCHAR(255),
        Comments NVARCHAR(MAX),
        TotalHours NVARCHAR(255),
        StartTime NVARCHAR(255),
        EndTime NVARCHAR(255),
        IsLeave NVARCHAR(255),
        LeaveType NVARCHAR(255),
        Month NVARCHAR(255),
        SourceFile NVARCHAR(255),
        LoadDate DATETIME DEFAULT GETDATE(),
        IsProcessed BIT DEFAULT 0,
        ProcessedDate DATETIME NULL,
        BatchID INT NULL
    );
END
GO

/* =========================
   TIMESHEET
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Timesheet')
BEGIN
    CREATE TABLE dbo.Timesheet (
        TimesheetID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        ClientID INT NULL,
        Date DATE NOT NULL,
        DayOfWeek NVARCHAR(50),
        Description NVARCHAR(2000),
        BillableType NVARCHAR(50),
        Duration NVARCHAR(20),
        StartTime TIME,
        EndTime TIME,
        Comments NVARCHAR(2000),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL,

        CONSTRAINT FK_Timesheet_Employee
            FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID),

        CONSTRAINT FK_Timesheet_Client
            FOREIGN KEY (ClientID) REFERENCES dbo.Client(ClientID)
    );
END
GO

/* =========================
   LEAVE (reserved word)
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Leave')
BEGIN
    CREATE TABLE dbo.[Leave] (
        LeaveID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        LeaveType NVARCHAR(50),
        StartDate DATE,
        EndDate DATE,
        LeaveDays DECIMAL(10,2),
        Comments NVARCHAR(500),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL
    );
END
GO

/* =========================
   LEAVE CATEGORY
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'LeaveCategory')
BEGIN
    CREATE TABLE dbo.LeaveCategory (
        LeaveCategoryID INT IDENTITY(1,1) PRIMARY KEY,
        SourceText NVARCHAR(200) NOT NULL,
        LeaveType NVARCHAR(50) NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END
GO

/* =========================
   AUDIT STATUS CODE
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditStatusCode')
BEGIN
    CREATE TABLE dbo.AuditStatusCode (
        StatusCode NVARCHAR(20) PRIMARY KEY,
        StatusName NVARCHAR(50) NOT NULL,
        Description NVARCHAR(255),
        IsSuccess BIT DEFAULT 0,
        IsError BIT DEFAULT 0,
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END
GO

/* =========================
   AUDIT LOG
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    CREATE TABLE dbo.AuditLog (
        AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT,
        TableName NVARCHAR(128),
        OperationType NVARCHAR(20),
        StatusCode NVARCHAR(20),
        RowsInserted INT DEFAULT 0,
        RowsUpdated INT DEFAULT 0,
        RowsDeleted INT DEFAULT 0,
        HostName NVARCHAR(255),
        ApplicationName NVARCHAR(255),
        EventDateTime DATETIME DEFAULT GETDATE(),
        ErrorMessage NVARCHAR(MAX)
    );
END
GO

/* =========================
   SEQUENCE
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name = 'BatchIDSequence')
BEGIN
    CREATE SEQUENCE dbo.BatchIDSequence
    START WITH 1 INCREMENT BY 1;
END
GO

/* =========================
   INDEXES
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheet_EmployeeID')
    CREATE NONCLUSTERED INDEX IX_Timesheet_EmployeeID ON dbo.Timesheet(EmployeeID);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheet_Date')
    CREATE NONCLUSTERED INDEX IX_Timesheet_Date ON dbo.Timesheet(Date);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditLog_BatchID')
    CREATE NONCLUSTERED INDEX IX_AuditLog_BatchID ON dbo.AuditLog(BatchID);
GO
