-- =============================================
-- CREATE DATABASE IF NOT EXISTS
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TimesheetDB')
BEGIN
    CREATE DATABASE TimesheetDB;
    PRINT 'Database TimesheetDB created.';
END
ELSE
    PRINT 'Database TimesheetDB already exists.';
GO

USE TimesheetDB;
GO

-- =============================================
-- TABLES
-- =============================================

-- Employee
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
    PRINT 'Employee table created.';
END
ELSE
    PRINT 'Employee table already exists.';
GO

-- Client
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
    PRINT 'Client table created.';
END
ELSE
    PRINT 'Client table already exists.';
GO

-- LeaveCategory
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'LeaveCategory')
BEGIN
    CREATE TABLE dbo.LeaveCategory (
        LeaveCategoryID INT IDENTITY(1,1) PRIMARY KEY,
        SourceText NVARCHAR(100) NOT NULL,
        LeaveType NVARCHAR(50) NOT NULL,
        IsActive BIT DEFAULT 1
    );
    PRINT 'LeaveCategory table created.';
END
ELSE
    PRINT 'LeaveCategory table already exists.';
GO

-- StagingTimesheet
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
    PRINT 'StagingTimesheet table created.';
END
ELSE
    PRINT 'StagingTimesheet table already exists.';
GO

-- Timesheet
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Timesheet')
BEGIN
    CREATE TABLE dbo.Timesheet (
        TimesheetID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        ClientID INT NULL,
        Date DATE NOT NULL,
        DayOfWeek NVARCHAR(50) NULL,
        Description NVARCHAR(2000) NULL,
        BillableType NVARCHAR(50) NULL,
        Duration NVARCHAR(20) NULL,
        StartTime TIME NULL,
        EndTime TIME NULL,
        Comments NVARCHAR(2000) NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL,
        
        CONSTRAINT FK_Timesheet_Employee 
            FOREIGN KEY (EmployeeID) 
            REFERENCES dbo.Employee(EmployeeID),
        
        CONSTRAINT FK_Timesheet_Client 
            FOREIGN KEY (ClientID) 
            REFERENCES dbo.Client(ClientID)
    );
    PRINT 'Timesheet table created.';
END
ELSE
    PRINT 'Timesheet table already exists.';
GO

-- Leave
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Leave')
BEGIN
    CREATE TABLE dbo.Leave (
        LeaveID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        LeaveType NVARCHAR(50) NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        LeaveDays DECIMAL(10,2) NOT NULL,
        Comments NVARCHAR(500),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL,
        
        CONSTRAINT FK_Leave_Employee 
            FOREIGN KEY (EmployeeID) 
            REFERENCES dbo.Employee(EmployeeID)
    );
    PRINT 'Leave table created.';
END
ELSE
    PRINT 'Leave table already exists.';
GO


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditStatusCode')
BEGIN
    CREATE TABLE dbo.AuditStatusCode (
        StatusID INT IDENTITY(1,1) PRIMARY KEY,
        StatusCode NVARCHAR(20) UNIQUE NOT NULL,
        StatusName NVARCHAR(50) NOT NULL,
        Description NVARCHAR(200),
        IsSuccess BIT DEFAULT 0,
        IsError BIT DEFAULT 0,
        IsActive BIT DEFAULT 1
    );
    PRINT 'AuditStatusCode table created.';
END
ELSE
    PRINT 'AuditStatusCode table already exists.';
GO

-- AuditLog (simplified version – only the columns you want)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    CREATE TABLE dbo.AuditLog (
        AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL,
        TableName NVARCHAR(128) NOT NULL,
        OperationType NVARCHAR(20) NOT NULL,
        StatusCode NVARCHAR(20) DEFAULT 'SUCCESS',
        RowsInserted INT DEFAULT 0,
        RowsUpdated INT DEFAULT 0,
        RowsDeleted INT DEFAULT 0,
        HostName NVARCHAR(255) NULL,
        ApplicationName NVARCHAR(255) NULL,
        EventDateTime DATETIME NOT NULL DEFAULT GETDATE(),
        ErrorMessage NVARCHAR(MAX) NULL
    );
    PRINT 'AuditLog table created (simplified).';
END
ELSE
    PRINT 'AuditLog table already exists.';
GO

-- =============================================
-- INDEXES
-- =============================================
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_StagingTimesheet_IsProcessed' AND object_id = OBJECT_ID('StagingTimesheet'))
    CREATE NONCLUSTERED INDEX IX_StagingTimesheet_IsProcessed ON dbo.StagingTimesheet(IsProcessed);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheet_EmployeeID' AND object_id = OBJECT_ID('Timesheet'))
    CREATE NONCLUSTERED INDEX IX_Timesheet_EmployeeID ON dbo.Timesheet(EmployeeID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheet_Date' AND object_id = OBJECT_ID('Timesheet'))
    CREATE NONCLUSTERED INDEX IX_Timesheet_Date ON dbo.Timesheet(Date);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheet_ClientID' AND object_id = OBJECT_ID('Timesheet'))
    CREATE NONCLUSTERED INDEX IX_Timesheet_ClientID ON dbo.Timesheet(ClientID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Leave_EmployeeID' AND object_id = OBJECT_ID('Leave'))
    CREATE NONCLUSTERED INDEX IX_Leave_EmployeeID ON dbo.Leave(EmployeeID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditLog_BatchID' AND object_id = OBJECT_ID('AuditLog'))
    CREATE NONCLUSTERED INDEX IX_AuditLog_BatchID ON dbo.AuditLog(BatchID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditLog_EventDateTime' AND object_id = OBJECT_ID('AuditLog'))
    CREATE NONCLUSTERED INDEX IX_AuditLog_EventDateTime ON dbo.AuditLog(EventDateTime);
PRINT 'Indexes verified/created.';
GO

-- =============================================
-- STATIC DATA
-- =============================================

-- Employees
IF NOT EXISTS (SELECT 1 FROM dbo.Employee)
BEGIN
    INSERT INTO dbo.Employee (EmployeeName, EmployeeSurname, IsActive)
    VALUES 
        ('Buhle', 'Mukhuba', 1),
        ('Charmane', 'Mchunu', 1),
        ('Jabulane', 'Poulo', 1),
        ('Kayden', 'Padayachee', 1),
        ('Lwazisile', 'Mhlambi', 1),
        ('Rushil', 'Jivan', 1),
        ('Shriya', 'Hariparsad', 1),
        ('Teolan', 'Govender', 1);
    PRINT 'Employees inserted.';
END
ELSE
    PRINT 'Employees already exist.';
GO

-- Clients
IF NOT EXISTS (SELECT 1 FROM dbo.Client)
BEGIN
    INSERT INTO dbo.Client (ClientName, ClientCode, IsActive)
    VALUES 
        ('Internal Sambe', 'INT001', 1),
        ('ADVTech', 'ADV001', 1),
        ('AFA Sasfin', 'AFA001', 1),
        ('Artist Proof Studio', 'ART001', 1),
        ('Assimil8', 'ASS001', 1),
        ('Base 3', 'BAS001', 1),
        ('Blue Legacy', 'BLU001', 1),
        ('C. Steinweg', 'CST001', 1),
        ('Conekt – Aurum', 'CON001', 1),
        ('Conekt – Clientele', 'CON002', 1),
        ('Conekt – Internal Meeting', 'CON003', 1),
        ('Conekt – Meridian', 'CON004', 1),
        ('Conekt – Winning Business', 'CON005', 1),
        ('Conekt AGSA SharePoint', 'CON006', 1),
        ('Dentons', 'DEN001', 1),
        ('Discovery', 'DIS001', 1),
        ('Discovery Bank', 'DIS002', 1),
        ('Discovery CRES', 'DIS003', 1),
        ('Discovery CSI', 'DIS004', 1),
        ('Discovery Health', 'DIS005', 1),
        ('Discovery Information Governance and Security', 'DIS006', 1),
        ('Discovery Innovation Lab', 'DIS007', 1),
        ('Discovery People', 'DIS008', 1),
        ('Discovery Skills', 'DIS009', 1),
        ('Discovery Vitality', 'DIS010', 1),
        ('Gyro', 'GYR001', 1),
        ('KFC Digistics', 'KFC001', 1),
        ('Life Healthcare', 'LIF001', 1),
        ('Medi-Charge', 'MED001', 1),
        ('MICA Build', 'MIC001', 1),
        ('Michelin', 'MIE001', 1),
        ('Mistro Foods', 'MIS001', 1),
        ('OK Furnitures', 'OKF001', 1),
        ('Olympic Paints', 'OLY001', 1),
        ('RMB', 'RMB001', 1),
        ('RMB CM Data Warehouse support', 'RMB002', 1),
        ('RMB CORE NRTI', 'RMB003', 1),
        ('RMB Tumelo', 'RMB004', 1),
        ('Sachar Mobile', 'SAC001', 1),
        ('Sanlam', 'SAN001', 1),
        ('SBV', 'SBV001', 1),
        ('Sibanya', 'SIB001', 1),
        ('Transport Holdings', 'TRA001', 1);
    PRINT 'Clients inserted.';
END
ELSE
    PRINT 'Clients already exist.';
GO

-- AuditStatusCode
IF NOT EXISTS (SELECT 1 FROM dbo.AuditStatusCode)
BEGIN
    INSERT INTO dbo.AuditStatusCode (StatusCode, StatusName, Description, IsSuccess, IsError)
    VALUES 
        ('SUCCESS', 'Success', 'Operation completed successfully', 1, 0),
        ('FAILED', 'Failed', 'Operation failed', 0, 1),
        ('RUNNING', 'Running', 'Operation is in progress', 0, 0),
        ('WARNING', 'Warning', 'Operation completed with warnings', 0, 0),
        ('SKIPPED', 'Skipped', 'Operation was skipped', 0, 0);
    PRINT 'AuditStatusCode populated.';
END
ELSE
    PRINT 'AuditStatusCode already populated.';
GO

-- LeaveCategory
IF NOT EXISTS (SELECT 1 FROM dbo.LeaveCategory)
BEGIN
    INSERT INTO dbo.LeaveCategory (SourceText, LeaveType)
    VALUES 
        ('Annual Leave', 'Annual Leave'),
        ('Sick Leave', 'Sick Leave'),
        ('Sick Leave - half day', 'Sick Leave'),
        ('Study Leave', 'Study Leave'),
        ('Maternity Leave', 'Maternity Leave'),
        ('Paternity Leave', 'Paternity Leave'),
        ('Family Responsibility Leave', 'Family Responsibility Leave'),
        ('Public Holiday', 'Public Holiday'),
        ('Unpaid Leave', 'Unpaid Leave'),
        ('Bereavement Leave', 'Bereavement Leave');
    PRINT 'LeaveCategory populated.';
END
ELSE
    PRINT 'LeaveCategory already populated.';
GO

-- =============================================
-- SEQUENCE
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = 'BatchIDSequence')
BEGIN
    CREATE SEQUENCE dbo.BatchIDSequence START WITH 1 INCREMENT BY 1;
    PRINT 'BatchIDSequence created.';
END
ELSE
    PRINT 'BatchIDSequence already exists.';
GO

-- =============================================
-- TRIGGERS (simplified to use only AuditLog columns)
-- =============================================

-- Trigger 1: StagingTimesheet Update Audit
DROP TRIGGER IF EXISTS dbo.trg_StagingTimesheet_UpdateAudit;
GO

CREATE TRIGGER dbo.trg_StagingTimesheet_UpdateAudit
ON dbo.StagingTimesheet
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchID INT;
    DECLARE @ContextInfo VARBINARY(128) = CONTEXT_INFO();
    
    IF @ContextInfo IS NOT NULL AND @ContextInfo != 0x00000000
        SET @BatchID = CONVERT(INT, @ContextInfo);
    ELSE
    BEGIN
        SELECT TOP 1 @BatchID = BatchID
        FROM dbo.AuditLog
        WHERE TableName = 'ETL_Process' 
          AND OperationType = 'START'
          AND StatusCode = 'RUNNING'
        ORDER BY AuditID DESC;
    END
    
    IF @BatchID IS NULL OR @BatchID = 0
        SET @BatchID = -1;
    
    BEGIN TRY
        IF UPDATE(IsProcessed)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT 
                @BatchID,
                'StagingTimesheet',
                'UPDATE',
                'SUCCESS',
                0,
                1,
                0,
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted i
            WHERE i.IsProcessed = 1;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime, ErrorMessage
        )
        VALUES (
            @BatchID,
            'StagingTimesheet',
            'TRIGGER_ERROR',
            'FAILED',
            0, 0, 0,
            HOST_NAME(),
            APP_NAME(),
            GETDATE(),
            ERROR_MESSAGE()
        );
    END CATCH
END;
GO

PRINT 'trg_StagingTimesheet_UpdateAudit created (simplified).';
GO

-- Trigger 2: Timesheet Audit
DROP TRIGGER IF EXISTS dbo.trg_Timesheet_Audit;
GO

CREATE TRIGGER dbo.trg_Timesheet_Audit
ON dbo.Timesheet
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchID INT;
    DECLARE @ContextInfo VARBINARY(128) = CONTEXT_INFO();
    
    IF @ContextInfo IS NOT NULL AND @ContextInfo != 0x00000000
        SET @BatchID = CONVERT(INT, @ContextInfo);
    ELSE
    BEGIN
        SELECT TOP 1 @BatchID = BatchID
        FROM dbo.AuditLog
        WHERE TableName = 'ETL_Process' 
          AND OperationType = 'START'
          AND StatusCode = 'RUNNING'
        ORDER BY AuditID DESC;
    END
    
    IF @BatchID IS NULL OR @BatchID = 0
        SET @BatchID = -1;
    
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Timesheet',
                'INSERT',
                'SUCCESS',
                COUNT(*),
                0,
                0,
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
        
        IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Timesheet',
                'UPDATE',
                'SUCCESS',
                0,
                COUNT(*),
                0,
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
        
        IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Timesheet',
                'DELETE',
                'SUCCESS',
                0,
                0,
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM deleted;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime, ErrorMessage
        )
        VALUES (
            @BatchID,
            'Timesheet',
            'TRIGGER_ERROR',
            'FAILED',
            0, 0, 0,
            HOST_NAME(),
            APP_NAME(),
            GETDATE(),
            ERROR_MESSAGE()
        );
    END CATCH
END;
GO

PRINT 'trg_Timesheet_Audit created (simplified).';
GO

-- Trigger 3: Leave Audit
DROP TRIGGER IF EXISTS dbo.trg_Leave_Audit;
GO

CREATE TRIGGER dbo.trg_Leave_Audit
ON dbo.Leave
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchID INT;
    DECLARE @ContextInfo VARBINARY(128) = CONTEXT_INFO();
    
    IF @ContextInfo IS NOT NULL AND @ContextInfo != 0x00000000
        SET @BatchID = CONVERT(INT, @ContextInfo);
    ELSE
    BEGIN
        SELECT TOP 1 @BatchID = BatchID
        FROM dbo.AuditLog
        WHERE TableName = 'ETL_Process' 
          AND OperationType = 'START'
          AND StatusCode = 'RUNNING'
        ORDER BY AuditID DESC;
    END
    
    IF @BatchID IS NULL OR @BatchID = 0
        SET @BatchID = -1;
    
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Leave',
                'INSERT',
                'SUCCESS',
                COUNT(*),
                0,
                0,
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
        
        IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Leave',
                'UPDATE',
                'SUCCESS',
                0,
                COUNT(*),
                0,
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
        
        IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        BEGIN
            INSERT INTO dbo.AuditLog (
                BatchID, TableName, OperationType, StatusCode,
                RowsInserted, RowsUpdated, RowsDeleted,
                HostName, ApplicationName, EventDateTime
            )
            SELECT
                @BatchID,
                'Leave',
                'DELETE',
                'SUCCESS',
                0,
                0,
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM deleted;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime, ErrorMessage
        )
        VALUES (
            @BatchID,
            'Leave',
            'TRIGGER_ERROR',
            'FAILED',
            0, 0, 0,
            HOST_NAME(),
            APP_NAME(),
            GETDATE(),
            ERROR_MESSAGE()
        );
    END CATCH
END;
GO

PRINT 'trg_Leave_Audit created (simplified).';
GO

-- =============================================
-- STORED PROCEDURE: spRunTimesheetMigration
-- (unchanged – already uses simple AuditLog columns)
-- =============================================
IF OBJECT_ID('spRunTimesheetMigration', 'P') IS NOT NULL
    DROP PROCEDURE spRunTimesheetMigration;
GO

CREATE PROCEDURE spRunTimesheetMigration
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @BatchID INT;
    DECLARE @TotalStagingRecords INT;
    DECLARE @InsertedTimesheet INT = 0;
    DECLARE @InsertedLeave INT = 0;
    DECLARE @UpdatedStaging INT = 0;
    DECLARE @DeletedTimesheet INT = 0;
    DECLARE @DeletedLeave INT = 0;
    DECLARE @ErrorMsg NVARCHAR(MAX);
    DECLARE @LockResult INT;

    -- Guard: only if new data
    IF NOT EXISTS (SELECT 1 FROM dbo.StagingTimesheet WHERE IsProcessed = 0)
    BEGIN
        SELECT 0 AS ExitCode, 'SUCCESS - No new data to process' AS Status;
        RETURN;
    END

    -- Prevent overlapping runs
    EXEC @LockResult = sp_getapplock
        @Resource = 'TimesheetMigrationLock',
        @LockMode = 'Exclusive',
        @LockOwner = 'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
    BEGIN
        SELECT 1 AS ExitCode, 'ERROR - Migration already in progress' AS Status;
        RETURN;
    END

    BEGIN TRY

        SELECT @TotalStagingRecords = COUNT(*)
        FROM dbo.StagingTimesheet
        WHERE IsProcessed = 0;

        SET @BatchID = NEXT VALUE FOR dbo.BatchIDSequence;

        -- LOG START
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime
        )
        VALUES (
            @BatchID, 'Migration', 'START', 'RUNNING',
            0, 0, 0,
            HOST_NAME(), 'Scheduler', GETDATE()
        );

        -- DELETE existing data
        DELETE FROM dbo.Timesheet;
        SET @DeletedTimesheet = @@ROWCOUNT;

        DELETE FROM dbo.[Leave];
        SET @DeletedLeave = @@ROWCOUNT;

        -- INSERT Timesheet
        INSERT INTO dbo.Timesheet (
            EmployeeID, ClientID, Date, DayOfWeek,
            Description, BillableType, Duration,
            StartTime, EndTime, Comments, CreatedDate, ModifiedDate
        )
        SELECT DISTINCT
            s.EmployeeID,
            c.ClientID,
            TRY_CAST(s.Date AS DATE) AS Date,
            s.DayOfWeek,
            NULLIF(s.Description, '') AS Description,
            NULLIF(s.BillableType, '') AS BillableType,
            NULLIF(s.TotalHours, '') AS Duration,
            TRY_CAST(s.StartTime AS TIME) AS StartTime,
            TRY_CAST(s.EndTime AS TIME) AS EndTime,
            NULLIF(s.Comments, '') AS Comments,
            GETDATE() AS CreatedDate,
            NULL AS ModifiedDate
        FROM dbo.StagingTimesheet s
        LEFT JOIN dbo.Client c ON c.ClientName = s.Client
        WHERE s.IsProcessed = 0
          AND TRY_CAST(s.Date AS DATE) IS NOT NULL
          AND UPPER(LTRIM(RTRIM(s.DayOfWeek))) NOT IN ('SATURDAY', 'SUNDAY')
          AND NOT EXISTS (
              SELECT 1
              FROM dbo.LeaveCategory lc
              WHERE UPPER(LTRIM(RTRIM(s.Description))) = UPPER(LTRIM(RTRIM(lc.SourceText)))
                AND lc.LeaveType NOT IN ('Public Holiday', 'Family Responsibility Leave')
          );

        SET @InsertedTimesheet = @@ROWCOUNT;

        -- INSERT Leave
        INSERT INTO dbo.[Leave] (
            EmployeeID, LeaveType, StartDate, EndDate, LeaveDays,
            Comments, CreatedDate, ModifiedDate
        )
        SELECT DISTINCT
            s.EmployeeID,
            lc.LeaveType,
            TRY_CAST(s.Date AS DATE) AS StartDate,
            TRY_CAST(s.Date AS DATE) AS EndDate,
            COALESCE(TRY_CAST(s.TotalHours AS DECIMAL(10,2)), 1) AS LeaveDays,
            NULLIF(s.Comments, '') AS Comments,
            GETDATE() AS CreatedDate,
            NULL AS ModifiedDate
        FROM dbo.StagingTimesheet s
        INNER JOIN dbo.LeaveCategory lc
            ON UPPER(LTRIM(RTRIM(s.Description))) = UPPER(LTRIM(RTRIM(lc.SourceText)))
        WHERE s.IsProcessed = 0
          AND TRY_CAST(s.Date AS DATE) IS NOT NULL
          AND lc.LeaveType NOT IN ('Public Holiday', 'Family Responsibility Leave');

        SET @InsertedLeave = @@ROWCOUNT;

        -- Mark staging as processed
        UPDATE dbo.StagingTimesheet
        SET IsProcessed = 1,
            ProcessedDate = GETDATE(),
            BatchID = @BatchID
        WHERE IsProcessed = 0;

        SET @UpdatedStaging = @@ROWCOUNT;

        -- LOG COMPLETE
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime
        )
        VALUES (
            @BatchID, 'Migration', 'COMPLETE', 'SUCCESS',
            @InsertedTimesheet + @InsertedLeave,
            @UpdatedStaging,
            @DeletedTimesheet + @DeletedLeave,
            HOST_NAME(), 'Scheduler', GETDATE()
        );

        EXEC sp_releaseapplock @Resource = 'TimesheetMigrationLock', @LockOwner = 'Session';

        SELECT 0 AS ExitCode, 'SUCCESS' AS Status;

    END TRY
    BEGIN CATCH

        SET @ErrorMsg = ERROR_MESSAGE();

        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime, ErrorMessage
        )
        VALUES (
            @BatchID, 'Migration', 'ERROR', 'FAILED',
            0, 0, 0,
            HOST_NAME(), 'Scheduler', GETDATE(), @ErrorMsg
        );

        EXEC sp_releaseapplock @Resource = 'TimesheetMigrationLock', @LockOwner = 'Session';

        SELECT 1 AS ExitCode, @ErrorMsg AS Status;

    END CATCH
END;
GO

PRINT 'Stored procedure spRunTimesheetMigration created.';
GO

-- =============================================
-- FINAL VERIFICATION
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'DEPLOYMENT COMPLETE - VERIFICATION';
PRINT '========================================';

SELECT 'Tables' AS ObjectType, COUNT(*) AS Count FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo')
UNION ALL
SELECT 'Indexes', COUNT(*) FROM sys.indexes WHERE object_id IN (SELECT object_id FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo')) AND index_id > 0
UNION ALL
SELECT 'Stored Procedures', COUNT(*) FROM sys.objects WHERE type = 'P' AND schema_id = SCHEMA_ID('dbo')
UNION ALL
SELECT 'Sequences', COUNT(*) FROM sys.sequences
UNION ALL
SELECT 'Triggers', COUNT(*) FROM sys.triggers WHERE parent_class = 0 AND name LIKE 'trg_%Audit%';

PRINT '';
PRINT '========================================';
PRINT 'ALL OBJECTS VERIFIED.';
PRINT '========================================';
GO