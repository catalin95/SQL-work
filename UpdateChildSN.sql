use Database_name
go
/****** Object:  storedprocedure dbo.UpdateChildSN
set ansi_nulls on
go
set quoted_identifier on
go

/* Author: Catalin Mucica
   Description: Updates any child serial number scanned */

alter procedure dbo.UpdateChildSN
@xmlUnitSN text,
@xmlString text = null,
@xmlSN text = null,
@xmlPO text = null,
@xmlPart text = null,
@xmlPackages text = null, 
@xmlStation text = null, 
@EmployeeID int = null,
@xmlExtraData text = null, 
@SNOutput varchar(200) = null

as 
begin

declare @ID int
declare @UnitID int
declare @Serial varchar(max)

exec uspXMLUnit @xmlString, @ID = @UnitID

if @UnitID in(select ChildID from dbo.ffComponent where ChildID = @UnitID)
begin
	set @Serial = (select dbo.ffSN.Value from dbo.ffSN where UnitID = @UnitID)
	update dbo.ffComponent set StatusID = 1 where ChildID = @UnitID
	update dbo.ffSN set dbo.ffSN.Value = (@Serial + '_old') where UnitID = @UnitID
end
else
	select 'This is not a Child Serial Number'
	union
	select 'Acesta nu este un Serial de copil'

end

