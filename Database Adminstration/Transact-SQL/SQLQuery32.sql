select EmployeeNumber,dbo.fnc_TransactionTotal(EmployeeNumber)
from dbo.tblEmployee

select E.EmployeeNumber,(select sum(Amount) from tblTransaction as T
						where T.EmployeeNumber = E.EmployeeNumber) as TotalAmount