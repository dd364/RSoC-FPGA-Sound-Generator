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
				btnU : in  STD_LOGIC;
				btnD : in  STD_LOGIC;
				btnC : in  STD_LOGIC;
				btnL : in  STD_LOGIC;
				btnR : in  STD_LOGIC;
				btnCpuReset : in STD_LOGIC;
				seg : out STD_LOGIC_VECTOR(6 downto 0);
				an : out STD_LOGIC_VECTOR(7 downto 0);
				ampPWM : out STD_LOGIC;
			     ampSD: out STD_LOGIC
                );
end lab_top;


architecture something of lab_top is
 -- Declaration of component clock buffer
   component BUFG 
             port (O : out STD_ULOGIC; 
             I : in STD_ULOGIC); 
   end component;
   
   -- Declaration of component PLL
   component PLLE2_BASE
       generic (
           BANDWIDTH : string := "OPTIMIZED";
           CLKFBOUT_MULT : integer := 5;
           CLKFBOUT_PHASE : real := 0.000;
           CLKIN1_PERIOD : real := 0.000;
           CLKOUT0_DIVIDE : integer := 1;
           CLKOUT0_DUTY_CYCLE : real := 0.500;
           CLKOUT0_PHASE : real := 0.000;
           CLKOUT1_DIVIDE : integer := 1;
           CLKOUT1_DUTY_CYCLE : real := 0.500;
           CLKOUT1_PHASE : real := 0.000;
           CLKOUT2_DIVIDE : integer := 1;
           CLKOUT2_DUTY_CYCLE : real := 0.500;
           CLKOUT2_PHASE : real := 0.000;
           CLKOUT3_DIVIDE : integer := 1;
           CLKOUT3_DUTY_CYCLE : real := 0.500;
           CLKOUT3_PHASE : real := 0.000;
           CLKOUT4_DIVIDE : integer := 1;
           CLKOUT4_DUTY_CYCLE : real := 0.500;
           CLKOUT4_PHASE : real := 0.000;
           CLKOUT5_DIVIDE : integer := 1;
           CLKOUT5_DUTY_CYCLE : real := 0.500;
           CLKOUT5_PHASE : real := 0.000;
           DIVCLK_DIVIDE : integer := 1;
           REF_JITTER1 : real := 0.010;
           STARTUP_WAIT : string := "TRUE"
       );
       port (
           CLKFBOUT : out std_ulogic;
           CLKOUT0 : out std_ulogic;
           CLKOUT1 : out std_ulogic;
           CLKOUT2 : out std_ulogic;
           CLKOUT3 : out std_ulogic;
           CLKOUT4 : out std_ulogic;
           CLKOUT5 : out std_ulogic;
           LOCKED : out std_ulogic;
           CLKFBIN : in std_ulogic;
           CLKIN1 : in std_ulogic;
           PWRDWN : in std_ulogic;
           RST : in std_ulogic
       );
   end component PLLE2_BASE;

    -- Clock and PLL
    signal clk200k : STD_LOGIC;	        -- 200KHz clock for sound driver; obtained with clock divider
    signal clk25 : STD_LOGIC;           -- 25MHz clock for lab_core; obtained with PLL
    signal pll_fb : std_logic;
    signal pll_locked : std_logic;
    signal pll_clk : std_logic_vector(5 downto 0);
    signal reset : std_logic;   
    
       
    -- Display signals
    signal segout : STD_LOGIC_VECTOR(31 downto 0);
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
    core: entity work.lab_core port map(clk=>clk25,clk200k=>clk200k,reset=>reset,segout=>segout,sw=>sw,ampPWM=>ampPWM,ampSD=>ampSD);
    
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER 
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- Create a 200KHz clock
    -- Divide the 100MHz clock to obtain 200KHz to drive the audio logic.
    ckdiv200: entity work.ckdiv port map(clk=>clk,reset=>reset,top=>std_logic_vector(to_unsigned(249,32)),sout=>clk200k);
    
    -- Create a 25MHz clock
    pll_inst : PLLE2_BASE
    generic map (
        CLKIN1_PERIOD => 10.0,      -- 100MHz = 10ns
        CLKFBOUT_MULT => 8,         -- Multiplier
        CLKOUT0_DIVIDE => 32,    
        CLKOUT1_DIVIDE => 32,    
        CLKOUT2_DIVIDE => 32,    
        CLKOUT3_DIVIDE => 32,    
        CLKOUT4_DIVIDE => 32,    
        CLKOUT5_DIVIDE => 32,       -- Clock output divider. This circuit uses only CLKOUT5 
        DIVCLK_DIVIDE => 1 )        -- General divider. 
    port map ( 
        CLKIN1 => clk,
        CLKFBOUT => pll_fb,
        CLKFBIN => pll_fb,
        CLKOUT0 => pll_clk(0),
        CLKOUT1 => pll_clk(1),
        CLKOUT2 => pll_clk(2),
        CLKOUT3 => pll_clk(3),
        CLKOUT4 => pll_clk(4),
        CLKOUT5 => pll_clk(5),     -- This circuit uses only CLKOUT5
        LOCKED => pll_locked,
        PWRDWN => '0',
        RST => '0' );    
    clk25<=pll_clk(5);
    
    -- Create divided clocks for visualisation
    clkdiv1 : entity work.ckdiv port map(clk=>clk,reset=>reset,top=>std_logic_vector(to_unsigned(49999999,32)),sout=>led(0));
    clkdiv2 : entity work.ckdiv port map(clk=>clk25,reset=>reset,top=>std_logic_vector(to_unsigned(12499999,32)),sout=>led(1));
    
    
    -- Reset active high
    reset<=not btnCpuReset;
    
   -- Instantiate the 7-segment display
     comp_h27s: entity work.hexto7seg port map(clk=>clk25,
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
    display_d7 <= segout(31 downto 28);
    display_d6 <= segout(27 downto 24);
    display_d5 <= segout(23 downto 20);
    display_d4 <= segout(19 downto 16);
    display_d3 <= segout(15 downto 12);
    display_d2 <= segout(11 downto 8);
    display_d1 <= segout(7 downto 4);
    display_d0 <= segout(3 downto 0);

    -- Some LED display  
    led(15 downto 4)<=(others=>'0');
    led(3) <= '0'; -- fit_toggle 
    led(2) <= reset;
    
    

end something ;
