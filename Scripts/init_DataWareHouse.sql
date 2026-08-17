/*
*****************************************
       Create Database & Schemas
*****************************************

Script Purpose:
	This Scripts Create a new database named 'DataWarreHouse' after checking if it already exists.
	if database exists then it is dropped & recreated.
	Additionally, this Script create three new Schemas named 'Bronze','Silver','Gold'.

Warning:
	Running this Script will drop the entire 'DataWareHouse' Database if it exists.
	All in the Previous Database will be deleted,proceed with caution! & Ensure you have Proper Backup.

*/

use master;
go

-- Drop and Recreate Database 'DataWareHouse' 

if exists (select 1 from sys.databases where name = 'DataWarreHouse')
begin 
	alter database DataWareHouse set single_user with rollback immediate;
	drop database MyDatabase;
end;
go

-- Create database 'DataWareHouse'
Create database DataWareHouse;
go

-- use Database 'DataWareHouse'
use DataWareHouse;
go

-- Create Schemas 

Create Schema Bronze;
go

Create Schema Silver;
go

Create Schema Gold;
go
