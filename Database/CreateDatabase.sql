--01_CreateDatabase.sql
IF DB_ID('TimesheetCMDB') IS NULL
BEGIN
    CREATE DATABASE TimesheetCMDB;
END
GO
