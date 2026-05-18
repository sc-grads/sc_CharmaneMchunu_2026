Employee Table 
[EmpID][int] NOT NULL,
[EmpName][nvarchar](50) NULL,
[EmpTitle][nvarchar](50) NULL,

Sales Table
	[EmpID][int] NULL,
	[EmpName][varchar](50) NULL,
	[SalesNumber] [int] NOT NULL,
	[ItemSold][int] NULL,

	SELECT * FROM [dbo].[Employee]
	SELECT * FROM [dbo].[Sales]

SELECT * FROM [dbo].[Employee] e
join [dbo].[sales] s
on e.EmpName = s.EmpName

SELECT * FROM [dbo].[Employee] e
join [dbo].[Sales] s
on e.EmPID = s.EmpID

SELECT count(SalesNumber),e.EmpID,e.EmpName from [dbo].[Employee] e
join [dbo].[Sales] s
on e.EmpID = s.EmpID
group by e.EmpID,e.EmpName
