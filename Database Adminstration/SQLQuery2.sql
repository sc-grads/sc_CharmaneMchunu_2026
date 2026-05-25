select * from [dbo].[Employee]
select * from [dbo].[sales]

select * from [dbo].[Employee] e
join [dbo].[sales] s
on e.empname = s.empname

select e.EmpID,e.EmpName,s.SalesNumber,s.ItemSold  from [dbo].[Employee] e
join [dbo].[sales] s
on e.empid = s.empid
order by e.empid

select count(SalesNumber) as NoOfSales,e.EmpID,e.Empname from [dbo].[Employee] e
join [dbo].[sales] s
on e.EmpID = s.EmpID
group by e.EmpID,E.EmpName

/*
SELECT [column-names]
	FROM [table-name1] JOIN [table-name2]
	ON [column-name1] = [column-name2]
WHERE condition
*/

