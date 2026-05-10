-- Core of the processor lab.
-- This entity is fed with a 25MHz clock, instead of the 100MHz clock of the FPGA board.
-- Reset is active high

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

library UNIFAST;
library UNIMACRO;
use UNIMACRO.Vcomponents.all;

entity lab_core is
    Port(
        clk : in STD_LOGIC;
        clk200k : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw : in  STD_LOGIC_VECTOR (15 downto 0);
        segout : out STD_LOGIC_VECTOR(31 downto 0);
        ampPWM : out STD_LOGIC;
        ampSD: out STD_LOGIC
    );
end lab_core;

architecture something of lab_core is
    -- CPU I/O
    signal gpo : std_logic_vector(31 downto 0);
    signal gpi : std_logic_vector(31 downto 0);
    signal fit_i : std_logic;
    signal fit_t : std_logic;
begin

    --------------------------------------------------------------------------------------------------------
    -- PART 6: Instantiate MicroBlaze with Timer
    --------------------------------------------------------------------------------------------------------
    comp_uc : entity work.microblaze_mcs_0
    PORT MAP (
        Clk => clk,
        Reset => reset,
        GPIO1_tri_i => gpi,
        GPIO1_tri_o => gpo,        
        FIT1_Interrupt => fit_i,
        FIT1_Toggle => fit_t
    );

    -- Connect GPIO output to 7-segment display
    segout <= gpo;

    -- Connect switches to GPIO input
    gpi <= x"0000" & sw(15 downto 0);

    --------------------------------------------------------------------------------------------------------
    -- PART 8: Sound driver with volume controlled by GPIO (gpo(19 downto 16))
    --------------------------------------------------------------------------------------------------------
    comp_snddrv : entity work.snddriver port map(
        reset => reset,
        clk => clk200k,
        top => gpo(15 downto 0),      -- Frequency from lower 16 bits
        vol => gpo(19 downto 16),     -- Volume from bits 19-16
        ampPWM => ampPWM,
        ampSD => ampSD
    );

end something;