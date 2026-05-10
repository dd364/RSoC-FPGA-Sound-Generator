-- Core of the lab.
-- This entity is fed with a 200KHz clock, instead of the 100MHz clock of the FPGA board. 
-- Otherwise, all the pinout is identical to the top level.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity lab_core is
    Port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw : in  STD_LOGIC_VECTOR (15 downto 0);
        segout : out STD_LOGIC_VECTOR(31 downto 0);
        ampPWM : out STD_LOGIC;
        ampSD : out STD_LOGIC             
    );
end lab_core;

architecture something of lab_core is
    -- Signal to wire the output of the frequency generator or PWM modulator to ampPWM
    signal aud : STD_LOGIC;
    
    -- PWM signals: counter and resulting PWM square wave
    signal pwmctr : integer range 0 to 9 := 0;
    signal pwmsqw : STD_LOGIC;
    signal pwmvol : integer range 0 to 10 := 5;

    --------------------------------------------------------------------------------------------------------
    -- PART 5: notediv signal for switch-controlled frequency
    --------------------------------------------------------------------------------------------------------
    signal notediv : STD_LOGIC_VECTOR(31 downto 0);    
    
    --------------------------------------------------------------------------------------------------------
    -- PART 8: Note sequencing
    --------------------------------------------------------------------------------------------------------
    signal notectr : integer range 0 to 3 := 0;
    signal noteclk : STD_LOGIC;
    
    --------------------------------------------------------------------------------------------------------
    -- PART 9: Helper signals for notes (ACTIVE)
    --------------------------------------------------------------------------------------------------------
    signal na5: STD_LOGIC_VECTOR(31 downto 0);   -- A5 (880 Hz)
    signal nb5: STD_LOGIC_VECTOR(31 downto 0);   -- B5 (988 Hz)
    signal ng5: STD_LOGIC_VECTOR(31 downto 0);   -- G5 (784 Hz)
    signal nf5: STD_LOGIC_VECTOR(31 downto 0);   -- F5 (698 Hz)
    signal ne5: STD_LOGIC_VECTOR(31 downto 0);   -- E5 (659 Hz)
    signal nd5: STD_LOGIC_VECTOR(31 downto 0);   -- D5 (587 Hz)
    signal nb4: STD_LOGIC_VECTOR(31 downto 0);   -- B4 (494 Hz)
    signal ng4: STD_LOGIC_VECTOR(31 downto 0);   -- G4 (392 Hz)
    signal nspc: STD_LOGIC_VECTOR(31 downto 0);  -- Silence

begin

    -- Display
    segout <= (others=>'0');
    
    --------------------------------------------------------------------------------------------------------
    -- PART 9: Assign frequency values to note helpers
    --------------------------------------------------------------------------------------------------------
    nb5 <= std_logic_vector(to_unsigned(100, 32));   -- B5 ≈ 990 Hz
    na5 <= std_logic_vector(to_unsigned(113, 32));   -- A5 ≈ 877 Hz
    ng5 <= std_logic_vector(to_unsigned(127, 32));   -- G5 ≈ 781 Hz
    nf5 <= std_logic_vector(to_unsigned(142, 32));   -- F5 ≈ 699 Hz
    ne5 <= std_logic_vector(to_unsigned(151, 32));   -- E5 ≈ 658 Hz
    nd5 <= std_logic_vector(to_unsigned(169, 32));   -- D5 ≈ 588 Hz
    nb4 <= std_logic_vector(to_unsigned(201, 32));   -- B4 ≈ 495 Hz
    ng4 <= std_logic_vector(to_unsigned(254, 32));   -- G4 ≈ 392 Hz
    nspc <= x"FFFFFFFF";                              -- Silence

    --------------------------------------------------------------------------------------------------------
    -- Sound Generation
    --------------------------------------------------------------------------------------------------------
    
    -- PART 9: Note-controlled frequency using helper signals
    notediv <= ng5 when notectr = 0 else   -- G5 (784 Hz)
               nf5 when notectr = 1 else   -- F5 (698 Hz)
               ne5 when notectr = 2 else   -- E5 (659 Hz)
               nd5;                         -- D5 (587 Hz)
    
    -- Clock divider for audio frequency
    sndgen: entity work.ckdiv port map(clk=>clk, reset=>reset, top=>notediv, sout=>aud);

    --------------------------------------------------------------------------------------------------------
    -- PART 8: Note sequencing
    --------------------------------------------------------------------------------------------------------
    
    -- Generate 5Hz clock (200ms period)
    noteclkdiv: entity work.ckdiv port map(
        clk => clk,
        reset => reset,
        top => std_logic_vector(to_unsigned(19999, 32)),
        sout => noteclk
    );
    
    -- Note counter
    process(noteclk, reset)                                                                           
    begin
        if reset = '1' then
            notectr <= 0;
        else    
            if rising_edge(noteclk) then
                if notectr = 3 then
                    notectr <= 0;
                else
                    notectr <= notectr + 1;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------------------------------
    -- PART 7: PWM volume controlled by switches
    --------------------------------------------------------------------------------------------------------
    pwmvol <= to_integer(unsigned(sw(7 downto 0))) / 25;

    --------------------------------------------------------------------------------------------------------
    -- PART 6: PWM Generation
    --------------------------------------------------------------------------------------------------------
    
    process(clk, reset)                                                                           
    begin
        if reset = '1' then
            pwmctr <= 0;
        else    
            if rising_edge(clk) then
                if pwmctr = 9 then
                    pwmctr <= 0;
                else
                    pwmctr <= pwmctr + 1;
                end if;                
            end if;
        end if;
    end process;
    
    pwmsqw <= '1' when pwmctr < pwmvol else '0';
    ampPWM <= aud and pwmsqw;
    
    --------------------------------------------------------------------------------------------------------
    -- DO NOT MODIFY HEREAFTER
    --------------------------------------------------------------------------------------------------------
    
    ampSD <= '1';
    
end something;