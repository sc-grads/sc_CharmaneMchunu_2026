USE TimesheetDB;
GO

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
    DECLARE @StatusMessage NVARCHAR(500);
    DECLARE @ErrorMsg NVARCHAR(MAX);

    BEGIN TRY

        -- 1. Get total unprocessed records
        SELECT @TotalStagingRecords = COUNT(*)
        FROM dbo.StagingTimesheet
        WHERE IsProcessed = 0;

        -- 2. Generate a new BatchID (requires a sequence named BatchIDSequence)
        SET @BatchID = NEXT VALUE FOR dbo.BatchIDSequence;

        -- 3. Log START
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime
        )
        VALUES (
            @BatchID, 'Migration', 'START', 'RUNNING',
            0, 0, 0,
            HOST_NAME(), 'GitHub Actions', GETDATE()
        );

        -- 4. DELETE existing data (full refresh)
        DELETE FROM dbo.Timesheet;
        SET @DeletedTimesheet = @@ROWCOUNT;
        DBCC CHECKIDENT ('dbo.Timesheet', RESEED, 0);

        DELETE FROM dbo.[Leave];
        SET @DeletedLeave = @@ROWCOUNT;
        DBCC CHECKIDENT ('dbo.[Leave]', RESEED, 0);

        -- 5. INSERT Timesheet (non‑leave, non‑weekend)
        --    DISTINCT removes any duplicate rows from staging
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

        -- 6. INSERT Leave (using LeaveCategory lookup)
        --    EXCLUDES Public Holiday & Family Resp.
        --    DISTINCT removes duplicates
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

        -- 7. Mark staging records as processed
        UPDATE dbo.StagingTimesheet
        SET IsProcessed = 1,
            ProcessedDate = GETDATE(),
            BatchID = @BatchID
        WHERE IsProcessed = 0;

        SET @UpdatedStaging = @@ROWCOUNT;

        -- 8. Log SUCCESS / COMPLETE
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
            HOST_NAME(), 'GitHub Actions', GETDATE()
        );

        -- Return success
        SELECT 0 AS ExitCode, 'SUCCESS' AS Status;

    END TRY
    BEGIN CATCH

        SET @ErrorMsg = ERROR_MESSAGE();

        -- Log ERROR
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, StatusCode,
            RowsInserted, RowsUpdated, RowsDeleted,
            HostName, ApplicationName, EventDateTime, ErrorMessage
        )
        VALUES (
            @BatchID, 'Migration', 'ERROR', 'FAILED',
            0, 0, 0,
            HOST_NAME(), 'GitHub Actions', GETDATE(), @ErrorMsg
        );

        -- Return failure
        SELECT 1 AS ExitCode, @ErrorMsg AS Status;

    END CATCH
END;
GO

PRINT 'Stored procedure spRunTimesheetMigration updated successfully.';
GO