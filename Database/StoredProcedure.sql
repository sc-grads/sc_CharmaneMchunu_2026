USE [TimesheetDB]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

DROP PROCEDURE IF EXISTS [dbo].[spRunTimesheetMigration]
GO

CREATE PROCEDURE [dbo].[spRunTimesheetMigration]
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