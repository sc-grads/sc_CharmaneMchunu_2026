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
    DECLARE @JobName NVARCHAR(128) = 'RunTimesheetMigration';
    DECLARE @StatusMessage NVARCHAR(500);
    DECLARE @ErrorMsg NVARCHAR(500);
    DECLARE @Result INT = 0;
    DECLARE @execution_id BIGINT;
    
    BEGIN TRY
        -- Log start
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, RecordID,
            StatusCode, ExecutingUser, HostName, 
            ApplicationName, EventDateTime
        )
        VALUES (
            -1, 
            'ETL_Process', 
            'EXECUTION_START', 
            'DIRECT_EXECUTION',
            'RUNNING', 
            SYSTEM_USER, 
            HOST_NAME(), 
            'GitHub Actions', 
            GETDATE()
        );
        
        -- Execute SSIS package directly using SSISDB catalog
        EXEC SSISDB.catalog.create_execution 
            @folder_name = 'TimesheetDataPipeline',
            @project_name = 'TimesheetsMigrationSSIS',   
            @package_name = 'ImportTimesheets.dtsx',      
            @use32bitruntime = False,
            @reference_id = NULL,
            @execution_id = @execution_id OUTPUT;
        
        -- Set logging level
        EXEC SSISDB.catalog.set_execution_parameter_value 
            @execution_id,
            @object_type = 50,
            @parameter_name = N'LOGGING_LEVEL',
            @parameter_value = 1;
        
        -- Start execution
        EXEC SSISDB.catalog.start_execution @execution_id;
        
        SET @StatusMessage = 'SSIS Package started. Execution ID: ' + CAST(@execution_id AS VARCHAR(20));
        PRINT @StatusMessage;
        
        -- Wait for execution to complete
        DECLARE @status INT;
        DECLARE @retry_count INT = 0;
        DECLARE @max_retries INT = 120;
        
        WHILE @retry_count < @max_retries
        BEGIN
            SELECT @status = [status]
            FROM SSISDB.catalog.executions
            WHERE execution_id = @execution_id;
            
            IF @status IN (7, 2) -- 7=Success, 2=Failed
                BREAK;
            
            SET @retry_count = @retry_count + 1;
            WAITFOR DELAY '00:00:02';
        END
        
        -- Get final status
        SELECT 
            @status = [status],
            @StatusMessage = CASE 
                WHEN [status] = 7 THEN 'SUCCESS'
                WHEN [status] = 2 THEN 'FAILED'
                ELSE 'RUNNING'
            END
        FROM SSISDB.catalog.executions
        WHERE execution_id = @execution_id;
        
        -- Log completion
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, RecordID,
            StatusCode, ErrorMessage, ExecutingUser, HostName, 
            ApplicationName, EventDateTime, ProcessingTimeMs
        )
        VALUES (
            -1,
            'ETL_Process',
            'EXECUTION_COMPLETE',
            CAST(@execution_id AS VARCHAR(20)),
            CASE WHEN @status = 7 THEN 'SUCCESS' ELSE 'FAILED' END,
            CASE WHEN @status = 2 THEN 'Package execution failed' ELSE NULL END,
            SYSTEM_USER,
            HOST_NAME(),
            'GitHub Actions',
            GETDATE(),
            DATEDIFF(MILLISECOND, @StartTime, GETDATE())
        );
        
        IF @status = 7
        BEGIN
            PRINT 'ETL completed successfully.';
            SET @Result = 0;
            SET @StatusMessage = 'SUCCESS';
        END
        ELSE
        BEGIN
            PRINT 'ETL failed.';
            SET @Result = 1;
            SET @StatusMessage = 'FAILED';
        END
        
    END TRY
    BEGIN CATCH
        SET @ErrorMsg = ERROR_MESSAGE();
        
        INSERT INTO dbo.AuditLog (
            BatchID, TableName, OperationType, RecordID,
            StatusCode, ErrorMessage, ExecutingUser, HostName, 
            ApplicationName, EventDateTime
        )
        VALUES (
            -1,
            'ETL_Process',
            'EXECUTION_ERROR',
            'DIRECT_EXECUTION',
            'FAILED',
            @ErrorMsg,
            SYSTEM_USER,
            HOST_NAME(),
            'GitHub Actions',
            GETDATE()
        );
        
        PRINT 'Error: ' + @ErrorMsg;
        SET @Result = 1;
        SET @StatusMessage = 'FAILED: ' + @ErrorMsg;
    END CATCH
    
    SELECT @Result AS ExitCode, @StatusMessage AS Status;
END;
GO

PRINT 'Stored procedure spRunTimesheetMigration created.';
GO