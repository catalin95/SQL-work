USE [TIM_FF2819_ENEL_T]
GO
/****** Object:  StoredProcedure [dbo].[Test_Route]    Script Date: 5/14/2019 9:03:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Author: Catalin Mucica
   Description: SP for test, it verifies in history 3 output pass states and forces next route */

ALTER procedure [dbo].[Test_Route] (@xmlUnitSN text, @xmlString text = null, @xmlProdOrder text = null, @xmlPart text = null, @xmlStation text = null, @EmployeeID int,
							@xmlExtraData text = null, @SNOutput varchar(200) = null output)
as
begin

declare @UnitID int
declare @ID int
declare @StationTypeID int
declare @StationType_ID int
declare @EnterTime date
declare @ExitTime date 
declare @Employee_ID int


exec uspXMLUnit @xmlUnitSN, @ID = @UnitID output
exec uspXMLStation  @xmlStation, @StationTypeID = @StationType_ID output

set @EnterTime = getdate()
set @ExitTime = (select convert(datetime,(select LastUpdate from dbo.ffUnit where ID = @UnitID)))
set @Employee_ID = (select EmployeeID from dbo.ffUnit where ID = @UnitID)
declare @Count int = (select count(dbo.ffUnitOutputState.StationTypeID) from dbo.ffHistory
					  join dbo.ffUnitOutputState on dbo.ffUnitOutputState.CurrStateID = dbo.ffHistory.UnitStateID
					  join dbo.ffStation on dbo.ffStation.ID = dbo.ffHistory.StationID
					  where dbo.ffHistory.UnitID = @UnitID and dbo.ffUnitOutputState.StationTypeID in (85, 74, 78, 80) and dbo.ffUnitOutputState.OutputStateID in  (172, 86, 450)
					  and dbo.ffStation.Description in ('ENL-Test link','ENL-1111-Inspection', 'QC-ENL-1111', 'ENL-FQC-1111') and RouteID = 17)


if @Count = 3
begin
	exec uspUNTSetNextState @UnitID, 7002, null, null,  @StationType_ID, @Employee_ID, @EnterTime, @ExitTime
	return 1100002  --Could not insert into table, just for test
end

if @Count <> 3
return 0

	
	
end
