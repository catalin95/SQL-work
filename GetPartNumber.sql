USE [TIM_FF2819_ENEL_T]
GO
/****** Object:  StoredProcedure [dbo].[udpGetPartNumber]    Script Date: 4/25/2019 9:41:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Author: Catalin Mucica
   Description: This SP should return the PartNumber for any scanned SN */

ALTER procedure [dbo].[udpGetPartNumber]

--@Label varchar(200),
@SN varchar(200),
--@TargetID int,
@elm varchar(200) output

as
begin

declare @UnitID int

set @UnitID = (select dbo.ffUnit.ID from dbo.ffUnit
			   join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
			   join dbo.ffSerialNumber on dbo.ffSerialNumber.UnitID = dbo.ffUnit.ID
			   where dbo.ffSerialNumber.Value = @SN)

select @elm = (select PartNumber from dbo.ffUnit
				   join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
				   where dbo.ffUnit.ID = @UnitID)
end

