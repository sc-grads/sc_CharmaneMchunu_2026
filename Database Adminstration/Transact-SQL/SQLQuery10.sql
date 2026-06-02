select * from tblDepartment
select * from tblEmployee
select * from tblTransaction

select min(EmployeeNumber) as MinNumber,max(EmployeeNumber) as MaxNumber
from tblTransaction

select min(EmployeeNumber) as MinNumber,max(EmployeeNumber) as MaxNumber
from tblEmployee

select * 
from tblTransaction as T
inner join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
where EmployeeLastName like 'y%'
order by T.EmployeeNumber

select * from tblTransaction as T
where EmployeeNumber in 
(126,127,128,129)
order by EmployeeNumber

select EmployeeNumber from tblEmployee WHERE EmployeeNumber IN
(Select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber


select * from tblTransaction as T  WHERE EmployeeNumber IN
      (Select EmployeeNumber from tblEmployee where EmployeeLastName not like 'y%')
order by EmployeeNumber