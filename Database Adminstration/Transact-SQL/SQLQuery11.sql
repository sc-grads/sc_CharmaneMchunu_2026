Select CURRENT_TIMESTAMP as RightNow
Select getdate() as RightNow
Select SYSDATETIME() as RightNow
Select dateadd(Year,1,'2015-01-02 03:04:05') as myYear
Select datepart(hour,'20215-01-02 03:04:05') as myHour
Select DATENAME(WEEKDAY, getdate()) as my Answer
Select datediff(SECOND,'2015-01-02 03:04:05',getdate()) as SecondsElapsed


---Converting date to string
declare @mydate as datetime = '2015-06-25 01:02:03.456'
select 'The date and time is: ' + @mydate
go
declare @mydate as datetime = '2015-06-25 01:02:03.456'
select 'The date and time is: ' + convert(nvarchar(20),@getdate) as MyConvertDate
go
declare @mydate as datetime = '2015-06-25  01:02:03.456'
select cast(@mydate as nvarchar(20) as MyCastDate

select convert(date,'Thursday 25 June 2025') as MyConvertedDate
select parse('Thursday,25 June 2015' as date) as MyParsedDate

select format(cast('2015-06-25 01:02:03.456' as datetime),'D') as MyFormattedLongDate
select format(cast('2015-06-25 01:02:03.456' as datetime),'d') as MyFormattedShortDate
select format(cast('2015-06-25 01:02:03.456' as datetime),'dd-MM-yyyy') as MyFormattedBritishDate
select format(cast('2015-06-25 01:02:03.456' as datetime),'D') as MyFormattedInternationalLongDate