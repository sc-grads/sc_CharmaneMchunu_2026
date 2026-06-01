
GO

begin tran
select *,'Before Delete' FROM ViewByDepartment where EmployeeNumber = 132
delete from ViewByDepartment
where EmployeeNumber = 132
SELECT *,'After Delete' from ViewByDepartment where EmployeeNumber=132
rollback tran

SELECT *
FROM sys.views
WHERE name = 'ViewByDepartment';


SELECT
    SCHEMA_NAME(schema_id) AS SchemaName,
    name
FROM sys.views

WHERE name LIKE '%ViewByDepartment%';



CREATE VIEW dbo.ViewByDepartment
AS
SELECT
    EmployeeNumber,
    DateOfTransaction,
    SUM(Amount) AS TotalAmount
FROM tblTransaction
GROUP BY EmployeeNumber, DateOfTransaction;
GO



CREATE TRIGGER tr_ViewByDepartment
ON dbo.ViewByDepartment
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DELETE T
    FROM tblTransaction AS T
    INNER JOIN deleted AS D
        ON T.EmployeeNumber = D.EmployeeNumber
       AND T.DateOfTransaction = D.DateOfTransaction
       AND T.Amount = D.TotalAmount;
END;
GO

SELECT name

FROM sys.views;

SELECT
    SCHEMA_NAME(schema_id) AS SchemaName,
    name
FROM sys.views

WHERE name = 'ViewByDepartment';

SELECT DB_NAME() AS CurrentDatabase;

SELECT OBJECT_ID('dbo.ViewByDepartment') AS ViewID;

SELECT *
FROM dbo.ViewByDepartment;


DROP TRIGGER IF EXISTS tr_ViewByDepartment;
GO

CREATE TRIGGER tr_ViewByDepartment
ON dbo.ViewByDepartment
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *, 'To Be Deleted' AS Status
    FROM deleted;

    DELETE T
    FROM tblTransaction AS T
    INNER JOIN deleted AS D
        ON T.EmployeeNumber = D.EmployeeNumber
       AND T.DateOfTransaction = D.DateOfTransaction
       AND T.Amount = D.TotalAmount;
END;
GO