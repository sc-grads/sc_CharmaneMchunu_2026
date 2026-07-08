IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('dbo.LeaveCategory')
    AND name = 'ModifiedDate'
)
BEGIN
    ALTER TABLE dbo.LeaveCategory ADD ModifiedDate DATETIME NULL;
    PRINT 'Added ModifiedDate to LeaveCategory.';
END
ELSE
    PRINT 'ModifiedDate already exists in LeaveCategory.';
GO

/* ============================================================
   2. EMPLOYEE TRIGGER (create if not exists)
============================================================ */
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Employee_Audit' AND parent_class_desc = 'OBJECT_OR_COLUMN')
BEGIN
    EXEC sp_executesql N'
        CREATE TRIGGER dbo.trg_Employee_Audit
        ON dbo.Employee
        AFTER UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @BatchID INT = -1;

            IF CONTEXT_INFO() IS NOT NULL AND CONTEXT_INFO() != 0x00000000
                SET @BatchID = CONVERT(INT, CONTEXT_INFO());

            UPDATE dbo.Employee
            SET ModifiedDate = GETDATE()
            FROM inserted i
            WHERE dbo.Employee.EmployeeID = i.EmployeeID;

            INSERT INTO dbo.AuditLog (BatchID, TableName, OperationType, StatusCode, RowsUpdated, HostName, ApplicationName, EventDateTime)
            SELECT
                @BatchID,
                ''Employee'',
                ''UPDATE'',
                ''SUCCESS'',
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
    ';
    PRINT 'Trigger trg_Employee_Audit created.';
END
ELSE
    PRINT 'Trigger trg_Employee_Audit already exists – skipped.';
GO

/* ============================================================
   3. TIMESHEET TRIGGER (create if not exists)
============================================================ */
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Timesheet_Audit' AND parent_class_desc = 'OBJECT_OR_COLUMN')
BEGIN
    EXEC sp_executesql N'
        CREATE TRIGGER dbo.trg_Timesheet_Audit
        ON dbo.Timesheet
        AFTER UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @BatchID INT = -1;

            IF CONTEXT_INFO() IS NOT NULL AND CONTEXT_INFO() != 0x00000000
                SET @BatchID = CONVERT(INT, CONTEXT_INFO());

            UPDATE dbo.Timesheet
            SET ModifiedDate = GETDATE()
            FROM inserted i
            WHERE dbo.Timesheet.TimesheetID = i.TimesheetID;

            INSERT INTO dbo.AuditLog (BatchID, TableName, OperationType, StatusCode, RowsUpdated, HostName, ApplicationName, EventDateTime)
            SELECT
                @BatchID,
                ''Timesheet'',
                ''UPDATE'',
                ''SUCCESS'',
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
    ';
    PRINT 'Trigger trg_Timesheet_Audit created.';
END
ELSE
    PRINT 'Trigger trg_Timesheet_Audit already exists – skipped.';
GO

/* ============================================================
   4. LEAVE TRIGGER (create if not exists)
============================================================ */
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Leave_Audit' AND parent_class_desc = 'OBJECT_OR_COLUMN')
BEGIN
    EXEC sp_executesql N'
        CREATE TRIGGER dbo.trg_Leave_Audit
        ON dbo.[Leave]
        AFTER UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @BatchID INT = -1;

            IF CONTEXT_INFO() IS NOT NULL AND CONTEXT_INFO() != 0x00000000
                SET @BatchID = CONVERT(INT, CONTEXT_INFO());

            UPDATE dbo.[Leave]
            SET ModifiedDate = GETDATE()
            FROM inserted i
            WHERE dbo.[Leave].LeaveID = i.LeaveID;

            INSERT INTO dbo.AuditLog (BatchID, TableName, OperationType, StatusCode, RowsUpdated, HostName, ApplicationName, EventDateTime)
            SELECT
                @BatchID,
                ''Leave'',
                ''UPDATE'',
                ''SUCCESS'',
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
    ';
    PRINT 'Trigger trg_Leave_Audit created.';
END
ELSE
    PRINT 'Trigger trg_Leave_Audit already exists – skipped.';
GO

/* ============================================================
   5. LEAVE CATEGORY TRIGGER (create if not exists)
============================================================ */
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_LeaveCategory_Audit' AND parent_class_desc = 'OBJECT_OR_COLUMN')
BEGIN
    EXEC sp_executesql N'
        CREATE TRIGGER dbo.trg_LeaveCategory_Audit
        ON dbo.LeaveCategory
        AFTER UPDATE
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @BatchID INT = -1;

            IF CONTEXT_INFO() IS NOT NULL AND CONTEXT_INFO() != 0x00000000
                SET @BatchID = CONVERT(INT, CONTEXT_INFO());

            UPDATE dbo.LeaveCategory
            SET ModifiedDate = GETDATE()
            FROM inserted i
            WHERE dbo.LeaveCategory.LeaveCategoryID = i.LeaveCategoryID;

            INSERT INTO dbo.AuditLog (BatchID, TableName, OperationType, StatusCode, RowsUpdated, HostName, ApplicationName, EventDateTime)
            SELECT
                @BatchID,
                ''LeaveCategory'',
                ''UPDATE'',
                ''SUCCESS'',
                COUNT(*),
                HOST_NAME(),
                APP_NAME(),
                GETDATE()
            FROM inserted;
        END
    ';
    PRINT 'Trigger trg_LeaveCategory_Audit created.';
END
ELSE
    PRINT 'Trigger trg_LeaveCategory_Audit already exists – skipped.';
GO
