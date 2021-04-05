create procedure udp_logarithm(base int, number int, inout counter int)
begin

	declare initial int;
    set initial = 1;
    
    while initial < number
    do
		set initial = initial * base;
        set counter = counter + 1;
        
	end while;


end