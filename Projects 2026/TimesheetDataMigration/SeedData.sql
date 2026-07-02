USE TimesheetDB;
GO

/* ============================================================
   1. AUDIT STATUS CODES
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.AuditStatusCode WHERE StatusCode = 'SUCCESS')
BEGIN
    INSERT INTO dbo.AuditStatusCode (StatusCode, StatusName, Description, IsSuccess, IsError)
    VALUES
        ('SUCCESS', 'Success', 'Operation completed successfully', 1, 0),
        ('FAILED',  'Failed',  'Operation failed', 0, 1),
        ('RUNNING', 'Running', 'Operation is in progress', 0, 0),
        ('WARNING', 'Warning', 'Completed with warnings', 0, 0),
        ('SKIPPED', 'Skipped', 'Operation was skipped', 0, 0);
END
GO


/* ============================================================
   2. LEAVE CATEGORY (LOOKUP DATA FOR SSIS MAPPING)
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.LeaveCategory WHERE SourceText = 'Annual Leave')
BEGIN
    INSERT INTO dbo.LeaveCategory (SourceText, LeaveType)
    VALUES
        ('Annual Leave',                'Annual Leave'),
        ('Sick leave',                  'Sick Leave'),
        ('Study Leave',                 'Study Leave'),
        ('Family Responsibility Leave', 'Family Responsibility Leave'),
        ('Birthday leave',              'Birthday Leave'),
        ('Public Holiday',              'Public Holiday'),
        ('Sick Leave - half day',       'Sick Leave - half day'),
        ('Annual Leave - half day',     'Annual Leave - half day');
END
GO


/* ============================================================
   3. CLIENTS (BUSINESS DATA)
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.Client WHERE ClientName = 'Internal Sambe')
BEGIN
    INSERT INTO dbo.Client (ClientName, ClientCode, IsActive)
    VALUES
        ('Internal Sambe', 'INT001', 1),
        ('ADVTech', 'ADV001', 1),
        ('AFA Sasfin', 'AFA001', 1),
        ('Artist Proof Studio', 'ART001', 1),
        ('Assimil8', 'ASS001', 1),
        ('Base 3', 'BAS001', 1),
        ('Blue Legacy', 'BLU001', 1),
        ('C. Steinweg', 'CST001', 1),
        ('Conekt – Aurum', 'CON001', 1),
        ('Conekt – Clientele', 'CON002', 1),
        ('Conekt – Internal Meeting', 'CON003', 1),
        ('Conekt – Meridian', 'CON004', 1),
        ('Conekt – Winning Business', 'CON005', 1),
        ('Conekt AGSA SharePoint', 'CON006', 1),
        ('Dentons', 'DEN001', 1),
        ('Discovery', 'DIS001', 1),
        ('Discovery Bank', 'DIS002', 1),
        ('Discovery CRES', 'DIS003', 1),
        ('Discovery CSI', 'DIS004', 1),
        ('Discovery Health', 'DIS005', 1),
        ('Discovery Information Governance and Security', 'DIS006', 1),
        ('Discovery Innovation Lab', 'DIS007', 1),
        ('Discovery People', 'DIS008', 1),
        ('Discovery Skills', 'DIS009', 1),
        ('Discovery Vitality', 'DIS010', 1),
        ('Gyro', 'GYR001', 1),
        ('KFC Digistics', 'KFC001', 1),
        ('Life Healthcare', 'LIF001', 1),
        ('Medi-Charge', 'MED001', 1),
        ('MICA Build', 'MIC001', 1),
        ('Michelin', 'MIE001', 1),
        ('Mistro Foods', 'MIS001', 1),
        ('OK Furnitures', 'OKF001', 1),
        ('Olympic Paints', 'OLY001', 1),
        ('RMB', 'RMB001', 1),
        ('RMB CM Data Warehouse support', 'RMB002', 1),
        ('RMB CORE NRTI', 'RMB003', 1),
        ('RMB Tumelo', 'RMB004', 1),
        ('Sachar Mobile', 'SAC001', 1),
        ('Sanlam', 'SAN001', 1),
        ('SBV', 'SBV001', 1),
        ('Sibanya', 'SIB001', 1),
        ('Transport Holdings', 'TRA001', 1);
END
GO


/* ============================================================
   4. EMPLOYEES
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.Employee WHERE EmployeeName = 'Buhle' AND EmployeeSurname = 'Mukhuba')
BEGIN
    INSERT INTO dbo.Employee (EmployeeName, EmployeeSurname, IsActive)
    VALUES
        ('Buhle', 'Mukhuba', 1),
        ('Charmane', 'Mchunu', 1),
        ('Jabulane', 'Poulo', 1),
        ('Kayden', 'Padayachee', 1),
        ('Lwazisile', 'Mhlambi', 1),
        ('Rushil', 'Jivan', 1),
        ('Shriya', 'Hariparsad', 1),
        ('Teolan', 'Govender', 1);
END
GO