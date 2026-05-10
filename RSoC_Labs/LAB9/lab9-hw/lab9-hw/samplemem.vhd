-- samplemem: sound font ROM
-- Asynchronous read ROM
-- Daniel Roggen, 2021

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY samplemem IS
    PORT
    (
        qA:     OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --------------------------------------------------------------------------------------------------------------------------
        -- Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  -   
        --------------------------------------------------------------------------------------------------------------------------
        -- 5.4 Change the address size
        -- Instead of 256 bytes (8 bit address) we need 1024 bytes (10 bit address)
        -- Modify the following line to make addressA 10 bit
        --  
        --addressA:  IN   STD_LOGIC_VECTOR(7 downto 0)        
        addressA:  IN   STD_LOGIC_VECTOR(9 downto 0)        
    );
END samplemem;



ARCHITECTURE rtl OF samplemem IS
    --------------------------------------------------------------------------------------------------------------------------
    -- Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  -   
    --------------------------------------------------------------------------------------------------------------------------
    -- 5.5 Change the memory array size.
    -- Instead of a 256 bytes array, we need a 1024 bytes array.
    -- Modify the array declaration to 1024 bytes long
    -- Modify the following line
    -- 
    --TYPE mem IS ARRAY(0 TO 255) OF std_logic_vector(7 DOWNTO 0);  
    TYPE mem IS ARRAY(0 TO 1023) OF std_logic_vector(7 DOWNTO 0);
    
    
    SIGNAL ram_block : mem
    
--                ; 

-- Either leave the memory empty (semicolon above) 
-- Or put the initial content of the memory here, by removing the semicolon above and using the := (....); statement 
-- Make sure the correct number of data is provided!
-- := (
--    x"00", x"00", ....
--    );

    --------------------------------------------------------------------------------------------------------------------------
    -- Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  - Part 4  -  
    --------------------------------------------------------------------------------------------------------------------------
    -- 4.1 Use Matlab to generate a sine wave using the script x1.m
    -- Matlab will generate a few lines of text which can be used to initialise the ROM content.
    --
    -- 4.2 Comment out the all-zero initialisation hereafter
    --
    
--	:= (
--	x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",  
--	x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
--	x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
--	x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"
--	);

    -- 4.3. Cosine wave
    -- Copy/pase the ROM initialisation code that matlab generated. This is a single period of a cosine wave.
	:= (
	x"FE", x"FD", x"FD", x"FD", x"FD", x"FD", x"FC", x"FC", x"FB", x"FA", x"FA", x"F9", x"F8", x"F7", x"F6", x"F5", x"F4", x"F3", x"F1", x"F0", x"EF", x"ED", x"EB", x"EA", x"E8", x"E6", x"E5", x"E3", x"E1", x"DF", x"DD", x"DA", x"D8", x"D6", x"D4", x"D1", x"CF", x"CD", x"CA", x"C8", x"C5", x"C2", x"C0", x"BD", x"BA", x"B8", x"B5", x"B2", x"AF", x"AC", x"A9", x"A6", x"A3", x"A0", x"9D", x"9A", x"97", x"94", x"91", x"8E", x"8B", x"88", x"85", x"82", 
	x"7F", x"7B", x"78", x"75", x"72", x"6F", x"6C", x"69", x"66", x"63", x"60", x"5D", x"5A", x"57", x"54", x"51", x"4E", x"4B", x"48", x"45", x"43", x"40", x"3D", x"3B", x"38", x"35", x"33", x"30", x"2E", x"2C", x"29", x"27", x"25", x"23", x"20", x"1E", x"1C", x"1A", x"18", x"17", x"15", x"13", x"12", x"10", x"0E", x"0D", x"0C", x"0A", x"09", x"08", x"07", x"06", x"05", x"04", x"03", x"03", x"02", x"01", x"01", x"00", x"00", x"00", x"00", x"00", 
	x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"01", x"02", x"03", x"03", x"04", x"05", x"06", x"07", x"08", x"09", x"0A", x"0C", x"0D", x"0E", x"10", x"12", x"13", x"15", x"17", x"18", x"1A", x"1C", x"1E", x"20", x"23", x"25", x"27", x"29", x"2C", x"2E", x"30", x"33", x"35", x"38", x"3B", x"3D", x"40", x"43", x"45", x"48", x"4B", x"4E", x"51", x"54", x"57", x"5A", x"5D", x"60", x"63", x"66", x"69", x"6C", x"6F", x"72", x"75", x"78", x"7B", 
	x"7E", x"82", x"85", x"88", x"8B", x"8E", x"91", x"94", x"97", x"9A", x"9D", x"A0", x"A3", x"A6", x"A9", x"AC", x"AF", x"B2", x"B5", x"B8", x"BA", x"BD", x"C0", x"C2", x"C5", x"C8", x"CA", x"CD", x"CF", x"D1", x"D4", x"D6", x"D8", x"DA", x"DD", x"DF", x"E1", x"E3", x"E5", x"E6", x"E8", x"EA", x"EB", x"ED", x"EF", x"F0", x"F1", x"F3", x"F4", x"F5", x"F6", x"F7", x"F8", x"F9", x"FA", x"FA", x"FB", x"FC", x"FC", x"FD", x"FD", x"FD", x"FD", x"FD"
	--);
	
	--------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------
    -- Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  - Part 5  -   
    --------------------------------------------------------------------------------------------------------------------------
    -- 5.6 Add 3 new sound fonts generated from matlab.
    -- Make sure to adjust the :=, opening/closing parenthesis and comma to append all the 4 sound fonts (the previous cosine and the 3 new ones) in the memory initialisation (this requires to change 4.2)
    -- Copy/paste/adapt the initialisation code from Matlab
    --
    -- x"..", x".., .....
    --
----------------------------
-- File: AKWF_cello_0001.wav
--
	--:= (
	,
	x"78", x"7B", x"81", x"85", x"8A", x"91", x"96", x"97", x"96", x"94", x"92", x"8F", x"8B", x"87", x"85", x"86", x"8C", x"97", x"A5", x"B0", x"B9", x"C1", x"C5", x"C6", x"C5", x"C9", x"D0", x"D9", x"E6", x"F3", x"FD", x"FF", x"FA", x"F3", x"EE", x"EA", x"E3", x"DB", x"D4", x"CF", x"CB", x"C5", x"BF", x"B8", x"B1", x"AB", x"A4", x"9B", x"90", x"85", x"79", x"6D", x"61", x"58", x"53", x"51", x"4B", x"43", x"37", x"2A", x"1B", x"0E", x"05", x"00", 
	x"00", x"04", x"0A", x"0C", x"0E", x"11", x"14", x"12", x"0E", x"0B", x"0A", x"0B", x"12", x"1D", x"26", x"2F", x"35", x"32", x"2C", x"27", x"22", x"21", x"22", x"28", x"2E", x"33", x"37", x"3C", x"40", x"44", x"49", x"4E", x"53", x"5A", x"5F", x"67", x"74", x"7F", x"84", x"87", x"8D", x"93", x"96", x"99", x"9C", x"9D", x"9A", x"96", x"94", x"91", x"8D", x"8B", x"8A", x"87", x"80", x"77", x"6E", x"68", x"63", x"61", x"62", x"66", x"68", x"66", 
	x"64", x"63", x"62", x"61", x"61", x"65", x"6D", x"76", x"80", x"8A", x"90", x"95", x"94", x"92", x"90", x"90", x"96", x"96", x"9A", x"9A", x"9C", x"A4", x"A5", x"A9", x"A8", x"A8", x"AB", x"AC", x"AD", x"B0", x"BA", x"C1", x"C5", x"C2", x"CA", x"CB", x"CB", x"CC", x"C6", x"C3", x"BA", x"B7", x"B0", x"A3", x"A1", x"9F", x"97", x"89", x"77", x"6C", x"62", x"5F", x"62", x"6C", x"76", x"7E", x"81", x"81", x"7D", x"76", x"76", x"78", x"80", x"8C", 
	x"95", x"A3", x"AA", x"A7", x"9B", x"88", x"77", x"67", x"5A", x"52", x"4E", x"4B", x"42", x"37", x"2A", x"1F", x"15", x"0F", x"10", x"17", x"20", x"27", x"33", x"3C", x"43", x"46", x"49", x"4E", x"53", x"58", x"5F", x"67", x"71", x"76", x"79", x"77", x"71", x"6E", x"6E", x"70", x"74", x"7E", x"8A", x"90", x"90", x"8A", x"84", x"80", x"7B", x"76", x"74", x"76", x"76", x"74", x"71", x"6F", x"6A", x"67", x"68", x"6A", x"6D", x"71", x"74", x"77"
	--);


----------------------------
-- File: AKWF_clarinett_0001.wav
--
	--:= (
	,
	x"75", x"78", x"7C", x"80", x"83", x"86", x"89", x"8C", x"8F", x"90", x"92", x"94", x"96", x"95", x"94", x"91", x"8F", x"8D", x"89", x"87", x"86", x"85", x"85", x"87", x"8A", x"8E", x"93", x"98", x"9E", x"A3", x"AB", x"B1", x"B7", x"BD", x"C3", x"C8", x"CD", x"D2", x"D6", x"DA", x"DF", x"E4", x"E8", x"EC", x"F0", x"F5", x"F9", x"FA", x"FD", x"FF", x"FD", x"FA", x"F7", x"F3", x"ED", x"E6", x"DF", x"D9", x"D2", x"CC", x"C7", x"C1", x"BC", x"B7", 
	x"B2", x"AC", x"A7", x"A2", x"9E", x"99", x"94", x"90", x"8B", x"86", x"80", x"7B", x"76", x"71", x"6C", x"69", x"65", x"61", x"5F", x"5E", x"5D", x"5C", x"5C", x"5B", x"5A", x"59", x"58", x"57", x"56", x"55", x"56", x"57", x"59", x"5C", x"60", x"64", x"67", x"6B", x"70", x"76", x"7A", x"7E", x"81", x"84", x"86", x"87", x"88", x"87", x"86", x"85", x"84", x"81", x"80", x"7F", x"7E", x"7D", x"7C", x"7C", x"7C", x"7B", x"7A", x"78", x"76", x"73", 
	x"70", x"6D", x"6A", x"67", x"64", x"62", x"60", x"5F", x"5D", x"5C", x"5C", x"5B", x"5A", x"5A", x"5A", x"58", x"56", x"55", x"54", x"52", x"50", x"4E", x"4F", x"4E", x"4D", x"4B", x"4B", x"4A", x"49", x"48", x"46", x"43", x"40", x"3B", x"37", x"32", x"2C", x"27", x"21", x"1C", x"17", x"14", x"11", x"0D", x"0B", x"0A", x"09", x"07", x"05", x"04", x"03", x"02", x"02", x"01", x"00", x"00", x"00", x"01", x"02", x"04", x"07", x"09", x"0C", x"10", 
	x"14", x"19", x"1E", x"24", x"2A", x"30", x"38", x"40", x"46", x"4E", x"56", x"5E", x"66", x"6D", x"75", x"7D", x"84", x"8C", x"93", x"9A", x"9F", x"A4", x"A7", x"AB", x"AD", x"AF", x"AF", x"B0", x"AF", x"AD", x"AA", x"A7", x"A3", x"9E", x"9A", x"94", x"90", x"8B", x"87", x"83", x"80", x"7C", x"78", x"74", x"71", x"6E", x"69", x"66", x"63", x"62", x"5F", x"5D", x"5B", x"5B", x"5B", x"5B", x"5C", x"5D", x"5F", x"62", x"65", x"69", x"6C", x"70"
	--);


----------------------------
-- File: AKWF_ebass_0001.wav
--
	--:= (
	,
	x"7A", x"7F", x"86", x"8C", x"92", x"98", x"9E", x"A4", x"A9", x"AF", x"B4", x"B9", x"BE", x"C3", x"C8", x"CD", x"D2", x"D6", x"DB", x"DF", x"E2", x"E5", x"E9", x"EB", x"EE", x"F1", x"F3", x"F5", x"F8", x"FA", x"FB", x"FD", x"FE", x"FE", x"FF", x"FE", x"FE", x"FD", x"FD", x"FC", x"FB", x"FA", x"F9", x"F8", x"F7", x"F5", x"F3", x"F1", x"EE", x"EB", x"E9", x"E5", x"E2", x"DF", x"DC", x"D8", x"D5", x"D1", x"CD", x"C9", x"C5", x"C0", x"BC", x"B8", 
	x"B4", x"B0", x"AB", x"A8", x"A4", x"A0", x"9C", x"97", x"93", x"8F", x"8A", x"85", x"81", x"7C", x"78", x"73", x"6F", x"6C", x"68", x"65", x"62", x"60", x"5E", x"5B", x"5A", x"58", x"56", x"55", x"54", x"53", x"52", x"51", x"51", x"50", x"50", x"50", x"50", x"50", x"50", x"51", x"52", x"53", x"55", x"56", x"58", x"5A", x"5C", x"5E", x"5F", x"60", x"61", x"61", x"60", x"60", x"5E", x"5C", x"5A", x"58", x"55", x"51", x"4E", x"4A", x"46", x"43", 
	x"3E", x"3A", x"36", x"31", x"2D", x"28", x"23", x"1E", x"1A", x"15", x"11", x"0D", x"09", x"06", x"03", x"01", x"00", x"00", x"00", x"01", x"03", x"06", x"0A", x"0F", x"15", x"1B", x"22", x"2A", x"32", x"3B", x"44", x"4E", x"58", x"62", x"6C", x"76", x"80", x"89", x"93", x"9C", x"A5", x"AD", x"B5", x"BC", x"C2", x"C8", x"CD", x"D1", x"D5", x"D8", x"DA", x"DC", x"DC", x"DC", x"DC", x"DA", x"D8", x"D6", x"D2", x"CE", x"CA", x"C5", x"C0", x"BA", 
	x"B4", x"AD", x"A6", x"9F", x"98", x"91", x"89", x"81", x"7A", x"72", x"6B", x"63", x"5C", x"55", x"4E", x"47", x"41", x"3A", x"34", x"2F", x"29", x"24", x"1F", x"1B", x"16", x"13", x"0F", x"0C", x"0A", x"07", x"06", x"04", x"03", x"02", x"02", x"02", x"03", x"03", x"05", x"06", x"08", x"0A", x"0D", x"10", x"13", x"16", x"19", x"1D", x"21", x"26", x"2A", x"2F", x"34", x"3A", x"3F", x"45", x"4A", x"50", x"56", x"5C", x"62", x"68", x"6E", x"74"
	);
    
    --------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------

	
	-- Hint at distributed or block memory
	--attribute ram_style : string;
    --attribute ram_style of ram_block : signal is "distributed";
    --attribute ram_style of ram_block : signal is "block";

BEGIN
   qA <= ram_block(to_integer(unsigned(addressA)));

END rtl;

