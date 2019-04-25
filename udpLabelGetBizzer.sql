USE [TIM_FF2819_ENEL_T]
GO
/****** Object:  StoredProcedure [dbo].[udpLabelGetBizzer]    Script Date: 4/23/2019 10:45:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Author: Catalin Mucica
   Description: This SP should return any child SN scanned if it is from any family that has in his description 'x = any searched info'; if this condition is not met should return the scanned SN
				If by any means the scanned SN is a parent that has any child that if from any family that has in his description "x", should return the specific child SN */

ALTER procedure [dbo].[udpLabelGetBizzer]

(
@Label varchar(200),
@SN varchar(200),
@TargetID int,
@elm varchar(200) output


)
as
begin
	declare @Var varchar(200)
	declare @ParentID int
	declare @ParentSN varchar(200)
	declare @ChildID int
	declare @ChildSN varchar(200)

	 select @Var =  dbo.ffUnitComponent.ChildSerialNumber from dbo.ffUnitComponent -- set @elm to the value of any input SN that is a Child Serial Number from any family with "PW" in name
					join dbo.ffSerialNumber on dbo.ffSerialNumber.Value = dbo.ffUnitComponent.ChildSerialNumber
					join dbo.luPartFamily on dbo.luPartFamily.ID = dbo.ffUnitComponent.ChildPartFamilyID
					where ChildSerialNumber = @SN and dbo.luPartFamily.Name like N'%PW%'
	set @ChildID = (select ChildUnitID from dbo.ffUnitComponent where ChildSerialNumber = @SN) -- the id of the scanned serial number
	set @ChildSN = (select ChildSerialNumber from dbo.ffUnitComponent where ChildUnitID = @ChildID) -- scaneed schild serial number
	
	if @ChildSN is null
	begin
		set @ParentID = (select UnitID from dbo.ffSerialNumber where Value = @SN) -- parent id
		set @ParentSN = (select Value from dbo.ffSerialNumber where Value = @SN) -- parent serial number
		
		declare @ChildSN2 varchar(200)
		set @ChildSN2 = (select ChildSerialNumber from dbo.ffUnitComponent
						 join dbo.luPartFamily on dbo.luPartFamily.ID = dbo.ffUnitComponent.ChildPartFamilyID
						 where UnitID = @ParentID and StatusID = 0 and dbo.luPartFamily.Name like N'%PW%')	
	end 


	if @Var is not null -- this is any searched child scanned here
	begin
		select @elm = @Var
	end

	if (@Var is null and @ChildSN is not null) -- this is any child scanned in here
	begin
		select @elm =@ChildSN
	end

	if (@Var is null and @ParentSN is not null and @ChildSN2 is null) -- only for a parent that doesn't have the searched child
	begin
		select @elm = @ParentSN
	end

	if (@Var is null and @ParentSN is not null and @ChildSN2 is not null) -- any parent that have the searched child serial number
	begin
		select @elm = @ChildSN2
	end

end






