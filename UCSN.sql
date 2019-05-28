use Database_name
go

alter procedure UCSN  -- update any linked x element for any y input element
(@xml1 text,
@xml2 text = null,
@xml3 text = null,
@xml4 text = null,
@xml5 text = null)

as 
begin

declare @ID int
declare @UID int
declare @S varchar(max)

exec XMLU @xml1, @ID = @UID

if @UID in(select CID from Comp where CID = @UID)
begin
	set @S = (select SN.Value from SN where UID = @UID)
	update Comp set SID = 1 where CID = @UID
	update SN set SN.Value = (@S + '_old') where UID = @UID
end
else
	return 98
end

