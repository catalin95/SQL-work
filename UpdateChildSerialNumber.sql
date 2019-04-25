USE [TIM_FF2819_ENEL_T]
GO
/****** Object:  StoredProcedure [dbo].[UpdateChildSerialNumber]    Script Date: 4/23/2019 10:53:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Author: Catalin Mucica
   Description: Updates any child serial number scanned */

ALTER procedure [dbo].[UpdateChildSerialNumber]
@xmlUnitSN text,
@xmlString text = null,
@xmlSerialNumber text = null,
@xmlProdOrder text = null,
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

if @UnitID in(select ChildUnitID from dbo.ffUnitComponent where ChildUnitID = @UnitID)
begin
	set @Serial = (select dbo.ffSerialNumber.Value from dbo.ffSerialNumber where UnitID = @UnitID)
	update dbo.ffUnitComponent set StatusID = 1 where ChildUnitID = @UnitID
	update dbo.ffSerialNumber set dbo.ffSerialNumber.Value = (@Serial + '_old') where UnitID = @UnitID
end
else
	select 'This is not a Child Serial Number'
	union
	select 'Acesta nu este un Serial de copil'

end

