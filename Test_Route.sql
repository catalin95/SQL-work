use database
go
/****** Object:  storedprocedure dbo.Test_Route    
set ansi_nulls on
go
set quoted_identifier on
go
/* Author: Catalin Mucica
   Description: SP for test, it verifies in history 3 output pass states and forces next route */

alter procedure dbo.test_route (@xmlSN text, @xmlString text = null, @xmlPO text = null, @xmlP text = null, @xmlS text = null, @EmployeeID int,
							@xmlE text = null, @SNOutput varchar(200) = null output)
as
begin

declare @UnitID int
declare @ID int
declare @StationID int
declare @Station_ID int
declare @EnterTime date
declare @ExitTime date 
declare @Employee_ID int


exec uspXMLU @xmlSN, @ID = @UnitID output
exec uspXMLS  @xmlS, @StationTypeID = @StationType_ID output

set @EnterTime = getdate()
set @ExitTime = (select convert(datetime,(select LastUpdate from dbo.ffUnit where ID = @UnitID)))
set @Employee_ID = (select EmployeeID from dbo.ffUnit where ID = @UnitID)
declare @Count int = (select count(dbo.ffUnitOutput.TypeID) from dbo.ffHistory
					  join dbo.ffUnitOutput on dbo.ffUnitOutput.CurrID = dbo.ffHistory.ID
					  join dbo.ffStation on dbo.ffStation.ID = dbo.ffHistory.StationID
					  where dbo.ffHistory.ID = @UnitID and dbo.ffUnitOutput.StationID in (1, 2, 3, 4) and dbo.ffUnitOutputState.OutputStateID in  (172, 86, 450)
					  and dbo.ffStation.Description in ('name1','name2', 'name3', 'name4') and RouteID = 17)


if @Count = 3
begin
	exec uspUNTSet @UnitID, 1, null, null,  @Station_ID, @Employee_ID, @EnterTime, @ExitTime
	return 9999
end

if @Count <> 3
return 0

	
	
end
