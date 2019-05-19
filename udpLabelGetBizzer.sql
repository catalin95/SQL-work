USE Database_name
GO
/****** Object:  StoredProcedure [dbo].[udpLabelGetBizzer]    
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Author: Catalin Mucica
   Description: This SP should return any child SN scanned if it is from any family that has in his description 'x = any searched info'; if this condition is not met should return the scanned SN
				If by any means the scanned SN is a parent that has any child that if from any family that has in his description "x", should return the specific child SN */

ALTER procedure dbo.Label

(
@Label varchar(200),
@SN varchar(200),
@TargetID int,
@elm varchar(200) output


)
as
begin
	declare @Var varchar(200)
	declare @Parent int
	declare @ParentSN varchar(200)
	declare @ChildID int
	declare @ChildSN varchar(200)

	 select @Var =  dbo.Component.ChildSN from dbo.Component -- set @elm to the value of any input SN that is a Child Serial Number from any family with "PW" in name
					join dbo.SN on dbo.SN.Value = dbo.Component.ChildSN
					join dbo.Family on dbo.Family.ID = dbo.Component.ChildFamilyID
					where ChildSN = @SN and dbo.Family.Name like N'%PW%'
	set @ChildID = (select ChildID from dbo.Component where ChildSN = @SN) -- the id of the scanned serial number
	set @ChildSN = (select ChildSN from dbo.Component where ChildID = @ChildID) -- scaneed schild serial number
	
	if @ChildSN is null
	begin
		set @ParentID = (select ID from dbo.SN where Value = @SN) -- parent id
		set @ParentSN = (select Value from dbo.SN where Value = @SN) -- parent serial number
		
		declare @ChildSN2 varchar(200)
		set @ChildSN2 = (select ChildSN from dbo.Component
						 join dbo.Family on dbo.Family.ID = dbo.Component.ChildFamilyID
						 where ID = @ParentID and StatusID = 0 and dbo.Family.Name like N'%PW%')	
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






