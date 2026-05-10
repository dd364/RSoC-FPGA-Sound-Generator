-- pwmdriver: PWM signal generator
-- Daniel Roggen, 2021
--
-- The PWM output signal has a frequency of clk/256
-- The PWM volume control goes from 0 to 255/256
--
-- For audio generation an input clock of 5-10MHz is suitable. 
-- 10MHz means PWM frequency of 39KHZ


-- clk: 10MHZ clock
-- reset: active high asynchronous reset
-- top: defines the frequency. frq = 200K/[2*(top+1)]
-- vol: defines the volume: 0 is off; 10 is maximum.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity pwmdriver is
    Port (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC; 
        vol : in STD_LOGIC_VECTOR(7 downto 0);
        pwmout : out STD_LOGIC
    );
end pwmdriver;

architecture Behavioral of pwmdriver is
    -- PWM signals: counter and resulting PWM square wave
    signal pwmctr : STD_LOGIC_VECTOR(16 downto 0);
    signal pwmsqw : STD_LOGIC;
    signal pwmvol: STD_LOGIC_VECTOR(31 downto 0);

begin
    -- PWM 
    process(clk,reset)                                                                           
    begin
        if reset='1' then
            pwmctr<=(others=>'0');
        else    
            if rising_edge(clk) then
                if pwmctr=std_logic_vector(to_unsigned(255,pwmctr'length)) then
                    pwmctr<=(others=>'0');
                else
                    pwmctr <= pwmctr+1;
                end if;                
            end if;
        end if;
    end process;     

    pwmvol <= x"000000"&vol;
    pwmout <= '1' when pwmctr<pwmvol 
                else '0';
                
       
    
   
    

end Behavioral;
