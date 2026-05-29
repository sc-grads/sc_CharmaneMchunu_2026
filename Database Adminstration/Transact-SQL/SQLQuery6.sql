declare @firstname as nvarchar(20)
declare @middlename as nvarchar(20)
declare @lastname as nvarchar(20)

set @firstname = 'John'
set @middlename = 'Walker'
set @lastname = 'Smith'

--select @firstname + @middlename + ' '+@lastname as FullName
select @firstname+ IIF(@middlename is null,'',''+@middlename)+ ' '+@lastname as FullName
select @firstname+ CASE WHEN @middlename is null THEN '' ELSE ''+@middlename END + ' '+@lastname as FullName