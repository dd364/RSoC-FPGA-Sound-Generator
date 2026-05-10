-- Testbench for the lab_core
-- Must be driven with 200KHz clock

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity tb_lab_core is
end tb_lab_core;

architecture testbench of tb_lab_core is

    -- The "drive" signals are used to drive the inputs of the unit under test
    signal drive_sw: std_logic_vector(15 downto 0);
    signal drive_swl, drive_swh: std_logic_vector(7 downto 0);
    signal drive_reset : std_logic;
    signal drive_clk : std_logic;
    -- The "get" signals are used to get the outputs of the unit under test
    signal get_segout: std_logic_vector(31 downto 0);
    signal get_ampPWM, get_ampSD: std_logic;
    
    file fout : text;

begin

    -- Instantiate lab_core and wire the inputs/outputs
    core: entity work.lab_core port map(
        clk => drive_clk,
        reset => drive_reset,
        sw => drive_sw,
        segout => get_segout,
        ampPWM => get_ampPWM,
        ampSD => get_ampSD
    );

    -- Split the 16 switches in two 8-bit groups
    drive_sw <= drive_swh & drive_swl;  

    -- Clock stimuli: 200KHz -> 5000ns period
    proc_stim_clk: process
        variable v_line : line;
    begin
        file_open(fout, "audio.dat", write_mode);
        
        -- Run for 1 second (200,000 cycles at 200kHz)
        for I in 0 to 200000 loop      
            drive_clk <= '0';
            wait for 2500ns;
            drive_clk <= '1';
            wait for 2500ns;
            
            write(v_line, I, right, 1);
            write(v_line, string'(" "));
            write(v_line, get_ampPWM, right, 1);
            writeline(fout, v_line);           
        end loop;
        
        file_close(fout);
        wait;
    end process;
    
    -- Reset stimuli
    proc_stim_rst: process
    begin        
        drive_reset <= '0';
        wait for 50ns;
        drive_reset <= '1';
        wait for 50ns;
        drive_reset <= '0';
        wait;
    end process;    
    
    -- Stimuli generation process
    stim_proc: process
    begin        
        -- Set volume to maximum
        drive_swl <= std_logic_vector(to_unsigned(250, 8));
        
        -- Frequency switches not used in Part 8 (internal sequencer controls frequency)
        drive_swh <= std_logic_vector(to_unsigned(0, 8));
        
        wait;
    end process;

end testbench;