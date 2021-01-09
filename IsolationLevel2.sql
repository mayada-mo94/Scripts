use [Platform_IdentityServer];
Go 

--Enable RCSI at the database level 
alter database [Platform_IdentityServer] set read_committed_snapshot on;

go

select DB_NAME(database_id),
is_read_committed_snapshot_on,
snapshot_isolation_state_desc
from sys.databases
where database_id = DB_ID();

--permits Snapshot isolation 'set isolation level explicity for each transaction that needs it' 
Alter database [Platform_IdentityServer] set allow_snapshot_isolation on;


update [dbo].[AspNetUsers]
set Email = 'mostafatwo'
where id = 'cc39a706-9c48-4416-83a3-84b31ee3c8ce';
waitfor delay '00:00:10';
rollback;



insert into [dbo].[AspNetUsers] (id,	AccessFailedCount,ConcurrencyStamp	,Email,	EmailConfirmed,	LockoutEnabled	,LockoutEnd	,NormalizedEmail	,NormalizedUserName,	PasswordHash,
	PhoneNumber,	PhoneNumberConfirmed	,SecurityStamp,	TwoFactorEnabled,	UserName,	Thumbnail	,DisplayName	,Picture,	RepKey) values(
	'cc39a7069c48-4416-83a3-84b31ee3c8c' ,	0	,'3a5bbf83-dc64-4026-bb7c-9ac47b13a326',	'mmohsen'	,0,	1	,NULL	,NULL,	'USER05',
	'AQAAAAEAACcQAAAAEFA9dOMLPigQeXGx33HBEU1Q4QNg0l61Zv1Z5YTOt1x5qnbxvLcPeCBUP4T1TeYbg',NULL,	0,	'XCQ5AP3YBIUMYDBHZSLDJNCKUSGPCFR'	,0,	'User05'
	,	NULL	,NULL,
		NULL,	0
)

