create synonym EmployeeTable
for tblEmployee
go

select * from EmployeeTable
create synonym DataTable
for tblDate

select * from DateTable

create synonym RemoteTable
for OVERTHERE.70-461 remote.dbo.tblRemote
go

select * from RemoteTable