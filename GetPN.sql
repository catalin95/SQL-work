use Database_name
go
/****** Object:  storedprocedure dbo.udpGetPN   
set ansi_nulls on
go
set quoted_identifier on
go

/* Author: Catalin Mucica
   Description: This SP should return the PN for any scanned SN */

alter procedure dbo.udpGetPN

--@Label varchar(200),
@SN varchar(200),
--@TargetID int,
@elm varchar(200) output

as
begin

declare @UnitID int

set @UnitID = (select dbo.ffUnit.ID from dbo.ffUnit
			   join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
			   join dbo.ffSN on dbo.ffSN.ID = dbo.ffUnit.ID
			   where dbo.ffSN.Value = @SN)

select @elm = (select PN from dbo.ffUnit
				   join dbo.ffPart on dbo.ffPart.ID = dbo.ffUnit.PartID
				   where dbo.ffUnit.ID = @UnitID)
end

