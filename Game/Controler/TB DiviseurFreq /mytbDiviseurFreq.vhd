library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_DiviseurCore is
-- Empty entity for testbench
end tb_DiviseurCore;

architecture behavior of tb_DiviseurCore is 

    -- 1. Component Declaration for the Unit Under Test (UUT)
    component DiviseurCore
    port(
         CLK      : in  std_logic;
         RESET    : in  std_logic;
         FINALCLK : out std_logic
        );
    end component;
    
    -- 2. Internal Signals
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal finalclk : std_logic;

    -- 3. Clock period definition (100 MHz = 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- 4. Instantiate the Unit Under Test (UUT)
    uut: DiviseurCore 
        port map (
          CLK      => clk,
          RESET    => reset,
          FINALCLK => finalclk
        );

    -- 5. Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 6. Stimulus process (The test script)
    stim_proc: process
    begin		
        -- Step A: Assert reset
        reset <= '1';
        wait for 100 ns;	
        
        -- Step B: De-assert reset and let the counter run
        reset <= '0';
        
        -- Step C: Wait for several FINALCLK cycles to prove it works
        -- It takes 1ms for FINALCLK to toggle once, so 5ms will show ~2.5 full periods.
        wait for 5 ms; 
        
        -- Step D: Stop the simulation
        std.env.stop;
        
    end process;

end behavior;