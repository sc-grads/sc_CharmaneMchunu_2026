create table [dbo].[tblEmployeeTemporal]
	([EmployeeNumber] int NOT NULL PRIMARY KEY CLUSTERED,
	[EmployeeFirstName] varchar(50) NOT NULL,
	[EmployeeMiddleName] varchar(50) NULL,
	[EmployeeLastName] varchar(50) NOT NULL,
	[EmployeeGovernmentID] char(10) NOT NULL,
	[DateOfBirth] date NOT NULL,[Department] varchar(19) NULL,
	ValidFrom datetime2(2) GENERATED ALWAYS AS ROW START,
	ValidTo datetime2(2) GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom,ValidTo))
	WITH (SYSTEM_VERSIONING = ON)

INSERT INTO [dbo].[tblEmployeeTemporal]	
	([EmployeeNumber],[EmployeeFirstName],[EmployeeMiddleName],[EmployeeLastName],
	[EmployeeGovernmentID],[DateOfBirth],[Department])
VALUES (123,'Jane',NULL,'Zwilling','AB123456G','1975-01-01','Customer Relations')

