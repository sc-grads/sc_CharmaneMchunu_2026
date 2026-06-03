CREATE FUNCTION TransactionList(@EmployeeNumber int)
RETURNS TABLE AS RETURN
(
	SELECT * FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber

)

go
SELECT * 
from dbo.TransactionList(123)
GO
CREATE FUNCTION TransList(@EmployeeNumber int)
RETURNS @TransList TABLE
(Amount smallmoney,
DateOfTransaction smalldatetime,
EmployeeNumber int)
AS
BEGIN
	INSERT INTO @TransList
	SELECT * FROM tblTransaction
	WHERE EmployeeNumber=@EmployeeNumber
	RETURN
END

--outer apply all of tblEmployee, UDF 0+ rows
--cross apply UDF 1+ rows

--outer apply = LEFT JOIN
--cross apply = INNER JOIN