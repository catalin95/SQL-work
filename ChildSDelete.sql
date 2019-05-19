use database_name
go
/****** Object:  storedprocedure dbo.ChildSDelete   
set ansi_nulls on
go
set quoted_identifier on
go

-- =============================================
-- Author: Catalin Mucica
-- Description: Deletes any child serial number scanned and insert the deleted one into a table along side with his parent serial number and part number
-- =============================================

alter procedure dbo.ChildSDelete
@xmlUnitSN text,
@xmlSN text = null,
@xmlPO text = null,
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
declare @Old_parent_SN varchar(max)
declare @Old_parent_PN varchar(max)

exec uspxmlUnit @xmlUnitSN, @ID = @UnitID output 


if @UnitID in (select ChildID from dbo.Component) -- if the ID of input SN is a child of any parent..
begin
	
	set @Old_Serial = (select dbo.ffSN.Value from dbo.ffUnit -- set this variable to the value of input SN
					   join dbo.ffSN on dbo.ffSN.UnitID = dbo.ffUnit.ID
					   where dbo.ffUnit.ID = @UnitID) 
	set @Old_parentID = (select UnitID from dbo.ffComponent where ChildID = @UnitID) -- set the value of this variable to the ID of the Parent for the input Child Serial Number
	set @Old_parent_SN = (select Value from dbo.ffSN where UnitID = @Old_parentID) -- set this variable to the value of Parent Serial Number
	set @Old_parent_PN = (select dbo.ffPart.PN from dbo.ffUnit -- set this variable to the value of Parent Part Number
			      join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
  			      where dbo.ffUnit.ID = @Old_parentID) 

	insert into dbo.Serial_History values ((select @Old_Serial), (select @Old_parent_SN), (select @Old_parent_PN)) -- insert the above variables

	update dbo.ffComponent set StatusID = 1 where ChildID = @UnitID -- remove the link between the Parent and the Child
	delete from dbo.ffUnit where ID = @UnitID -- delete from Unit the Child 
	delete from dbo.ffDetail where UnitID = @UnitID -- delete from Detail the Child
	delete from dbo.ffComponent where ChildUnitID = @UnitID -- delete from Component the Child
	delete from dbo.ffSN where UnitID = @UnitID -- delete from SN the Child
end
else
	select 'This is not a Child Serial Number'
	union
	select 'Acesta nu este un Serial de copil'
end





 


