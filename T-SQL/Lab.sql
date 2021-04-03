alter procedure Lab

(
@TID int,
@elm varchar(200) output
)

as
begin
	declare @Var varchar(200)
	declare @P int
	declare @PSN varchar(200)
	declare @CID int
	declare @CSN varchar(200)

	 select @Var = CSN from dbo.Comp 
	 join SN on SN.Value = Comp.CSN
	 join F on F.ID = C.CFID
	 where CSN = @SN and F.N like N'%PW%'
	 set @CID = (select CID from Comp where CSN = @SN) 
	 set @CSN = (select CSN from Comp where CID = @CID) -
	
	if @CSN is null
	begin
		set @PID = (select ID from SN where Value = @SN) 
		set @PSN = (select Value from SN where Value = @SN) 
		
		declare @CSN2 varchar(200)
		set @CSN2 = (select CSN from Comp
			     join F on F.ID = Comp.CFID
			     where ID = @PID and SID = 0 and F.N like N'%PW%')	
	end 


	if @Var is not null -- this is any searched child scanned here
	begin
		select @elm = @Var
	end

	if (@Var is null and @CSN is not null) -- this is any child scanned in here
	begin
		select @elm =@CSN
	end

	if (@Var is null and @PSN is not null and @CSN2 is null) -- only for a parent that doesn't have the searched child
	begin
		select @elm = @PSN
	end

	if (@Var is null and @PSN is not null and @CSN2 is not null) -- any parent that have the searched child serial number
	begin
		select @elm = @CSN2
	end

end
