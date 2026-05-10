-- Processor template
-- Daniel Roggen, 2016-2021

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;


entity lab_top is
    Port (
				-- Board 100MHz clock
				clk : in STD_LOGIC;
    			-- Some buttons and LEDs may be handy
				led : out  STD_LOGIC_VECTOR (15 downto 0);
				sw : in STD_LOGIC_VECTOR(15 downto 0);
				btnC : in  STD_LOGIC;
				btnCpuReset : in STD_LOGIC;
				seg : out STD_LOGIC_VECTOR(6 downto 0);
				an : out STD_LOGIC_VECTOR(7 downto 0);
				ampPWM : out STD_LOGIC;
                ampSD: out STD_LOGIC
                );
end lab_top;


architecture something of lab_top is
    -- Clock and PLL
    signal clkaudio : STD_LOGIC;	        -- 200KHz clock for sound driver; obtained with clock divider
    signal reset : std_logic;   
    
       
    -- Display signals
    signal segoutl,segoutr : STD_LOGIC_VECTOR(15 downto 0);
    signal display_d7 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d6 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d5 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d4 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d3 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d2 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d1 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_d0 : STD_LOGIC_VECTOR(3 downto 0);
    signal display_blink : STD_LOGIC_VECTOR(7 downto 0);
    
        
begin
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- Instantiate the lab_core
    -- Signals: 
    --  clk: 25MHz clock
    --  clk200k: 200KHz clock
    --  reset: asynchronous reset which is active high
    --  sw: switch states
    --  segout: 32-bit signal which is displayed on the 7-segment display
    --core: entity work.lab_core port map(clkaudio=>clkaudio,reset=>reset,segoutl=>segoutl,segoutr=>segoutr,sw=>sw,ampPWM=>ampPWM,ampSD=>ampSD);
    core: entity work.lab_core port map(clkaudio=>clkaudio,reset=>reset,segoutl=>segoutl,segoutr=>segoutr,sw=>sw,ampPWM=>ampPWM,ampSD=>ampSD);
    
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER 
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- Create a 200KHz clock
    -- Divide the 100MHz clock to obtain 10MHz to drive the audio logic.
    ckdiv: entity work.ckdiv port map(clk=>clk,reset=>reset,top=>std_logic_vector(to_unsigned(4,32)),sout=>clkaudio);

      -- Create divided clocks for visualisation
    clkdiv1 : entity work.ckdiv port map(clk=>clk,reset=>reset,top=>std_logic_vector(to_unsigned(49999999,32)),sout=>led(0));
    
    -- Reset active high
    reset<=not btnCpuReset;
    
   -- Instantiate the 7-segment display
     comp_h27s: entity work.hexto7seg port map(clk=>clk,
         d7=>display_d7, 
         d6=>display_d6,
         d5=>display_d5,
         d4=>display_d4,
         d3=>display_d3,
         d2=>display_d2,
         d1=>display_d1,
         d0=>display_d0,
         blink=>display_blink,
         q=>seg,
         active=>an);
     
    -- Display multiplexers: toggle between register_addr and register_data
    display_blink <= "00000000";
    display_d7 <= segoutl(15 downto 12);
    display_d6 <= segoutl(11 downto 8);
    display_d5 <= segoutl(7 downto 4);
    display_d4 <= segoutl(3 downto 0);
    display_d3 <= segoutr(15 downto 12);
    display_d2 <= segoutr(11 downto 8);
    display_d1 <= segoutr(7 downto 4);
    display_d0 <= segoutr(3 downto 0);

    -- Some LED display  
    led(15 downto 2)<=(others=>'0');
    led(1) <= reset;
    
    

end something ;
