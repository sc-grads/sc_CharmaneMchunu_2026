--CREATE PROCEDURE SelectAllPersonalAddress
--AS
--SELECT * FROM Person.Address
--go;

--SeLECT * FROM Person.Address;

--exec SelectAllPersonalAddress;
--drop procedure SelectAllPersonalAddress;

CREATE PROCEDURE SelectAllPersonalAddressWithParams (@City NVARCHAR(30))
AS

--begin
SET NOCOUNT ON

SELECT * FROM Person.Address where City = @city;

--end

exec SelectAllPersonalAddressWithParams @city = 'Miami'

exec SelectAllPersonalAddressWithParams 'Miami'