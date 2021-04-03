alter procedure CDEL -- procedure for removing the link between 2 components and keep treack of the removed link
(@xml1 text,
@xml2 text = null,
@xml3 text = null,
@xml4 text = null,
@xml5 text = null,
@xml6 text = null,
@Emp int = 0,
@xml7 text = null)

as
begin

declare @UID int
declare @ID Int
declare @OldS varchar(max)
declare @Old_pID int
declare @Old_pSN varchar(max)
declare @Old_pPN varchar(max)

exec uspxmlU @xmlSN, @ID = @UnitID output 


if @UID in (select CID from Comp) 
begin
	
	set @OldS = (select Value from U
		     join SN on SN.ID = U.ID
		     where U.ID = @UID
	set @Old_pID = (select UID from Comp where CID = @UID)
	set @Old_pSN = (select Value from SN where UID = @Old_pID)
	set @Old_pPN = (select PN from U 
			join P on P.ID = U.PID
  			where U.ID = @Old_pID) 

	insert into S_History values ((select @OldS), (select @Old_pSN), (select @Old_pPN)) 

	update Comp set StatusID = 1 where CID = @UID 
	delete from U where ID = @UID
	delete from D where ID = @UID 
	delete from Comp where CID = @UID
	delete from SN where UID = @UID 
end
else
	return 99
end

