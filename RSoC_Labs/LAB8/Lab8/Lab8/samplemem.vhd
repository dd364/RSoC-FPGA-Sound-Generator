-- samplemem: sound font ROM with 4 instruments
-- Address: 10 bits (font_select(1) & font_select(0) & sample_index(7 downto 0))
-- Font 0: Violin (addresses 0-255)
-- Font 1: Electric Guitar (addresses 256-511)
-- Font 2: Clarinet (addresses 512-767)
-- Font 3: Cello (addresses 768-1023)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY samplemem IS
    PORT
    (
        addressA: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        qA: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END samplemem;

ARCHITECTURE rtl OF samplemem IS
    TYPE mem IS ARRAY(0 TO 1023) OF std_logic_vector(7 DOWNTO 0);
    
    SIGNAL ram_block : mem := (
        -- FONT 0: VIOLIN (addresses 0-255)
        x"74", x"75", x"76", x"74", x"74", x"76", x"7D", x"8C", x"9D", x"AF", x"C3", x"D7", x"E9", x"F7", x"FF", x"FE",
        x"F7", x"EA", x"DB", x"C9", x"B7", x"A8", x"9C", x"93", x"90", x"93", x"9B", x"A7", x"B5", x"C2", x"CD", x"D8",
        x"DE", x"DF", x"DF", x"DF", x"E0", x"E1", x"E3", x"E4", x"E2", x"DC", x"D3", x"C7", x"B9", x"A9", x"98", x"87",
        x"76", x"64", x"51", x"3F", x"30", x"27", x"22", x"1F", x"1E", x"1F", x"21", x"23", x"24", x"26", x"27", x"27",
        x"26", x"23", x"1F", x"19", x"13", x"0C", x"06", x"01", x"00", x"00", x"02", x"08", x"11", x"1C", x"2A", x"37",
        x"44", x"50", x"5B", x"65", x"6C", x"6F", x"6F", x"6E", x"6C", x"69", x"66", x"62", x"5E", x"58", x"53", x"4E",
        x"49", x"45", x"45", x"49", x"50", x"5C", x"68", x"75", x"83", x"90", x"9C", x"A5", x"AC", x"B0", x"B2", x"B2",
        x"B2", x"B0", x"AE", x"AB", x"A8", x"A3", x"9E", x"99", x"94", x"91", x"8E", x"8D", x"8D", x"8D", x"8D", x"8C",
        x"8B", x"89", x"87", x"86", x"84", x"84", x"83", x"84", x"86", x"89", x"8D", x"92", x"96", x"9A", x"9D", x"9D",
        x"99", x"93", x"8B", x"82", x"79", x"72", x"6C", x"6B", x"6D", x"72", x"79", x"80", x"87", x"8D", x"91", x"92",
        x"92", x"90", x"8E", x"8C", x"8A", x"8A", x"89", x"89", x"88", x"86", x"83", x"7E", x"79", x"74", x"6F", x"6B",
        x"69", x"6A", x"6C", x"6F", x"72", x"75", x"76", x"75", x"74", x"71", x"6D", x"6A", x"66", x"64", x"62", x"61",
        x"62", x"63", x"65", x"67", x"69", x"6B", x"6D", x"6E", x"6F", x"70", x"71", x"72", x"72", x"72", x"72", x"72",
        x"71", x"70", x"6E", x"6B", x"68", x"64", x"5E", x"59", x"57", x"57", x"58", x"58", x"5A", x"5A", x"5A", x"59",
        x"57", x"52", x"4C", x"44", x"3A", x"2F", x"25", x"1E", x"17", x"13", x"14", x"19", x"21", x"2D", x"38", x"43",
        x"4D", x"53", x"54", x"53", x"4D", x"45", x"3E", x"39", x"36", x"39", x"41", x"4A", x"56", x"60", x"68", x"70",
        
        -- FONT 1: ELECTRIC GUITAR (addresses 256-511)
        x"A8", x"FE", x"F3", x"F8", x"F5", x"F7", x"F6", x"F7", x"F6", x"F6", x"F6", x"F6", x"F6", x"F5", x"F5", x"F0",
        x"C0", x"91", x"74", x"61", x"59", x"59", x"60", x"6E", x"82", x"9A", x"B5", x"CE", x"EA", x"F3", x"F6", x"F0",
        x"FA", x"A2", x"0A", x"0F", x"0B", x"0E", x"0C", x"0D", x"0C", x"0D", x"0D", x"0D", x"0F", x"0E", x"10", x"0E",
        x"30", x"71", x"A6", x"D9", x"F6", x"F6", x"F6", x"F6", x"F6", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5",
        x"F4", x"F4", x"F3", x"F3", x"F3", x"F4", x"D6", x"AF", x"98", x"8B", x"89", x"8D", x"99", x"A9", x"C0", x"D7",
        x"F1", x"EF", x"F8", x"CE", x"18", x"09", x"0B", x"0B", x"0B", x"0A", x"0A", x"0A", x"0A", x"0A", x"0B", x"0B",
        x"0D", x"0B", x"2B", x"60", x"86", x"A0", x"AA", x"AC", x"A4", x"98", x"85", x"6E", x"54", x"39", x"1E", x"0D",
        x"0F", x"0C", x"11", x"2B", x"C9", x"FF", x"F1", x"F8", x"F4", x"F6", x"F5", x"F6", x"F5", x"F5", x"F5", x"F5",
        x"F4", x"F4", x"F3", x"F5", x"E4", x"BB", x"A0", x"90", x"89", x"89", x"90", x"9D", x"AF", x"C4", x"DC", x"F1",
        x"F3", x"F3", x"F3", x"F2", x"F2", x"F2", x"F2", x"F2", x"F1", x"F1", x"F1", x"F1", x"F0", x"F0", x"F0", x"F0",
        x"F0", x"F0", x"F0", x"EF", x"EF", x"EF", x"EF", x"EE", x"EE", x"EE", x"EE", x"EE", x"ED", x"ED", x"ED", x"ED",
        x"EC", x"EC", x"EB", x"EB", x"EA", x"E8", x"E5", x"E3", x"E2", x"E0", x"DD", x"DA", x"D6", x"D0", x"C6", x"B8",
        x"9F", x"70", x"19", x"00", x"03", x"01", x"02", x"02", x"02", x"02", x"02", x"02", x"02", x"02", x"03", x"03",
        x"04", x"03", x"04", x"02", x"10", x"2A", x"38", x"3D", x"38", x"2D", x"1A", x"07", x"05", x"05", x"05", x"06",
        x"06", x"06", x"06", x"06", x"07", x"07", x"07", x"08", x"08", x"08", x"08", x"09", x"09", x"09", x"09", x"0A",
        x"0B", x"0B", x"0B", x"0B", x"0B", x"0C", x"0C", x"0C", x"0C", x"0C", x"0D", x"0D", x"0F", x"0D", x"11", x"0A",
        
        -- FONT 2: CLARINET (addresses 512-767)
        x"75", x"78", x"7C", x"80", x"83", x"86", x"89", x"8C", x"8F", x"90", x"92", x"94", x"96", x"95", x"94", x"91",
        x"8F", x"8D", x"89", x"87", x"86", x"85", x"85", x"87", x"8A", x"8E", x"93", x"98", x"9E", x"A3", x"AB", x"B1",
        x"B7", x"BD", x"C3", x"C8", x"CD", x"D2", x"D6", x"DA", x"DF", x"E4", x"E8", x"EC", x"F0", x"F5", x"F9", x"FA",
        x"FD", x"FF", x"FD", x"FA", x"F7", x"F3", x"ED", x"E6", x"DF", x"D9", x"D2", x"CC", x"C7", x"C1", x"BC", x"B7",
        x"B2", x"AC", x"A7", x"A2", x"9E", x"99", x"94", x"90", x"8B", x"86", x"80", x"7B", x"76", x"71", x"6C", x"69",
        x"65", x"61", x"5F", x"5E", x"5D", x"5C", x"5C", x"5B", x"5A", x"59", x"58", x"57", x"56", x"55", x"56", x"57",
        x"59", x"5C", x"60", x"64", x"67", x"6B", x"70", x"76", x"7A", x"7E", x"81", x"84", x"86", x"87", x"88", x"87",
        x"86", x"85", x"84", x"81", x"80", x"7F", x"7E", x"7D", x"7C", x"7C", x"7C", x"7B", x"7A", x"78", x"76", x"73",
        x"70", x"6D", x"6A", x"67", x"64", x"62", x"60", x"5F", x"5D", x"5C", x"5C", x"5B", x"5A", x"5A", x"5A", x"58",
        x"56", x"55", x"54", x"52", x"50", x"4E", x"4F", x"4E", x"4D", x"4B", x"4B", x"4A", x"49", x"48", x"46", x"43",
        x"40", x"3B", x"37", x"32", x"2C", x"27", x"21", x"1C", x"17", x"14", x"11", x"0D", x"0B", x"0A", x"09", x"07",
        x"05", x"04", x"03", x"02", x"02", x"01", x"00", x"00", x"00", x"01", x"02", x"04", x"07", x"09", x"0C", x"10",
        x"14", x"19", x"1E", x"24", x"2A", x"30", x"38", x"40", x"46", x"4E", x"56", x"5E", x"66", x"6D", x"75", x"7D",
        x"84", x"8C", x"93", x"9A", x"9F", x"A4", x"A7", x"AB", x"AD", x"AF", x"AF", x"B0", x"AF", x"AD", x"AA", x"A7",
        x"A3", x"9E", x"9A", x"94", x"90", x"8B", x"87", x"83", x"80", x"7C", x"78", x"74", x"71", x"6E", x"69", x"66",
        x"63", x"62", x"5F", x"5D", x"5B", x"5B", x"5B", x"5B", x"5C", x"5D", x"5F", x"62", x"65", x"69", x"6C", x"70",
        
        -- FONT 3: CELLO (addresses 768-1023)
        x"78", x"7B", x"81", x"85", x"8A", x"91", x"96", x"97", x"96", x"94", x"92", x"8F", x"8B", x"87", x"85", x"86",
        x"8C", x"97", x"A5", x"B0", x"B9", x"C1", x"C5", x"C6", x"C5", x"C9", x"D0", x"D9", x"E6", x"F3", x"FD", x"FF",
        x"FA", x"F3", x"EE", x"EA", x"E3", x"DB", x"D4", x"CF", x"CB", x"C5", x"BF", x"B8", x"B1", x"AB", x"A4", x"9B",
        x"90", x"85", x"79", x"6D", x"61", x"58", x"53", x"51", x"4B", x"43", x"37", x"2A", x"1B", x"0E", x"05", x"00",
        x"00", x"04", x"0A", x"0C", x"0E", x"11", x"14", x"12", x"0E", x"0B", x"0A", x"0B", x"12", x"1D", x"26", x"2F",
        x"35", x"32", x"2C", x"27", x"22", x"21", x"22", x"28", x"2E", x"33", x"37", x"3C", x"40", x"44", x"49", x"4E",
        x"53", x"5A", x"5F", x"67", x"74", x"7F", x"84", x"87", x"8D", x"93", x"96", x"99", x"9C", x"9D", x"9A", x"96",
        x"94", x"91", x"8D", x"8B", x"8A", x"87", x"80", x"77", x"6E", x"68", x"63", x"61", x"62", x"66", x"68", x"66",
        x"64", x"63", x"62", x"61", x"61", x"65", x"6D", x"76", x"80", x"8A", x"90", x"95", x"94", x"92", x"90", x"90",
        x"96", x"96", x"9A", x"9A", x"9C", x"A4", x"A5", x"A9", x"A8", x"A8", x"AB", x"AC", x"AD", x"B0", x"BA", x"C1",
        x"C5", x"C2", x"CA", x"CB", x"CB", x"CC", x"C6", x"C3", x"BA", x"B7", x"B0", x"A3", x"A1", x"9F", x"97", x"89",
        x"77", x"6C", x"62", x"5F", x"62", x"6C", x"76", x"7E", x"81", x"81", x"7D", x"76", x"76", x"78", x"80", x"8C",
        x"95", x"A3", x"AA", x"A7", x"9B", x"88", x"77", x"67", x"5A", x"52", x"4E", x"4B", x"42", x"37", x"2A", x"1F",
        x"15", x"0F", x"10", x"17", x"20", x"27", x"33", x"3C", x"43", x"46", x"49", x"4E", x"53", x"58", x"5F", x"67",
        x"71", x"76", x"79", x"77", x"71", x"6E", x"6E", x"70", x"74", x"7E", x"8A", x"90", x"90", x"8A", x"84", x"80",
        x"7B", x"76", x"74", x"76", x"76", x"74", x"71", x"6F", x"6A", x"67", x"68", x"6A", x"6D", x"71", x"74", x"77"
    );
    
BEGIN
    qA <= ram_block(to_integer(unsigned(addressA)));
END rtl;