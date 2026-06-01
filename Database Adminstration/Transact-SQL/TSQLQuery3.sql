CREATE TRIGGER TR_tblTransaction
ON tblTransaction
AFTER DELETE, INSERT,UPDATE
AS
BEGIN
	select* from inserted
	select* from deleted
END
GO

BEGIN TRAN
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (123,'2015-07-10',123)
ROLLBACK TRAN
GO
