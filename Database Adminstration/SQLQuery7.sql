Use AdventureWorks2016
GO

SELECT * FROM Person.Address
SELECT addressid,city,modifieddate from [Person].[Address]
SELECT city,addressid,modifieddate from [Person].[Address]
SELECT TOP 10 * FROM [Person].[Address]

------------------------------------------------------------------------

SELECT * FROM Person.Address WHERE PostalCode = '98011'
SELECT * FROM Person.Address WHERE PostalCode != '98011' --delete from Person.Address WHERE PostalCode != '98011'
SELECT * FROM Person.Address WHERE PostalCode <> '98011'
SELECT count(*) FROM Person.Address WHERE PostalCode <> '98011'
SELECT * FROM Person.Address WHERE ModifiedDate >= '2013-11-08 00:00:00.000'
SELECT * FROM [Person].[Person] WHERE FirstName LIKE 'MATS%'
SELECT MAX(Rate) FROM [HumanResources].[EmployeePayHistory]
SELECT MIN(Rate) FROM [HumanResources].[EmployeePayHistory]
SELECT * FROM [Production].[ProductCostHistory] WHERE StartDate = '2013-05-30 00:00:00.000'

SELECT * FROM [Production].[ProductCostHistory] WHERE StartDate = '2013-05-30 00:00:00.000' AND StandardCost >= 200.00
SELECT * FROM [Production].[ProductCostHistory] WHERE (StartDate = '2013-05-30 00:00:00.000' AND StandardCost >= 200.00) OR ProductID > 800
SELECT * FROM [Production].[ProductCostHistory] WHERE ProductID in (802,803,820,900)
SELECT * FROM [Production].[ProductCostHistory] WHERE EndDate is Null
SELECT * FROM [Production].[ProductCostHistory] WHERE EndDate is not Null

