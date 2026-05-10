-- Core of the sound font / memory lab.
--
-- This entity is fed with a 10MHz clock
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
    -- sample: sample prior to scaling. Will be either a square wave, triangular wave, or coming from the ROM sound bank
    signal sample: STD_LOGIC_VECTOR(7 downto 0);
    -- sample: Sample coming from the sound font ROM
    signal wav: STD_LOGIC_VECTOR(7 downto 0);
    -- scsmpl: scaled sample
    signal scsmpl : STD_LOGIC_VECTOR(7 downto 0);    
    signal phase : STD_LOGIC_VECTOR(9 downto 0);
    signal incr : STD_LOGIC_VECTOR(23 downto 0);
    signal pwmout: STD_LOGIC;
    
    --------------------------------------------------------------------------------------------------------------------------
    -- Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 -  
    -------------------------------------------------------------------------------------------------------------------------- 
    -- 5.1: The size of the address must be adjusted depending on the number of sound font entries in the ROM
    -- For a ROM with 4 sound fonts the address must be 10-bit.
    -- Mofiy the following line to increase the size of address to 10 bits. 
    -- Look for the other part 5 changes lower in this file
    --  
    signal address : STD_LOGIC_VECTOR(9 downto 0);
    
begin
    
    
    --------------------------------------------------------------------------------------------------------------------------------
    -- Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 - Part 6 -   
    --------------------------------------------------------------------------------------------------------------------------------
    -- 6.1 Hardwired frequency
    -- The output frequency is defined as: frq = clk*incr/top
    -- The increment is defined as: incr = frq*top/clk
    -- For example:  
    --  1KHZ: 1677
    --  500Hz: 832 (496 Hz)
    -- In part 6 we want to change the frequency with the switches.
    -- Comment out the following line
    --
--    incr <= std_logic_vector(to_unsigned(832,incr'length));
        
    -- 6.2 Change the frequency using the switches. 
    -- We wish to set the frequncy with only the rigthmost 8 switches (sw 7 downto 0).
    -- However, an 8-bit value for the increment only allows to reach 152 Hz
    -- Therefore we multiply the switch value by 64 (by left-shifting by 6 bits)
    -- We also must ensure the remaining 10 most significan bits are set to 0.
    -- Therefore increment should be wired to "0000000000"&sw(7 downto 0)&"000000";
    -- Uncomment and complete the following line
    --
    incr <= "0000000000" & sw(7 downto 0) & "000000";
    --------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------


    --------------------------------------------------------------------------------------------------------------------------
    -- Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  - Part 2  -
    -------------------------------------------------------------------------------------------------------------------------- 
    -- Choose what is the current sample
    -- Depending on the lab parts the sample can be:
    --                                              * the output of the square wave from sqwdriver (sqw)
    --                                              * the phase, do generate a triangular wave
    --                                              * the output of the ROM sound bank to generate sampled sounds.
    -- The sample will then be scaled to attenuate the volume, yielding scsmpl. scsmpl is fed to the PWM generator which aims to achieve the specified amplitude.
    --
    -- 2.1: Comment below the wiring of sample to sqw
    --    sample<=sqw;
    -- 2.2: Connect instead sample to the upper 8-bits of the phase. Phase is a 10-bit signal (9 downto 0), so use only the upper 8 bits.
      --------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------- 


    
     
     
    --------------------------------------------------------------------------------------------------------------------------
    -- Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - Part 3  - 
    -------------------------------------------------------------------------------------------------------------------------- 
    -- Sound font ROM
    -- 3.1. Wire up the address to the upper 8 bits of phase
    -- Uncomment and mofiy the following line
    --
    --    address <= phase(9 downto 2);
    
    -- 3.2. Instantiate samplemem (defined in samplemem.vhd).
    -- Wire up the addressA input of samplemem to address
    -- Wire up the qA output of samplemem to wav
    -- 
    -- CORRECT (asynchronous ROM - no clock)
    -- Instantiate samplemem (ROM)
     comp_sf: entity work.samplemem port map(
     addressA => address,
     qA => wav
     );
    -- 3.3 Comment out the wiring of sample in part 2.1 and 2.2 to avoid multiple drivers errors.
    -- (modify above)
    --
    -- 3.4: Wire up sample to wav
    -- Uncomment and complete the line below
    -- 
    sample <= wav;
    --------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------


    --------------------------------------------------------------------------------------------------------------------------
    -- Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 - Part 5 -  
    --------------------------------------------------------------------------------------------------------------------------
    -- 5.1: Part 5.1 is a signal declaration change at the top of this file
    --
    -- 5.2: Comment out the wiring of address to phase in part 3.1. This is required to avoid errors (multiple drivers, width mismatch)
    --
    -- 5.3 Wire up address to a signal comprising sw(13..12) for the 2 high bits and phase (9 downto 2) for the lower 8 bits.
    -- Uncomment and modify the line below
    -- 
    -- Part 5: Address = font select (sw13-12) + sample index (phase9-2)
    address <= sw(13 downto 12) & phase(9 downto 2);
    --------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------
     
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER -- DO NOT MODIFY HEREAFER 
    --------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    
    -------------------
    -- Square wave sound.
    -- The incr signal must be wired up to some useful increment value.
    --
    comp_sqw: entity work.sqwdriver port map(clk=>clkaudio,reset=>reset,increment=>incr,sqw=>sqw,phase=>phase);

    -------------------
    -- Scaler
    -- Scale the "sample" (either square wave sqw, or output of the sample ROM) by switches sw(15..14) to attenuate the volume
    --
    comp_scaler: entity work.scaler port map(din=>sample,dout=>scsmpl,scale=>sw(15 downto 14));
    
    -------------------
    -- PWM amplitude control
    -- Map the scaled sample (scsmlp) (which is either the scaled square wave or triangle wave or scaled output of sample ROM) to the PWM generator
    --
    comp_pwm: entity work.pwmdriver port map(clk=>clkaudio,reset=>reset,vol=>scsmpl,pwmout=>pwmout);
    
    ---------------------
    -- PWM sound output and output amplifier enable
    ampPWM <= pwmout;
    ampSD <= '1';
       
    ---------------------
    -- Show status information.
    -- On the left 4 7-segment display we show the sqw output of the sqwdriver (0 or high)
    -- On the right 4 7-segment display we show the phse counter (0 to 3FFF)
    segoutr(7 downto 0)<=scsmpl;
    segoutr(15 downto 8)<="00000000";
    segoutl(9 downto 0)<=phase;
    segoutl(15 downto 10)<=(others=>'0');        

end something;
