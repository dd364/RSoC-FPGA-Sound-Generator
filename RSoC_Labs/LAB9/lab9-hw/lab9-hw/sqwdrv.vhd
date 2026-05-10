-- sqwdriver2: Square wave generator with 8-bit square wave output and 10-bit phase output 
-- Daniel Roggen, 2021
-- 
-- The top value of this signal generator is fixed to 2^24-1. 
-- The implementation relies on the wraparound of a 24-bit counter to achieve this. 
-- The increment is user-controlled.
-- An internal counter is incremented at each clock cycle by the increment.
-- The output signal is 1 when the counter is clkctr<=0x7FFFFF and 0 when clkctr>=0x800000
-- Therefore the output is a square wave with one period corresponding to the time to increment clkctr to the top value.

-- The output frequency is defined as: frq = clk*incr/top
-- The increment is defined as: incr = frq*top/clk  


-- clk: 10MHz clock recommended
-- reset: active high asynchronous reset
-- incr: increment of the phase counter
-- sqw: square wave output represented as an 8-bit number



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity sqwdriver is
    Port (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC; 
        increment : in STD_LOGIC_VECTOR(23 downto 0); 
        phase : out STD_LOGIC_VECTOR(9 downto 0);
        sqw : out STD_LOGIC_VECTOR(7 downto 0)
    );
end sqwdriver;


architecture Behavioral of sqwdriver is
    -- Internal counter
    signal clkctr: STD_LOGIC_VECTOR(23 downto 0);
    -- Register holding the output state
    signal cout : STD_LOGIC;
    -- Top value
    --signal top : STD_LOGIC_VECTOR(31 downto 0);
    -- High amplitude level
    signal high : STD_LOGIC_VECTOR(7 downto 0);

begin
    -- Frequency generator with fixed top but configurable increment
    

    

    
    -- Asynchronous reset
    process(clk,reset)                                                                           
    begin
        -- Asynchronous reset
        if reset='1' then
            clkctr<=(others=>'0');
        else    
        -- Normal operation
            if rising_edge(clk) then
                    -- Increment by the increment
                    -- This relies on wrapping around at 24 bit.
                    clkctr <= clkctr+increment;               
            end if;
        end if;
    end process;
    
    -- Compare clkctr to the half value to generate cout
    process(clk,reset,clkctr)
    begin
        if clkctr<=x"7FFFFF" then
            cout<='1';
        else
            cout<='0';
        end if; 
    end process;
 
    -- Wire up the register cout to the output sout
    -- When cout is 0 wavout should be 0. When cout is 1, wavout should be the maximum level FF 
    sqw <= cout&cout&cout&cout&cout&cout&cout&cout;
    
    -- Phase output    
    phase <= clkctr(23 downto 14);
    
    
    

end Behavioral;
