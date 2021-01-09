-- show SQL version 
select @@VERSION As [Version]
GO

-- auto commit transcation 
select * from [dbo].[AspNetUsers]

GO

-- explicit transcation 
begin transaction;
	SELECT @@TRANCOUNT As TranCount_AfterBegin;
	select * from [dbo].[AspNetUsers];

Commit; --or rollback
	SELECT @@TRANCOUNT As TranCount_AfterCommit;
	
-- there is no end transcation statement
--end transaction;

GO


-------------------------------------------------------------
-- isolation levels
---------------------------
set transaction isolation level read uncommitted

begin tran;
	select * from [dbo].[AspNetUsers];
	select * from [dbo].[AspNetUsers];
commit;

GO

set transaction isolation level read committed

begin tran;
	select * from [dbo].[AspNetUsers];
	select * from [dbo].[AspNetUsers];
commit;

GO
set transaction isolation level repeatable read

begin tran;
	select * from [dbo].[AspNetUsers];
	select * from [dbo].[AspNetUsers];
commit;
GO
set transaction isolation level serializable

begin tran;
	select * from [dbo].[AspNetUsers];
	select * from [dbo].[AspNetUsers];
commit;
GO
---------------------------
-- after RCSI at the database level 'use snapshot isolation'
set transaction isolation level read committed

Begin tran; 
	select * from [dbo].[AspNetUsers];
	select * from [dbo].[AspNetUsers];
commit

GO

set transaction isolation level snapshot 
set lock_timeout 15000;

Begin tran; 
	update [dbo].[AspNetUsers]
	set Email = 'hellw'
	where id = 'cc39a706-9c48-4416-83a3-84b31ee3c8ce';
	waitfor delay '00:00:10';
rollback;
select * from [dbo].[AspNetUsers];

GO

-- Showing the active snapshot trans
-- it returns a virtual table of all transaction that generate or potential access row version

select DB_NAME(database_id) As DatabaseName, t.*
from sys.dm_tran_active_snapshot_database_transactions t
join sys.dm_exec_sessions s
on t.session_id = s.session_id


GO

--Showing the space usage in tempdb
-- displays total space in tempdb used by the version store records for each db
select DB_NAME(vsu.database_id) As DatabaseName,
vsu.reserved_page_count,
vsu.reserved_space_kb,
tu.total_page_count as tempdb_pages,
vsu.reserved_page_count * 100. / tu.total_page_count as [Snapshot %],
tu.allocated_extent_page_count * 100. / tu.total_page_count as [tempdb %] 
from sys.dm_tran_version_store_space_usage vsu
cross Join tempdb.sys.dm_db_file_space_usage tu
where vsu.database_id = tu.database_id 


GO 

--Showing the content of the current version store (expensive to run)
select DB_NAME(database_id) As DatabaseName ,*
from sys.dm_tran_version_store

GO
-----------------------------------------------
--locking 
--Locking and Blocking
Declare @Context varbinary(10) = cast('Trillian' as varbinary)

set context_Info @context;
set tran isolation level repeatable read;
set Lock_timeout -1;

begin tran;

select * from [dbo].[AspNetUsers];

rollback;


--sys.dm.tanc.locks Dynamic Management View (DMVs)will show us the state of affairs.
select cast(es.context_info as varchar(30)) as [session],
tl.resource_type,
tl.request_mode,
tl.request_status
from sys.dm_tran_locks tl
join sys.dm_exec_sessions es
on tl.request_session_id = es.session_id
where es.context_info <> 0x00
order by es.context_info,resource_type;