USE [TIM_FF2819_ENEL_T]
GO
/****** Object:  StoredProcedure [dbo].[ChildSerialDelete]    Script Date: 4/23/2019 10:49:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Catalin Mucica
-- Description: Deletes any child serial number scanned and insert the deleted one into a table along side with his parent serial number and part number
-- =============================================

ALTER procedure [dbo].[ChildSerialDelete]
@xmlUnitSN text,
@xmlSerialNumber text = null,
@xmlProdOrder text = null,
@xmlPart text = null,
@xmlPackages text = null,
@xmlStation text = null,
@EmployeeID int = 0,
@xmlExtraData text = null,
@SNOutput varchar(200) = null output

as
begin

declare @UnitID int
declare @ID Int
declare @Old_Serial varchar(max)
declare @Old_parentID int
declare @Old_parent_SerialNumber varchar(max)
declare @Old_parent_PartNumber varchar(max)

exec uspxmlUnit @xmlUnitSN, @ID = @UnitID output 


if @UnitID in (select ChildUnitID from dbo.ffUnitComponent) -- if the ID of input SN is a child of any parent..
begin
	
	set @Old_Serial = (select dbo.ffSerialNumber.Value from dbo.ffUnit -- set this variable to the value of input SN
					   join dbo.ffSerialNumber on dbo.ffSerialNumber.UnitID = dbo.ffUnit.ID
					   where dbo.ffUnit.ID = @UnitID) 
	set @Old_parentID = (select UnitID from dbo.ffUnitComponent where ChildUnitID = @UnitID) -- set the value of this variable to the ID of the Parent for the input Child Serial Number
	set @Old_parent_SerialNumber = (select Value from dbo.ffSerialNumber where UnitID = @Old_parentID) -- set this variable to the value of Parent Serial Number
	set @Old_parent_PartNumber = (select dbo.ffPart.PartNumber from dbo.ffUnit -- set this variable to the value of Parent Part Number
								  join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
  							      where dbo.ffUnit.ID = @Old_parentID) 

	insert into dbo.Serial_History values ((select @Old_Serial), (select @Old_parent_SerialNumber), (select @Old_parent_PartNumber)) -- insert the above variables

	update dbo.ffUnitComponent set StatusID = 1 where ChildUnitID = @UnitID -- remove the link between the Parent and the Child
	delete from dbo.ffUnit where ID = @UnitID -- delete from Unit the Child 
	delete from dbo.ffUnitDetail where UnitID = @UnitID -- delete from UnitDetail the Child
	delete from dbo.ffUnitComponent where ChildUnitID = @UnitID -- delete from UnitComponent the Child
	delete from dbo.ffSerialNumber where UnitID = @UnitID -- delete from SerialNumber the Child
end
else
	select 'This is not a Child Serial Number'
	union
	select 'Acesta nu este un Serial de copil'
end


 --create table dbo.Serial_History (Old_Child_Serial_Number varchar(max) null, 
								 -- Old_Parent_Serial varchar(max) null,
								 -- Old_Parent_PartNumber varchar(max) null) 

  --select * from dbo.Serial_History



 


