BEGIN TRAN
CREATE TABLE tblGeom
(GXY geometry,
Description varchar(30),
ITtblGeom int CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(1,1))
INSERT INTO tblGeom 
VALUES (geometry:: STGeomFromText('POINT(3 4)',0),'First point'),
(geometry:: STGeomFromText('POINT(3 5)',0),'Second point'),
(geometry:: Point(4,6,0),'Third point'),
(geometry:: STGeomFromText('MULTIPOINT((1 2),(2 3),(3 4))',0),'Three Points')


SELECT * from tblGeom
select ITtblGeom,GXY.STGeometryType() as MyType
,GXY.STStartPoint().ToString() as StartingPoint
,GXY.STEndPoint().ToString() as EndingPoint
,GXY.STPointN(1).ToString() as FirstPoint
,GXY.STPointN(2).ToString() as SecondPoint
,GXY.STPointN(1).STX as StratingPoint
,GXY.STPointN(1).STY as StratingPoint
,GXY.STNumPoints() as StratingPoint
from tblGeom

ROLLBACK tran

DECLARE @g as geometry
DECLARE @h as geometry

select @g = GXY from tblGeom where ITtblGeom = 1
select @h = GXY from tblGeom where ITtblGeom = 3
select @g.STDistance(@h) as MyDistance

select @g , 'Point 1'
union all
select @h, 'Point 2'
ROLLBACK tran




