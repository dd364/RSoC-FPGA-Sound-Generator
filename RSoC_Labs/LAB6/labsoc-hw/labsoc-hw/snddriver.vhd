-- snddriver: sound driver with PWM for amplitude control
-- Daniel Roggen, 2021
-- clk: 200KHz clock
-- reset: active high asynchronous reset
-- top: defines the frequency. frq = 200K/[2*(top+1)]
-- vol: defines the volume: 0 is off; 10 is maximum.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity snddriver is
    Port (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC; 
        top : in STD_LOGIC_VECTOR(15 downto 0); 
        vol : in STD_LOGIC_VECTOR(3 downto 0);
        ampPWM : out STD_LOGIC;
        ampSD : out STD_LOGIC
    );
end snddriver;

architecture Behavioral of snddriver is
    signal notediv : std_logic_vector(31 downto 0);
    signal aud: std_logic;
    -- PWM signals: counter and resulting PWM square wave
    signal pwmctr : STD_LOGIC_VECTOR(16 downto 0);
    signal pwmsqw : STD_LOGIC;
    signal pwmvol: STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Audio frequency generator
    notediv<=x"0000"&top;
    sndgen: entity work.ckdiv port map(clk=>clk,reset=>reset,top=>notediv,sout=>aud);

    
    -- PWM 
    process(clk,reset)                                                                           
    begin
        if reset='1' then
            pwmctr<=(others=>'0');
        else    
            if rising_edge(clk) then
                if pwmctr=std_logic_vector(to_unsigned(9,pwmctr'length)) then
                    pwmctr<=(others=>'0');
                else
                    pwmctr <= pwmctr+1;
                end if;                
            end if;
        end if;
    end process;     

    pwmvol <= x"0000000"&vol;
    pwmsqw <= '1' when pwmctr<pwmvol 
                else '0';
                
       
    ampPWM <= pwmsqw and aud;
   
    ampSD<='1';

end Behavioral;
