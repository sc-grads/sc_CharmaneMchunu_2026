CREATE TABLE FunctionEmployee
(
EmpID int PRIMARY KEY,
FirstName varchar(50) NULL,
LastName varchar(50) NULL,
Salary int NULL ,
Address varchar(100) NULL,
)

Insert into FunctionEmployee(EmpID,FirstName,LastName,Salary,Address) Values(1,'Mohan','Chauahn',22000,'Delhi');
Insert into FunctionEmployee(EmpID,FirstName,LastName,Salary,Address) Values(2,'Asif','Chauahn',15000,'Delhi');
Insert into FunctionEmployee(EmpID,FirstName,LastName,Salary,Address) Values(3,'BhuvNesh','Chauahn',19000,'Noid');
Insert into FunctionEmployee(EmpID,FirstName,LastName,Salary,Address) Values(4,'Deepark','Kumar',19000,'Noid');

select * from FunctionEmployee;

Create function fnGetEmpFullName
( @FirstName varchar(50), @LastName varchar(50))
returns varchar(101)
As
begin
return (select @FirstName+' '+@LastName);
end

select dbo.fnGetEmpFullName (FirstName,LastName) as FullName

create function fnGetEmployee()
returns Table
As
return (select * from FuntionEmployee)

select * from dbo.FuntionEmployee

create function fbFetMulEmployee()
return @Emp Table
(
EmpID int,
FirstName varchar(50),
Salary int
)
As 
Begin
Insert into @Emp Select e.EmpID, e.FirstName,e.Salary from FunctionEmployee e;
----Now update salary of employee
update @Emp set Salary=25000 where EmpID=1;
----It will update only in @Emp table not in Original table
return
end

select * from dbo.fnGetMulEmplyee()

