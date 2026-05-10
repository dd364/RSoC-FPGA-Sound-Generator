-- Clock divider

--
-- The output signal cout toggles at a frequency fout = clk/[2*(1+top)]
--
-- Inputs:
--  reset: active high, asynchronous
--  clk: active edge is rising edge
--  top: value up to which the internal counter counts before toggling sout. The internal counter counts in the range [0;top] inclusive. Defines the frequency of the output.
-- Outputs: 
--  sout: Output signal. It starts at high on reset; frequency of sout: clk/[2*(1+top)]

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;


entity ckdiv is
    Port(
        clk: in STD_LOGIC;
        reset : in STD_LOGIC;
        top : in STD_LOGIC_VECTOR(31 downto 0);
        sout : out STD_LOGIC  
        );
end ckdiv;

architecture Behavioral of ckdiv is
    -- Internal counter
    signal clkctr: STD_LOGIC_VECTOR(31 downto 0);
    -- Register holding the output state
    signal cout : STD_LOGIC;
begin

    -- Asynchronous reset
    process(clk,reset)                                                                           
    begin
        -- Asynchronous reset
        if reset='1' then
            clkctr<=(others=>'0');
            -- Start with high state so that the first rising edge is after the period 2*(1+top) clocks  
            cout<='1';
        else    
        -- Normal operation
            if rising_edge(clk) then
                -- Compare the counter to the top value
                if clkctr >= top then  -- Changed from '=' to '>='
                    -- Once top value reached reset the counter and toggle the cout register
                    clkctr <= (others=>'0');
                    cout <= not cout;
                else
                    -- Increment by one until the top value is reached
                    clkctr <= clkctr + 1;
                end if;
            end if;
        end if;
    end process;
 
    -- Wire up the register cout to the output sout
    sout <= cout;


end Behavioral;
