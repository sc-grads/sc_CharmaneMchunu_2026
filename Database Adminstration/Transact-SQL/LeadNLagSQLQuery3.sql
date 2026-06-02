select A.EmployeeNumber,A.AttendanceMonth,A.NumberAttendance,
lag(NumberAttendance,3) over(partition by E.EmployeeNumber
						order by A.AttendanceMonth) as MyLag,
lead(NumberAttendance,3)over(partition by E.EmployeeNumber
						order by A.AttendanceMonth) as MyLead
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber