--  procedure for getting any specific x linked element to any scanned y element, must be in tables

alter procedure GPN 

@SN varchar(20)
@elm varchar(20) output

as
begin

declare @UID int

set @UID = (select U.ID from U
	    join P on P.ID = U.PID
	    join SN on SN.ID = U.ID
	    where SN.Value = @SN)

select @elm = (select PN from U
	       join P on P.ID = U.PID
	       where U.ID = @UID)
end
