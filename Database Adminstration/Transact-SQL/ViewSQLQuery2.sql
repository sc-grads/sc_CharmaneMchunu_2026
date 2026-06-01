SELECT V.name, S.text from sys.syscomments as S
inner join sys.views as V
on S.id = V.object_id
select object_definition(object_id('dbo.ViewByDepartment'))
select * from sys.sql_modules