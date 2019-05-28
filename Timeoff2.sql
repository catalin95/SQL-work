alter procedure TimeOff2 (@xmlUnitSN text, @xmlProdOrder text = null, @xmlPart text = null, @xmlStation text = null, 
						  @EmployeeID int, @xmlExtraData text = null)

as
begin

declare @UnitID int
declare @Time_to_pass datetime 
declare @Time_of_unit datetime 
declare @Time_to_compare_with datetime
declare @Current_time datetime = getdate()
declare @T1 int = 1
declare @T2 int = 180

exec uspXMLUnit @xmlUnitSN, @UnitID output

set @Time_of_unit = (select top(1) ExitTime from dbo.ffHistory where UnitID = @UnitID order by ExitTime desc)  -- last time of unit from History
set @Time_to_compare_with = datediff(second, @Time_of_unit, @Current_time)		-- difference between last time of unit from History and current time

if @Time_to_compare_with between @T1 and @T2
begin
	return 90040011 -- must wait 3 minutes until you can scan the next unit
end
else
	return 0

end


