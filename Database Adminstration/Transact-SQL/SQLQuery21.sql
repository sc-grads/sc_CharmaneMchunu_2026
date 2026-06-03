select E.EmployeeNumber,E.EmployeeFirstName,E.EmployeeLastName
,E.DateOfBirth,T.Amount,T.DateOfTransaction
from [dbo].[tblEmployee] as E
left join [dbo].[tblTransaction] as T
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeNumber between 200 and 202
for xml auto,elements