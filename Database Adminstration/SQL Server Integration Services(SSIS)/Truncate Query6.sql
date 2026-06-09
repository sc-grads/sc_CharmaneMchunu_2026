USE [AdventureWorks2022]
GO

INSERT INTO [dbo].[EmployeeNew]
           ([EmployeeName])
     VALUES
           ('James')
GO
select * from EmployeeNew

delete from EmployeeNew
truncate table EmployeeNew
