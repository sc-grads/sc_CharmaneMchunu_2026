USE master;
GO

--------------------------------------------------
-- CREATE DATABASE IF NOT EXISTS
--------------------------------------------------

IF DB_ID('CloudTunneling_CM') IS NULL
BEGIN
    CREATE DATABASE CloudTunneling_CM;
END
GO

USE CloudTunneling_CM;
GO

--------------------------------------------------
-- CREATE TEAM TABLE
--------------------------------------------------

IF OBJECT_ID('dbo.Team', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Team
    (
        TeamID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL
    );
END
GO

--------------------------------------------------
-- CREATE DEPLOYMENT LOG TABLE
--------------------------------------------------

IF OBJECT_ID('dbo.DeploymentLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeploymentLog
    (
        DeploymentID INT IDENTITY(1,1) PRIMARY KEY,
        DeploymentDate DATETIME NOT NULL DEFAULT GETDATE(),
        VersionNumber VARCHAR(20) NOT NULL,
        Status VARCHAR(20) NOT NULL
    );
END
GO

--------------------------------------------------
-- INSERT TEAM MEMBERS IF TABLE IS EMPTY
--------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM dbo.Team)
BEGIN
    INSERT INTO dbo.Team
    (
        FirstName,
        LastName
    )
    VALUES
        ('Charmane', 'Mchunu'),
        ('Teolan', 'Govender');
       
END
GO

--------------------------------------------------
-- LOG DEPLOYMENT
--------------------------------------------------

BEGIN TRY

    INSERT INTO dbo.DeploymentLog
    (
        VersionNumber,
        Status
    )
    VALUES
    (
        '1.0.0',
        'SUCCESS'
    );

END TRY

BEGIN CATCH

    IF OBJECT_ID('dbo.DeploymentLog', 'U') IS NOT NULL
    BEGIN
        INSERT INTO dbo.DeploymentLog
        (
            VersionNumber,
            Status
        )
        VALUES
        (
            '1.0.0',
            'FAILED'
        );
    END;

    THROW;

END CATCH;
GO

--------------------------------------------------
-- VALIDATION
--------------------------------------------------

SELECT * FROM dbo.Team;

SELECT *
FROM dbo.DeploymentLog
ORDER BY DeploymentID DESC;
GO
