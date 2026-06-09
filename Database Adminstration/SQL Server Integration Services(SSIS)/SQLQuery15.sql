GRANT SELECT ON SCHEMA :: Sales TO sqluser01;

EXECUTE AS USER = 'sqluser01';
---SELECT * FROM fn_my_permissions('Sales','SCHEMA');
select * from [Sales].[CreditCard]
REVERT;
GO

REVOKE UPDATE ON SCHEMA:: Sales TO sqluser01;
DENY SELECT ON SCHEMA :: Sales TO sqluser01;