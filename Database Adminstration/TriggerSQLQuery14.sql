USE [AdventureWorks2022]
GO

SELECT TOP (1000) [EmpID]
      ,[EmpName]
      ,[EmpTitle]
  FROM [AdventureWorks2022].[dbo].[Employee]

GO
CREATE TRIGGER EmployeeInsert
   ON  Employee
   AFTER INSERT,
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	Insert into EmployeeTableHistory ((select max(1) EmpID from employee),'Insert')

END
GO

select * from EmployeeTriggerHistory



