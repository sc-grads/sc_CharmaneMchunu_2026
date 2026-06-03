select * from tblEmployee where EmployeeNumber =129;
go
declare @command as varchar(255);
set @command = 'select * from tblEmployee where EmployeeNumber=129'
set @command = 'select * from tblTransaction'
execute (@command);
go

declare @command as varchar(255),@param as varchar(50);
set @command = 'select * from tblEmployee where EmployeeNumber='
set @param = '129 or 1=1'
execute (@command + @param); --sql injection
go
