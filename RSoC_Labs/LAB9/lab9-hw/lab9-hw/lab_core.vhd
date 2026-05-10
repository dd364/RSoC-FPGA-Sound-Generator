-- Core of the processor lab.
-- This entity is fed with a 25MHz clock, instead of the 100MHz clock of the FPGA board.
-- Reset is active high
-- Otherwise, all the pinout is identical to the top level.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;



entity lab_core is
    Port(
            clkaudio : in STD_LOGIC;
            reset : in STD_LOGIC;
            sw : in  STD_LOGIC_VECTOR (15 downto 0);
            segoutl : out STD_LOGIC_VECTOR(15 downto 0);
            segoutr : out STD_LOGIC_VECTOR(15 downto 0);
            ampPWM : out STD_LOGIC;
            ampSD: out STD_LOGIC
    );
end lab_core;

architecture something of lab_core is
    -- sqw: square wave output of sqwdriver
    signal sqw : STD_LOGIC_VECTOR(7 downto 0);
    -- sample: sample prior to scaling
    signal sample: STD_LOGIC_VECTOR(7 downto 0);
    -- wav: Sample coming from the sound font RAM
    signal wav: STD_LOGIC_VECTOR(7 downto 0);
    -- scsmpl: scaled sample
    signal scsmpl : STD_LOGIC_VECTOR(7 downto 0);    
    signal phase : STD_LOGIC_VECTOR(9 downto 0);
    signal incr : STD_LOGIC_VECTOR(23 downto 0);
    signal pwmout: STD_LOGIC;

    -- CPU I/O
    signal gpo : std_logic_vector(31 downto 0);
    signal gpi : std_logic_vector(31 downto 0);
    signal fit_i, fit_t : std_logic;
    signal io_addr_strobe : STD_LOGIC;
    signal io_read_strobe : STD_LOGIC;
    signal io_write_strobe : STD_LOGIC;
    signal io_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal io_byte_enable : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal io_write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal io_read_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal io_ready : STD_LOGIC;
    
    -- Address for sound generator (font select + sample index)
    signal address : STD_LOGIC_VECTOR(9 downto 0);
    
    -- Signals for port A of DP-RAM (processor writes)
    signal ramA_din : STD_LOGIC_VECTOR(7 downto 0);
    signal ramA_dout : STD_LOGIC_VECTOR(7 downto 0);
    signal ramA_address : STD_LOGIC_VECTOR(9 downto 0);
    signal ramA_we : STD_LOGIC;
    
begin
    
    --------------------------------------------------------------------------------------------------------------
    -- Part 2: DP-RAM Instantiation
    --------------------------------------------------------------------------------------------------------------
    comp_dpram: entity work.dpram
    generic map(AN => 10, DN => 8)
    port map(
        clk => clkaudio,
        addressA => ramA_address,
        dataA => ramA_din,
        weA => ramA_we,
        addressB => address,
        qA => ramA_dout,
        qB => wav
    );    

    --------------------------------------------------------------------------------------------------------------
    -- Part 3: MicroBlaze MCS Instantiation
    --------------------------------------------------------------------------------------------------------------
    mycpu : entity work.microblaze_mcs_0
    PORT MAP (
        Clk => clkaudio,
        Reset => reset,
        GPIO1_tri_o => gpo,
        GPIO1_tri_i => gpi,
        FIT1_Toggle => fit_t,
        FIT1_Interrupt => fit_i,
        IO_Addr_Strobe => io_addr_strobe,
        IO_Read_Strobe => io_read_strobe,
        IO_Write_Strobe => io_write_strobe,
        IO_Address => io_address,
        IO_Byte_Enable => io_byte_enable,
        IO_Write_Data => io_write_data,
        IO_Read_Data => io_read_data,
        IO_Ready => io_ready
    );
     
    -- IO bus always ready (zero wait state)
    io_ready <= '1';
    
    -- Connect switches to GPIO input
    gpi <= x"0000" & sw;
    
    --------------------------------------------------------------------------------------------------------------
    -- Part 5: Connect DP-RAM to Processor IO Bus
    --------------------------------------------------------------------------------------------------------------
    ramA_din <= io_write_data(7 downto 0);
    ramA_address <= io_address(9 downto 0);
    ramA_we <= io_write_strobe;
    io_read_data <= x"000000" & ramA_dout;
    
    --------------------------------------------------------------------------------------------------------------
    -- Sound Generator Configuration
    --------------------------------------------------------------------------------------------------------------
    
    -- FREQUENCY CONTROL: Switch-controlled frequency
    -- Multiply switch value by 64 (shift left by 6 bits)
    -- sw(7:0) = 1   → ~38 Hz
    -- sw(7:0) = 13  → ~500 Hz
    -- sw(7:0) = 255 → ~9.7 kHz
    incr <= "0000000000" & sw(7 downto 0) & "000000";
    
    -- VOLUME CONTROL: Use switches sw(15:14)
    -- 11 = 100% (max), 10 = 50%, 01 = 25%, 00 = 0%
    comp_scaler: entity work.scaler port map(din=>sample, dout=>scsmpl, scale=>sw(15 downto 14));
    
    -- Connect sample to RAM output
    sample <= wav;
    
    -- Font selection: sw(13:12) selects which 256-byte block to read
    address <= sw(13 downto 12) & phase(9 downto 2);
    
    -- Square wave generator (provides phase counter)
    comp_sqw: entity work.sqwdriver port map(clk=>clkaudio, reset=>reset, increment=>incr, sqw=>sqw, phase=>phase);
    
    -- PWM driver
    comp_pwm: entity work.pwmdriver port map(clk=>clkaudio, reset=>reset, vol=>scsmpl, pwmout=>pwmout);
    
    -- Audio outputs
    ampPWM <= pwmout;
    ampSD <= '1';   -- Amplifier always enabled
    
    -- Display GPIO on 7-segment for debugging
    segoutl(15 downto 0) <= gpo(31 downto 16);
    segoutr(15 downto 0) <= gpo(15 downto 0);

end something;