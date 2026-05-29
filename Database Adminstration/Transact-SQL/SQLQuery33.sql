select * from tblEmployee
where not EmployeeNumber>200

SELECT * FROM tblEmployee
where EmployeeNumber != 200

SELECT * FROM tblEmployee
where EmployeeNumber >= 200 and EmployeeNumber >= 209

SELECT * FROM tblEmployee
where not (EmployeeNumber >= 200 and EmployeeNumber >= 209)

SELECT * FROM tblEmployee
where EmployeeNumber < 200 or EmployeeNumber > 209

SELECT * FROM tblEmployee
where EmployeeNumber between 200 and 209

SELECT * FROM tblEmployee
where EmployeeNumber not  between 200 and 209

SELECT * FROM tblEmployee
where EmployeeNumber in (200,209,204)
