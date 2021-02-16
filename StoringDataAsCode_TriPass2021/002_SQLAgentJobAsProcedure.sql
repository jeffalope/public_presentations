/***********************************************************************
	Create the procedure to Deploy Job
***********************************************************************/
CREATE OR ALTER PROCEDURE dbo.DeployJob_AvocadoToastProcessor
AS
BEGIN

	DECLARE @ReturnCode INT;
	DECLARE @ErrorMessage NVARCHAR(2048);

	--JobProperties (https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/dbo-sysjobs-transact-sql?view=sql-server-ver15)
	DECLARE 
		@JobName sysname = N'AvocadoToastProcessor',
		@Enabled TINYINT = 1,
		@Description NVARCHAR(512) = N'This job prepares the perfect breakfast',
		@StartStepID INT = 1,
		@CategoryName sysname = NULL, 
		@OwnerLoginName sysname = N'sa',
		@NotifyLevelEventLog INT = 0,
		@NotifyLevelEmail INT = 0,
		@NotifyLevelNetSend INT = 0,
		@NotifyLevelPage INT = 0,
		@NotifyEmailOperatorName sysname = NULL,
		@NotifyNetSendOperatorName sysname = NULL,
		@NotifyPageOperatorName sysname = NULL,
		@DeleteLevel INT = 0;

	--JobStepProperties (https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/dbo-sysjobs-transact-sql?view=sql-server-ver15)
	DECLARE 
		@StepID INT = 1,
		@StepName sysname = N'Toast the bread',
		@Subsystem NVARCHAR(40) = N'TSQL',
		@Command NVARCHAR(MAX) = N'SELECT GETUTCDATE() AS UTCDateTime',
		@CmdExecSuccessCode INT = 0,
		@OnSuccessAction TINYINT = 1,
		@OnSuccessStepID INT = 0,
		@OnFailAction INT = 2, 
		@OnFailStepID INT = 0, 
		@RetryAttempts INT = 0, 
		@RetryInterval INT = 0, 
		@OSRunPriority INT = 0, 
		@DatabaseName sysname = N'master', 
		@Flags INT = 0;

	--JobServerProperties
	DECLARE 
		@ServerName sysname = '(local)';

	IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @jobName)
	BEGIN
	
		EXEC @ReturnCode = msdb.dbo.sp_add_job 
			@job_name = @jobName, 
			@enabled = @Enabled, 
			@notify_level_eventlog = @NotifyLevelEventLog,
			@notify_level_email = @NotifyLevelEmail, 
			@notify_level_netsend = @NotifyLevelNetSend, 
			@notify_level_page = @NotifyLevelPage, 
			@delete_level = @DeleteLevel, 
			@description = @Description, 
			@category_name = @CategoryName, 
			@owner_login_name = @OwnerLoginName,
			@start_step_id = @StartStepID;

		IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
		BEGIN
			IF (@@TRANCOUNT > 0) 
			BEGIN
				ROLLBACK TRANSACTION;
			END

			SET @ErrorMessage = CONCAT('Could not create job "', @jobName, '" (ReturnCode = ',  @ReturnCode, ')');
			THROW 50001, @ErrorMessage, 16;
		END
	END
	ELSE
	BEGIN
		
		EXEC @ReturnCode = msdb.dbo.sp_update_job 
			@job_name = @jobName, 
			@enabled = @Enabled, 
			@notify_level_eventlog = @NotifyLevelEventLog,
			@notify_level_email = @NotifyLevelEmail, 
			@notify_level_netsend = @NotifyLevelNetSend, 
			@notify_level_page = @NotifyLevelPage, 
			@delete_level = @DeleteLevel, 
			@description = @Description, 
			@category_name = @CategoryName, 
			@owner_login_name = @OwnerLoginName,
			@start_step_id = @StartStepID;

		IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
		BEGIN
			IF (@@TRANCOUNT > 0) 
			BEGIN
				ROLLBACK TRANSACTION;
			END

			SET @ErrorMessage = CONCAT('Could not update job "', @jobName, '" (ReturnCode = ',  @ReturnCode, ')');
			THROW 50001, @ErrorMessage, 16;
		END
				
	END

	IF NOT EXISTS 
	(
		SELECT * 
		FROM msdb.dbo.sysjobs j 
		INNER JOIN msdb.dbo.sysjobsteps js
			ON j.job_id = js.job_id
		WHERE j.[name] = @jobName
	)
	BEGIN
	
		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
			@job_name = @jobName, 
			@step_id = @StepID,
			@subsystem = @Subsystem,
			@step_name = @StepName,
			@command = @Command,
			@cmdexec_success_code = @CmdExecSuccessCode,
			@on_success_action = @OnSuccessAction,
			@on_success_step_id = @OnSuccessStepID,
			@on_fail_action = @OnFailAction,
			@on_fail_step_id = @OnFailStepID,
			@retry_attempts = @RetryAttempts,
			@retry_interval = @RetryInterval,
			@os_run_priority = @OSRunPriority;		

		IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
		BEGIN
			IF (@@TRANCOUNT > 0) 
			BEGIN
				ROLLBACK TRANSACTION;
			END

			SET @ErrorMessage = CONCAT('Could not create job step for "', @jobName, '" (ReturnCode = ',  @ReturnCode, ')');
			THROW 50001, @ErrorMessage, 16;
		END
	END
	ELSE 
	BEGIN
	
		EXEC @ReturnCode = msdb.dbo.sp_update_jobstep 
			@job_name = @jobName, 
			@step_id = @StepID,
			@subsystem = @Subsystem,
			@step_name = @StepName,
			@command = @Command,
			@cmdexec_success_code = @CmdExecSuccessCode,
			@on_success_action = @OnSuccessAction,
			@on_success_step_id = @OnSuccessStepID,
			@on_fail_action = @OnFailAction,
			@on_fail_step_id = @OnFailStepID,
			@retry_attempts = @RetryAttempts,
			@retry_interval = @RetryInterval,
			@os_run_priority = @OSRunPriority;		

		IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
		BEGIN
			IF (@@TRANCOUNT > 0) 
			BEGIN
				ROLLBACK TRANSACTION;
			END

			SET @ErrorMessage = CONCAT('Could not update job step for "', @jobName, '" (ReturnCode = ',  @ReturnCode, ')');
			THROW 50001, @ErrorMessage, 16;
		END
	END
	
	IF NOT EXISTS 
	(
		SELECT * 
		FROM msdb.dbo.sysjobs j 
		INNER JOIN msdb.dbo.sysjobservers js
			ON j.job_id = js.job_id
		WHERE j.[name] = @jobName
	)
	BEGIN
	
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver 
			@job_name = @JobName,
			@server_name = @ServerName;	

		IF (@@ERROR <> 0 OR @ReturnCode <> 0) 
		BEGIN
			IF (@@TRANCOUNT > 0) 
			BEGIN
				ROLLBACK TRANSACTION;
			END

			SET @ErrorMessage = CONCAT('Could not add job server to "', @jobName, '" (ReturnCode = ',  @ReturnCode, ')');
			THROW 50001, @ErrorMessage, 16;
		END
	END
	
	
END
GO

/***********************************************************************
	Cleanup and Redeploy the job
***********************************************************************/

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = N'AvocadoToastProcessor')
BEGIN
	EXEC msdb.dbo.sp_delete_job 
		@job_name = N'AvocadoToastProcessor', 
		@delete_unused_schedule=1;
END
GO

EXEC dbo.DeployJob_AvocadoToastProcessor;
GO
