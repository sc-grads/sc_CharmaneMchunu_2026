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
    DECLARE @execution_id BIGINT;
    DECLARE @status INT;
    DECLARE @Result INT = 0;
    DECLARE @StatusMessage NVARCHAR(500);
    DECLARE @ErrorMsg NVARCHAR(MAX);

    BEGIN TRY

        -- =========================================
        -- LOG START
        -- =========================================
        INSERT INTO dbo.AuditLog (
            BatchID,
            TableName,
            OperationType,
            StatusCode,
            HostName,
            ApplicationName,
            EventDateTime
        )
        VALUES (
            -1,
            'ETL_Process',
            'EXECUTION_START',
            'RUNNING',
            HOST_NAME(),
            'GitHub Actions',
            GETDATE()
        );

        -- =========================================
        -- START SSIS EXECUTION
        -- =========================================
        EXEC SSISDB.catalog.create_execution
            @folder_name = 'TimesheetDataPipeline',
            @project_name = 'TimesheetsMigrationSSIS',
            @package_name = 'ImportTimesheets.dtsx',
            @use32bitruntime = 0,
            @execution_id = @execution_id OUTPUT;

        EXEC SSISDB.catalog.set_execution_parameter_value
            @execution_id,
            @object_type = 50,
            @parameter_name = N'LOGGING_LEVEL',
            @parameter_value = 1;

        EXEC SSISDB.catalog.start_execution
            @execution_id;

        -- =========================================
        -- WAIT FOR COMPLETION
        -- =========================================
        WHILE 1 = 1
        BEGIN
            SELECT @status = [status]
            FROM SSISDB.catalog.executions
            WHERE execution_id = @execution_id;

            -- 7 = Success, 4 = Failed
            IF @status IN (7, 4)
                BREAK;

            WAITFOR DELAY '00:00:02';
        END;

        -- =========================================
        -- FINAL STATUS
        -- =========================================
        SET @StatusMessage =
            CASE
                WHEN @status = 7 THEN 'SUCCESS'
                ELSE 'FAILED'
            END;

        SET @Result =
            CASE
                WHEN @status = 7 THEN 0
                ELSE 1
            END;

        -- =========================================
        -- LOG END
        -- =========================================
        INSERT INTO dbo.AuditLog (
            BatchID,
            TableName,
            OperationType,
            StatusCode,
            RowsInserted,
            HostName,
            ApplicationName,
            EventDateTime,
            ErrorMessage
        )
        VALUES (
            -1,
            'ETL_Process',
            'EXECUTION_COMPLETE',
            @StatusMessage,
            0,
            HOST_NAME(),
            'GitHub Actions',
            GETDATE(),
            CASE WHEN @status = 7 THEN NULL ELSE 'SSIS Package Failed' END
        );

        SELECT @Result AS ExitCode, @StatusMessage AS Status;

    END TRY
    BEGIN CATCH

        SET @ErrorMsg = ERROR_MESSAGE();

        INSERT INTO dbo.AuditLog (
            BatchID,
            TableName,
            OperationType,
            StatusCode,
            HostName,
            ApplicationName,
            EventDateTime,
            ErrorMessage
        )
        VALUES (
            -1,
            'ETL_Process',
            'EXECUTION_ERROR',
            'FAILED',
            HOST_NAME(),
            'GitHub Actions',
            GETDATE(),
            @ErrorMsg
        );

        SELECT 1 AS ExitCode, @ErrorMsg AS Status;

    END CATCH
END;
GO

PRINT 'Stored procedure spRunTimesheetMigration updated successfully.';
GO