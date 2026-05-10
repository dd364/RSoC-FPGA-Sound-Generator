-- Testbench for the lab_core
-- Must be driven with 200KHz clock


library IEEE;
library unisim;
library unifast;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- File write
use STD.textio.all;
use ieee.std_logic_textio.all;




 

entity tb_lab_core is
end tb_lab_core;



architecture testbench of tb_lab_core is

    -- The "drive" signals are used to drive the inputs of the unit under test
    signal drive_sw: std_logic_vector(15 downto 0);
    signal drive_swl,drive_swh: std_logic_vector(7 downto 0);
    signal drive_reset : std_logic;
    signal drive_clk : std_logic;
    signal drive_clk200k : std_logic;
    -- The "get" signals are used to get the outputs of the unit under test
    signal get_segout: std_logic_vector(31 downto 0);
    signal get_ampPWM,get_ampSD : std_logic;
    -- File write 
    file fout : text;

begin

    -- Instantiate lab_core and wire the inputs/outputs
    core: entity work.lab_core port map(clk=>drive_clk,clk200k=>drive_clk200k,reset=>drive_reset,sw=>drive_sw,segout=>get_segout,ampPWM=>get_ampPWM,ampSD=>get_ampSD);

    -- Split the 16 switches in two 8-bit groups for ease of use: 8-bit high group and 8-bit low group.
    drive_sw <= drive_swh&drive_swl;  

    -- Simuli
    --  25MHz clock stimuli: 40ns period, forever
    proc_stim_clk25M: process    
    begin
        drive_clk<='0';
        wait for 20ns;
        -- Rising edge at 20ns, 60ns, 100ns, etc.
        drive_clk<='1';
        wait for 20ns;
    end process;
    
    -- Simuli
    -- 200KHz clock stimuli 
    proc_stim_clkk200: process
    -------------------------------------------------------------------
    -- File write  
    variable v_line : line;
    begin
        -- File write         
        file_open(fout , "audio.dat", write_mode);
        
        -- It is important that the audio file format is respected if a tool such as sox is used for conversion or playback.
        -- sox expects a .dat file, with 2 columns: first a timestamp then the actual sample.
        
        -- Run for 5 seconds
        -- 5*200000 = 1M cycles
        for I in 0 to 1000000 loop      
            drive_clk200k<='0';
            wait for 2500ns;
            -- Rising edge at 20ns, 60ns, 100ns, etc.
            drive_clk200k<='1';
            wait for 2500ns;
            
            -- File write                     
            write(v_line, I, right, 1);
            write(v_line, string'(" "));
            write(v_line, get_ampPWM, right, 1);
            writeline(fout, v_line);           
            
        end loop;
        
        -- File write
        file_close(fout);
        
        wait;
    end process;
    
    -- Simuli
    -- Reset stimuli: do a reset from 10-30s. 
    -- The microblaze has a synchronous reset. The rising edge is at 20ns. 
    -- A reset from 10-30ns straddles the rising edge and ensures the reset. 
    proc_stim_rst: process
    begin        
        drive_reset<='0';
        wait for 10ns;
        drive_reset<='1';
        wait for 20ns;
        drive_reset<='0';
        wait;
    end process;    
    
    -- We generate the simuli. Here we want to check all the input combinations
    stim_proc: process
    begin        
        -- Start with sw(0) = 0 (Tune 0)
        drive_swl <= x"00";  -- All switches 0
        drive_swh <= x"00";
        wait for 30ms;
        
        -- Change sw(0) = 1 (Tune 1)
        drive_swl <= x"01";  -- Only LSB = 1
        wait for 30ms;
        
        -- Change back to sw(0) = 0 (Tune 0)
        drive_swl <= x"00";
        wait for 30ms;
        
        wait;
    end process;



end testbench;


--configuration cfg_xilinx of tb_lab_core
--is for testbench
--   for instance_label:component_name
--      use entity work.component_name(arch);
--       for arch
--         for all:MMCME2
--          use entity unifast.MMCME2;
--         end for;
--       for inst:DSP48E1;
--         use entity unifast.DSP48E1;
--      end for;
--   end for;
--  end for;
--end for;
--end cfg_xilinx;


