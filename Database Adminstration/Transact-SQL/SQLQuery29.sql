SELECT * from [dbo].[tblTransaction] as T
cross join [dbo].[tblTransaction] as T2

select mig.*, statement as table_name,column_id,column_name,column_usage
from sys.dm_db_missing_index_details as mid
cross apply sys.dm_db_missing_index_columns(mid.index_handle)
inner join sys.dm_db_missing_index_groups as mig on mig.index_handle = mid.index_handle
where database_id = db_id()
order by column_id