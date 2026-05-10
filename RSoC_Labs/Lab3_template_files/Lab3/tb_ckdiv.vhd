-- Test bench for the clock divider


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ckdiv is
end tb_ckdiv;

architecture testbench of tb_ckdiv is
    -- Signals driving the clock divider
    signal drive_clk: STD_LOGIC;
    signal drive_reset : STD_LOGIC;
    signal drive_top : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal getting the output of the clock divider
    signal get_sout : STD_LOGIC;
begin
    
    -- Instantiate the UUT
    ckdiv: entity work.ckdiv port map(clk=>drive_clk,reset=>drive_reset,top=>drive_top,sout=>get_sout);

    -- Clock stimuli: 
    -- Period 20ns forever
    proc_stim_clk: process
    begin
        drive_clk<='0';
        wait for 10ns;
        -- Rising edge at 10ns, 30ns, 50ns, etc.
        drive_clk<='1';
        wait for 10ns;
        
    end process;
    -- Simuli
    -- Reset stimuli: do a reset from 3-8 ns
    proc_stim_rst: process
    begin        
        drive_reset<='0';
        wait for 3ns;
        drive_reset<='1';
        wait for 5 ns;
        drive_reset<='0';
        wait;
    end process;    
    
    -- We generate the simuli. Here we want to check all the input combinations
proc_stim: process
begin        
    -- Initial: top = 0
    drive_top <= x"00000000";
    wait for 100ns;
    
    -- Set top = 4 for 640ns
    drive_top <= x"00000004";
    wait for 640ns;
    
    -- Set top = 0 for 500ns
    drive_top <= x"00000000";
    wait for 500ns;
    
    wait;
end process;

end testbench;
