BEGIN TRAN
CREATE TABLE tblGeom
(GXY geometry,
Description varchar(20),
ITtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))
INSERT INTO tblGeom 
VALUES (geometry:: STGeomFromText('LINESTRING(1 1 ,3 4)',0),'First line'),
       (geometry:: STGeomFromText('LINESTRING(5 1 ,1 4,2 5,5 1)',0),'Second line'),
       (geometry:: STGeomFromText('MULTILINESTRING((1 5 ,2 6),(1 4,2 5)', 0),'Third line'),
       (geometry:: STGeomFromText('POLYGON((4 1 ,6 3,8 3,6 1,4 1))',0),'Polygon')

       SELECT * from tblGeom
rollback tran