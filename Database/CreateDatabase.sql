--01_CreateDatabase.sql
IF DB_ID('TimesheetDB') IS NULL
BEGIN
    CREATE DATABASE TimesheetDB;
END
GO