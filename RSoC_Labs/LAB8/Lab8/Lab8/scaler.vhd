-- scaler: scales an 8-bit value by right-shifting
-- 
--
-- Scaler can be used to decrease the amplitude of a signal
--
-- Scale can take values 00, 01, 10, 11. 00 and 11 correspond to output always 0, and output equal input respectively
-- Scale=10: output is right-shifted by 1 (amplitude divided by 2)
-- Scale=01: output is right-shifted by 2 (amplitude divided by 4)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scaler is
    port(
        din : in STD_LOGIC_VECTOR(7 downto 0);
        scale : in STD_LOGIC_VECTOR(1 downto 0);
        dout : out STD_LOGIC_VECTOR(7 downto 0)
    );
end scaler;

architecture Behavioral of scaler is
begin

    with scale select
        dout <=     din when "11",
                    '0'&din(7 downto 1) when "10",
                    "00"&din(7 downto 2) when "01",
                    x"00" when others;


end Behavioral;
