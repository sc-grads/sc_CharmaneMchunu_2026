

drop table SalesStaff;
select 
FirstName + ' '+ LastName As FullName,
TerritoryName,
TerritoryGroup,
SalesQuota,
SalesYTD,
SalesLastYear
into SalesStaff
from 
sales.vSalesPerson


select * from [Sales].[vSalesPerson]



select * from SalesStaff

Update SalesStaff SET SalesQuota = 50000.00
Update SalesStaff SET SalesQuota = SalesQuota + 1500000.00
Update SalesStaff SET SalesQuota = SalesQuota + 1500000.00, SalesYTD = SalesYTD-500,SalesLastYear=SalesLastYear*1.50
Update SalesStaff SET TerritoryName = 'UK' where TerritoryName = 'United Kingdom'
Update SalesStaff SET TerritoryName = 'UK' ,TerritoryGroup= 'europe' where TerritoryGroup is null and FullName = 'Syed Abbas'
UPDATE ss
SET SalesQuota = sp.SalesQuota
FROM SalesStaff ss
INNER JOIN Sales.vSalesPerson sp
ON ss.FullName = (sp.FirstName + ' ' + sp.LastName);