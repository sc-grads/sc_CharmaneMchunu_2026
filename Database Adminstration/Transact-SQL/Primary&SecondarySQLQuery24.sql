drop table #tblXML;
create table #tblXML(pkXML INT PRIMARY KEY, xmlCol XML)

insert into #tblXML(pkXML,xmlCol) VALUES (1,@x1)
insert into #tblXML(pkXML,xmlCol) VALUES (2,@x2)

select * from #tblXML
select tbl.col.value('@Cost','varchar(50)')
from #tblXML CROSS APPLY
xmlCol.nodes('/Shopping/ShoppingTrip/Item') as tbl(col)