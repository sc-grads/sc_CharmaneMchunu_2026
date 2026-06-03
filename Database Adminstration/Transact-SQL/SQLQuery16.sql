CREATE FUNCTION NumberOfTransactions (@EmployeeNumber int)
RETURNS int
AS

BEGIN
	DECLARE @NumberOfTransactions INT
	SELECT @NumberOfTransactions = COUNT(*) FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber
	RETURN @NumberOfTransactions

END