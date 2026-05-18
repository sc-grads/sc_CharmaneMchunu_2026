drop table salesstaff
create table salesstaff
(
StaffID int not null primary key,
firstname nvarchar(50) not null,
lastname nvarchar(50) not null,
countryregion nvarchar(50) not null
)

select * from salesstaff
insert into salesstaff
select businessentityid,firstname,lastname,countryregionname from sales.vsalesperson;

delete salesstaff;
delete from salesstaff

delete from salesstaff where countryregion = 'united states'

begin tran 

delete from salesstaff where countryregion = 'united states'
commit
rollback tran

delete salesstaff
where staffid in 
(select BusinessEntityID from sales.vsalesperson where saleslastyear = 0)

delete salesstaff
from sales.vsalesperson sp
inner join salesstaff ss
on sp.BusinessEntityID = ss.StaffID
where sp.saleslastyear = 0

