IF DB_ID('CloudTunneling_CM') IS NULL
BEGIN
    CREATE DATABASE CloudTunneling_CM;
END
GO

USE CloudTunneling_CM;
GO

IF OBJECT_ID('dbo.Team', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Employees
    (
        EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(100),
        LastName NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END
GO

IF OBJECT_ID('dbo.DeploymentLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeploymentLog
    (
        DeploymentID INT IDENTITY(1,1) PRIMARY KEY,
        DeploymentDate DATETIME DEFAULT GETDATE(),
        VersionNumber VARCHAR(20)
    );
END
GO

INSERT INTO dbo.DeploymentLog (VersionNumber)
VALUES ('1.0.0');
GO