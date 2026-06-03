begin tran
alter table tblEmployee
add Manager int
go
update tblEmployee
SET Manager = ((EmployeeNumber-123)/10)+123
where EmployeeNumber > 123
select E.EmployeeNumber,E.EmployeeFirstName,E.EmployeeLastName,E.Manager,
	M.EmployeeNumber,M.EmployeeFirstName, M.EmployeeLastName,M.Manager
from tblEmployee as E
JOIN tblEmployee as M
on E.Manager = M.EmployeeNumber
rollback tran
