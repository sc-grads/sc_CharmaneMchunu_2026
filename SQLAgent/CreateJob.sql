USE [msdb]
GO

DECLARE @job_name NVARCHAR(128) = N'RunTimesheetDataPipeline';
DECLARE @job_id BINARY(16);
DECLARE @ReturnCode INT = 0;
DECLARE @ServerName NVARCHAR(128) = CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(128));

-- Build the command dynamically with the correct package name
DECLARE @Command NVARCHAR(MAX) = 
    N'/ISSERVER "\"\SSISDB\TimesheetMigration\TimesheetMigration\TimesheetMigrationPipeline.dtsx\"" /SERVER "\"' + @ServerName + N'\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E';

-- Check if job already exists
SELECT @job_id = job_id FROM msdb.dbo.sysjobs WHERE name = @job_name;

IF @job_id IS NOT NULL
BEGIN
    -- Job exists → update the command of step 1
    EXEC msdb.dbo.sp_update_jobstep 
        @job_id = @job_id, 
        @step_id = 1, 
        @command = @Command;
    PRINT 'Job step updated successfully.';
END
ELSE
BEGIN
    -- Job does not exist → create it (same as original script, but without deletion)
    BEGIN TRANSACTION

    IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
    BEGIN
        EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
        IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    END

    EXEC @ReturnCode = msdb.dbo.sp_add_job 
        @job_name=N'RunTimesheetDataPipeline', 
        @enabled=1, 
        @notify_level_eventlog=0, 
        @notify_level_email=0, 
        @notify_level_netsend=0, 
        @notify_level_page=0, 
        @delete_level=0, 
        @description=N'No description available.', 
        @category_name=N'[Uncategorized (Local)]', 
        @owner_login_name=N'sa', 
        @job_id = @jobId OUTPUT
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
        @job_id=@jobId, 
        @step_name=N'RunTimesheetDataPipeline', 
        @step_id=1, 
        @cmdexec_success_code=0, 
        @on_success_action=1, 
        @on_success_step_id=0, 
        @on_fail_action=2, 
        @on_fail_step_id=0, 
        @retry_attempts=0, 
        @retry_interval=0, 
        @os_run_priority=0, 
        @subsystem=N'SSIS', 
        @command=@Command, 
        @database_name=N'master', 
        @flags=0
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule 
        @job_id=@jobId, 
        @name=N'runevery30seconds', 
        @enabled=1, 
        @freq_type=4, 
        @freq_interval=1, 
        @freq_subday_type=2, 
        @freq_subday_interval=30, 
        @freq_relative_interval=0, 
        @freq_recurrence_factor=0, 
        @active_start_date=20260702, 
        @active_end_date=99991231, 
        @active_start_time=0, 
        @active_end_time=200000, 
        @schedule_uid=N'b3bd3e28-e233-42bd-9149-fee448f5b057'
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    COMMIT TRANSACTION
    PRINT 'Job created successfully.';
    GOTO EndSave

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
    PRINT 'Job creation failed.';

EndSave:
END
GO
