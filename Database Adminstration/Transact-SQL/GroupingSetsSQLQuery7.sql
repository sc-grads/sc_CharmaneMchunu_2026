select E.Department,E.EmployeeNumber,A.AttendanceMonth as AttendanceMonth, sum(A.NumberAttendance) as NumberAttendance,
GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
GROUPING_ID(E.Department,E.EmployeeNumber,A.AttendanceMonth) AS EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by rollup (E.Department,E.EmployeeNumber,A.AttendanceMonth)
order by CASE WHEN Department IS NULL THEN 1 ELSE 0 END,Department,
         CASE WHEN E.EmployeeNumber iS NULL THEN 1 ELSE 0 END, E.EmployeeNumber,
         CASE WHEN AttendanceMonth iS NULL THEN 1 ELSE 0 END, AttendanceMonth