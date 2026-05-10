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
    signal drive_clkaudio : std_logic;
    -- The "get" signals are used to get the outputs of the unit under test
    signal get_segoutl,get_segoutr: std_logic_vector(15 downto 0);
    signal get_ampPWM,get_ampSD : std_logic;
    -- File write 
    file fout : text;

begin

    -- Instantiate lab_core and wire the inputs/outputs
    core: entity work.lab_core port map(clkaudio=>drive_clkaudio,reset=>drive_reset,sw=>drive_sw,segoutl=>get_segoutl,segoutr=>get_segoutr,ampPWM=>get_ampPWM,ampSD=>get_ampSD);

    -- Split the 16 switches in two 8-bit groups for ease of use: 8-bit high group and 8-bit low group.
    drive_sw <= drive_swh&drive_swl;  

  
  
    
    -- Simuli
    -- 200KHz clock stimuli 
    proc_stim_clkaudio: process
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
        for I in 0 to 50000000 loop      
            drive_clkaudio<='0';
            wait for 50ns;
            -- Rising edge at 100ns, 300ns, 
            drive_clkaudio<='1';
            wait for 50ns;
            
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
        drive_reset<='1';
        wait for 50ns;
        drive_reset<='0';
        wait;
    end process;    
    
    -- We generate the simuli. Here we want to check all the input combinations
    stim_proc: process
    begin        
    	-- Set all the switch to initial values
        drive_swh<="00000000";
        drive_swl<="00001101";
        wait for 10 ns;
        
        --------------------
        -- Tweak the volume
        --
        
        -- Set volume to max
        drive_swh<="11000000";
        wait for 20ms;
        -- Set volume to half
        drive_swh<="10000000";
        wait for 20ms;
        -- Set volume to quarter
        drive_swh<="01000000";
        wait for 20ms;
        
        --------------------
        -- Tweak the sound shape
        --        
        -- Change the sound shape to 1 
        drive_swh<="01010000";
        wait for 20ms;
        
        -- Change the sound shape to 2 
        drive_swh<="01100000";
        wait for 20ms;
        
        -- Change the sound shape to 3 
        drive_swh<="01110000";
        wait for 20ms;
        
        --------------------
        wait for 30ms;
        
        --------------------
        -- Tweak the sound frequency
        --        
        -- 1KHz 
        drive_swl<="00011010";
        wait for 20ms;
        -- 100Hz (114Hz) 
        drive_swl<="00000011";
        wait for 20ms;
        

        
        
        
    	
  
        
    	
    	
    	   
    
        

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


