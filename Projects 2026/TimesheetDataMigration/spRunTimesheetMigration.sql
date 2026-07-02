ALTER PROCEDURE dbo.spRunTimesheetMigration
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartTime DATETIME = GETDATE();

    BEGIN TRY

        -- Log start
        INSERT INTO dbo.AuditLog
        (
            BatchID,
            TableName,
            OperationType,
            RecordID,
            ChangedColumns,
            AffectedRows,
            StatusCode,
            ErrorMessage,
            ExecutingUser,
            HostName,
            ApplicationName,
            EventDateTime,
            ProcessingTimeMs
        )
        VALUES
        (
            -1,
            'ETL_Process',
            'EXECUTION_START',
            'DIRECT_EXECUTION',
            NULL,
            1,
            'RUNNING',
            NULL,
            SYSTEM_USER,
            HOST_NAME(),
            'GitHub Actions',
            @StartTime,
            NULL
        );

   
        EXEC msdb.dbo.sp_start_job 
            @job_name = 'RunTimesheetMigration';

        SELECT 
            CAST(0 AS INT) AS ExitCode,
            CAST('JOB_STARTED' AS NVARCHAR(50)) AS Status;

    END TRY
    BEGIN CATCH

        INSERT INTO dbo.AuditLog
        (
            BatchID,
            TableName,
            OperationType,
            RecordID,
            ChangedColumns,
            AffectedRows,
            StatusCode,
            ErrorMessage,
            ExecutingUser,
            HostName,
            ApplicationName,
            EventDateTime,
            ProcessingTimeMs
        )
        VALUES
        (
            -1,
            'ETL_Process',
            'EXECUTION_FAILED',
            'DIRECT_EXECUTION',
            NULL,
            0,
            'FAILED',
            ERROR_MESSAGE(),
            SYSTEM_USER,
            HOST_NAME(),
            'GitHub Actions',
            GETDATE(),
            NULL
        );

        SELECT 
            CAST(1 AS INT) AS ExitCode,
            CAST(ERROR_MESSAGE() AS NVARCHAR(4000)) AS Status;

    END CATCH
END;