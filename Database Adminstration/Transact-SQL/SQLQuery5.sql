select left(EmployeeLastName,1) as Initial, count(*) as CountOfInitial
from tblEmployee
group by left(EmployeeLastName,1)
order by count(*) DESC --left(EmployeeName,1)

select top(5) left(EmployeeLastName,1) as Initial, count(*) as CountOfInitial
from tblEmployee
group by left(EmployeeLastName,1)
order by count(*) DESC --left(EmployeeName,1)

select left(EmployeeLastName,1) as Initial, count(*) as CountOfInitial
from tblEmployee
where DateOfBirth > '19860101'
group by left(EmployeeLastName,1)
having count(*) >= 20
order by CountOfInitial DESC --left(EmployeeName,1)

Update tblEmployee
Set EmployeeMiddleName = NULL
Where EmployeeMiddleName = ''