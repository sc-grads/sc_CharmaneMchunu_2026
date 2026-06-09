IF DB_ID('DatabaseDeployment') IS NULL
BEGIN
    CREATE DATABASE CICD_Demo;
END
GO

USE DatabaseDeployment;
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Employees'
)
BEGIN
    CREATE TABLE Employees
    (
        EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(100),
        LastName NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END
GO

CREATE TABLE DeploymentLog
(
    DeploymentID INT IDENTITY(1,1) PRIMARY KEY,
    DeploymentDate DATETIME DEFAULT GETDATE(),
    VersionNumber VARCHAR(20)
);
INSERT INTO DeploymentLog (VersionNumber)
VALUES ('1.0.0');