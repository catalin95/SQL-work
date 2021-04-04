alter procedure Ti (@xml1 text, @xml2 text = null, @xml3 text = null, @xml4 text = null, 
						  @EID int, @xml5 text = null)

as
begin

declare @UID int
declare @Time_to_pass datetime 
declare @Time_of datetime 
declare @Time_to_compare_with datetime
declare @Current_time datetime = getdate()
declare @T1 int = 1
declare @T2 int = 180

exec XMLU @xml1, @UID output

set @Time_of_unit = (select top(1) ExitTime from H where UID = @UID order by ExitTime desc)  --last exit time registered in History
set @Time_to_compare_with = datediff(second, @Time_of, @Current_time)		-- difference between last time of unit from History and current time

if @Time_to_compare_with between @T1 and @T2
begin
	return 900 -- must wait the difference
end
else
	return 0

end

