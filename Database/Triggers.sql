USE TimesheetDB;
GO

/* ============================================================
   1. LeaveCategory column fix
============================================================ */
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('dbo.LeaveCategory')
    AND name = 'ModifiedDate'
)
BEGIN
    ALTER TABLE dbo.LeaveCategory ADD ModifiedDate DATETIME NULL;
END
GO

/* ============================================================
   2. EMPLOYEE TRIGGER
============================================================ */
DROP TRIGGER IF EXISTS dbo.trg_Employee_Audit;
GO

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
        'Employee',
        'UPDATE',
        'SUCCESS',
        COUNT(*),
        HOST_NAME(),
        APP_NAME(),
        GETDATE()
    FROM inserted;
END
GO

/* ============================================================
   3. TIMESHEET TRIGGER
============================================================ */
DROP TRIGGER IF EXISTS dbo.trg_Timesheet_Audit;
GO

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
        'Timesheet',
        'UPDATE',
        'SUCCESS',
        COUNT(*),
        HOST_NAME(),
        APP_NAME(),
        GETDATE()
    FROM inserted;
END
GO

/* ============================================================
   4. LEAVE TRIGGER
============================================================ */
DROP TRIGGER IF EXISTS dbo.trg_Leave_Audit;
GO

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
        'Leave',
        'UPDATE',
        'SUCCESS',
        COUNT(*),
        HOST_NAME(),
        APP_NAME(),
        GETDATE()
    FROM inserted;
END
GO

/* ============================================================
   5. LEAVE CATEGORY TRIGGER
============================================================ */
DROP TRIGGER IF EXISTS dbo.trg_LeaveCategory_Audit;
GO

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
        'LeaveCategory',
        'UPDATE',
        'SUCCESS',
        COUNT(*),
        HOST_NAME(),
        APP_NAME(),
        GETDATE()
    FROM inserted;
END
GO

/* ============================================================
   6. VERIFY
============================================================ */
SELECT
    t.name AS TriggerName,
    OBJECT_NAME(t.parent_id) AS TableName,
    CASE WHEN t.is_disabled = 0 THEN 'ACTIVE' ELSE 'DISABLED' END AS Status
FROM sys.triggers t
WHERE t.parent_class = 0
AND t.name LIKE 'trg_%_Audit'
ORDER BY TableName;
GO