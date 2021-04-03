alter procedure TR (@xml1 text, @xml2 text = null, @xml3 text = null, @xml4 text = null, @xml5 text = null, @EID int,
							@xml6 text = null)
as
begin

declare @UD int
declare @ID int
declare @SID int
declare @S_ID int
declare @EnterTime date
declare @ExitTime date 
declare @E_ID int


exec XMLU @xml1, @ID = @UID output
exec XMLS @xml2, @SID = @S_ID output

set @EnterTime = getdate()
set @ExitTime = (select convert(datetime,(select LU from U where ID = @UID)))
set @Employee_ID = (select EID from U where ID = @UID)
declare @Count int = (select count(UO.TID) from dbo.ffH
join UO on UO.CurrID = H.ID
join S on S.ID = H.SID
where H.ID = @UID and UO.SID in (1, 2, 3, 4) and UOS.OSID in  (172, 86, 450)
and S.D in ('name1','name2', 'name3', 'name4') and RID = 17)


if @Count = 3
begin
	exec UNTSet @UID, 1, null, null,  @SID, @EID, @EnterTime, @ExitTime
	return 9999
end

if @Count <> 3
return 0

	
	
end
