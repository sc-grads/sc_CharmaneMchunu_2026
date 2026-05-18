use MyFirstDatabase
GO

SELECT * FROM DBO.Student
GO

SELECT * FROM dbo.Course
SELECT s.RollNo,s.studentname,c.courseid from  Student s
inner join course c
on s.RollNo = c.RollNO

SELECT s.RollNo,s.studentname,c.courseid from  Student s
left join course c
on s.RollNo = c.RollNO

SELECT s.RollNo,s.studentname,c.courseid from  Student s
right join course c
on s.RollNo = c.RollNO

SELECT s.RollNo,s.studentname,c.courseid from  Student s
full join course c
on s.RollNo = c.RollNO
