create procedure udp_power(inout number int, power int)
begin

# calculate number raised to power

    declare base int;
    declare initial int;

    set base = number;
    set initial = 0;

    while initial != power - 1
    do
        set number = number * base;
        set initial = initial + 1;
    end while;

end
