CREATE TABLE tblEmployee(
EmployeeNumber INT NOT NULL,
EmployeeFirstName VARCHAR(50) NOT NULL,
EmployeeMiddleName VARCHAR(50) NULL,
EmployeeLastName VARCHAR(50)NOT NULL,
EmployeeGovernmentID CHAR(10) NULL,
DateOfBirth DATE NOT NULL


)

ALTER TABLE tblEmployee
ADD Department VARCHAR(10);

SELECT * FROM tblEmployee


ALTER TABLE tblEmployee
DROP COLUMN Department


ALTER TABLE tblEmployee
ADD Department VARCHAR(15)


ALTER TABLE tblEmployee
ALTER COLUMN Department VARCHAR(20)

SELECT * FROM tblEmployee
where [EmployeeLastName] LIKE '%W%'

SELECT * FROM tblEmployee
where [EmployeeLastName] <> 'Word'