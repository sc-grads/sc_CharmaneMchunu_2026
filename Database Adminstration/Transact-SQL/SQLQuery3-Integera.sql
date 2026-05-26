USE [70-461]
GO

CREATE TABLE tblEmployee
(EmployeeNumber int , )

--Initialize a variable , give it a data type and an initial value
--DECLARE @myvar AS numeric(7,2) = 3

--Increase that value by 1
--SET @myvar = @myvar + 1

--Retrieve that value
--SELECT @myvar AS myVariable

--SELECT POWER(@myvar,3)
--SELECT SQUARE(@myvar)
--SELECT POWER(@myvar,0.5)
--SELECT SQRT(@myvar)

DECLARE @myvar as numeric(7,2) = 12.345

SELECT FLOOR(@myvar) as myFloor
SELECT CEILING(@myvar) as myCeiling
SELECT ROUND(@myvar,1) as myRound
SELECT  ABS(@myvar) as myABS, SIGN(@myvar) as mySign
SELECT RAND(9765)

GO
SELECT PI() as myPI
SELECT EXP(1) as e

--IMPLICIT
DECLARE @myvar as Decimal(5,2) =3
SELECT @myvar


--EXPLICIT
SELECT CONVERT(decimal(5,2),3)/2
SELECT CAST(3 as decimal(5,20))/2
SELECT CONVERT(decimal(5,2),1000)