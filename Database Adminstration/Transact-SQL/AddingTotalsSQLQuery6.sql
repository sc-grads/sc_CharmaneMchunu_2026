select E.Department,E.EmployeeNumber,A.AttendanceMonth,A.NumberAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
order by Department,EmployeeNumber,AttendanceMonth

select sum(NumberAttendance) as GrandTotal from tblAttendance