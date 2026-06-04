declare @EmployeeID int
declare csr CURSOR FOR
select EmployeeNumber
from [dbo].[tblEmployee]
where EmployeeNumber between 120 and 299

open csr
fetch next from csr into @EmployeeID
while @@FETCH_STATUS =0
begin
	select * from [dbo].[tblTransaction] where EmployeeNumber = @EmployeeID
	fetch next from csr into @EmployeeID

end
close csr
deallocate csr
